Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B45161FE29A
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 04:03:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730292AbgFRCC7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jun 2020 22:02:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:57584 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727092AbgFRBXn (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jun 2020 21:23:43 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C5B3D20B1F;
        Thu, 18 Jun 2020 01:23:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592443422;
        bh=kZs7yTu0LGA3GelZtkTTklM55dg2istBIFGH5972M80=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tZNU7Ihi7XOrBEmQ64vVmm363PYdHKPiGFbEo1z5pfXlgPlvXIbukmlPhdbpa766X
         /L7zwMd4kqpgmOA8HLCzGusmN7oqrRun4MZyFkrb8SivsODxh4FVjc+o7RhmCHhADJ
         0GNMaEB3WZ85wPxZPWMG04xCPOAmFUCG7dR5yFhQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Xiyu Yang <xiyuyang19@fudan.edu.cn>,
        Xin Tan <tanxin.ctf@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, devel@driverdev.osuosl.org
Subject: [PATCH AUTOSEL 4.19 063/172] staging: gasket: Fix mapping refcnt leak when register/store fails
Date:   Wed, 17 Jun 2020 21:20:29 -0400
Message-Id: <20200618012218.607130-63-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200618012218.607130-1-sashal@kernel.org>
References: <20200618012218.607130-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xiyu Yang <xiyuyang19@fudan.edu.cn>

[ Upstream commit e3436ce60cf5f5eaedda2b8c622f69feb97595e2 ]

gasket_sysfs_register_store() invokes get_mapping(), which returns a
reference of the specified gasket_sysfs_mapping object to "mapping" with
increased refcnt.

When gasket_sysfs_register_store() returns, local variable "mapping"
becomes invalid, so the refcount should be decreased to keep refcount
balanced.

The reference counting issue happens in one exception handling path of
gasket_sysfs_register_store(). When gasket_dev is NULL, the function
forgets to decrease the refcnt increased by get_mapping(), causing a
refcnt leak.

Fix this issue by calling put_mapping() when gasket_dev is NULL.

Signed-off-by: Xiyu Yang <xiyuyang19@fudan.edu.cn>
Signed-off-by: Xin Tan <tanxin.ctf@gmail.com>
Link: https://lore.kernel.org/r/1587618941-13718-1-git-send-email-xiyuyang19@fudan.edu.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/gasket/gasket_sysfs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/gasket/gasket_sysfs.c b/drivers/staging/gasket/gasket_sysfs.c
index 9c982f1c0881..5986c67bc7ec 100644
--- a/drivers/staging/gasket/gasket_sysfs.c
+++ b/drivers/staging/gasket/gasket_sysfs.c
@@ -377,6 +377,7 @@ ssize_t gasket_sysfs_register_store(struct device *device,
 	gasket_dev = mapping->gasket_dev;
 	if (!gasket_dev) {
 		dev_err(device, "Device driver may have been removed\n");
+		put_mapping(mapping);
 		return 0;
 	}
 
-- 
2.25.1

