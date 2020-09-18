Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08C0726F48C
	for <lists+stable@lfdr.de>; Fri, 18 Sep 2020 05:15:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730672AbgIRDPV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Sep 2020 23:15:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:45806 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726375AbgIRCB3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 17 Sep 2020 22:01:29 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C7A682311D;
        Fri, 18 Sep 2020 02:01:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600394487;
        bh=4dZeExV5m9YmaEEXt9XuEf/XrmsgGX7WgJ9Hprr9dkg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tsQt0YHosRtojE/1ptfYBfXYjAfV4hIzCFduwBUzTFfC5DY05yXPSFe4YTNkKmc23
         uFscyjlllHsZqcKNaSuc2LFvIoeoY7OUFAB5oUd7GIx+qx16aJ0xBDc7TaCBQloIEF
         Mp2RqcPd/CwKb7ogqp67gMzVA4zqmYAeLTsql478=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Pierre=20Cr=C3=A9gut?= <pierre.cregut@orange.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Sasha Levin <sashal@kernel.org>, linux-pci@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 013/330] PCI/IOV: Serialize sysfs sriov_numvfs reads vs writes
Date:   Thu, 17 Sep 2020 21:55:53 -0400
Message-Id: <20200918020110.2063155-13-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200918020110.2063155-1-sashal@kernel.org>
References: <20200918020110.2063155-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
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

