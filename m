Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43C8827CA56
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 14:19:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731920AbgI2MS0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 08:18:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:55996 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729974AbgI2LgV (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:36:21 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C358023E24;
        Tue, 29 Sep 2020 11:31:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601379095;
        bh=4dZeExV5m9YmaEEXt9XuEf/XrmsgGX7WgJ9Hprr9dkg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HjFzuu0qyq1lhIp+xO3QvSh3At+G1X0Dt284cstdW0d/evbip7Hfw+B24jKcO+4FU
         DyQSMlipCQ9StPW7NvVNpQiDE6rvPhVhatdqd4Qu/VTKJteWDqc70SLls9EXATgIgv
         NHiXFcV7lyXFd7SKT3vovC3/unSFZns87Dhj1+8U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Pierre=20Cr=C3=A9gut?= <pierre.cregut@orange.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 012/388] PCI/IOV: Serialize sysfs sriov_numvfs reads vs writes
Date:   Tue, 29 Sep 2020 12:55:43 +0200
Message-Id: <20200929110011.081821667@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929110010.467764689@linuxfoundation.org>
References: <20200929110010.467764689@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pierre Crégut <pierre.cregut@orange.com>

[ Upstream commit 35ff867b76576e32f34c698ccd11343f7d616204 ]

When sriov_numvfs is being updated, we call the driver->sriov_configure()
function, which may enable VFs and call probe functions, which may make new
devices visible.  This all happens before before sriov_numvfs_store()
updates sriov->num_VFs, so previously, concurrent sysfs reads of
sriov_numvfs returned stale values.

Serialize the sysfs read vs the write so the read returns the correct
num_VFs value.

[bhelgaas: hold device_lock instead of checking mutex_is_locked()]
Link: https://bugzilla.kernel.org/show_bug.cgi?id=202991
Link: https://lore.kernel.org/r/20190911072736.32091-1-pierre.cregut@orange.com
Signed-off-by: Pierre Crégut <pierre.cregut@orange.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/iov.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/pci/iov.c b/drivers/pci/iov.c
index deec9f9e0b616..9c116cbaa95d8 100644
--- a/drivers/pci/iov.c
+++ b/drivers/pci/iov.c
@@ -253,8 +253,14 @@ static ssize_t sriov_numvfs_show(struct device *dev,
 				 char *buf)
 {
 	struct pci_dev *pdev = to_pci_dev(dev);
+	u16 num_vfs;
+
+	/* Serialize vs sriov_numvfs_store() so readers see valid num_VFs */
+	device_lock(&pdev->dev);
+	num_vfs = pdev->sriov->num_VFs;
+	device_unlock(&pdev->dev);
 
-	return sprintf(buf, "%u\n", pdev->sriov->num_VFs);
+	return sprintf(buf, "%u\n", num_vfs);
 }
 
 /*
-- 
2.25.1



