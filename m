Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EEA2C99ACC
	for <lists+stable@lfdr.de>; Thu, 22 Aug 2019 19:17:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389088AbfHVRPx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Aug 2019 13:15:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:58274 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390428AbfHVRIj (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Aug 2019 13:08:39 -0400
Received: from sasha-vm.mshome.net (wsip-184-188-36-2.sd.sd.cox.net [184.188.36.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B5247233FD;
        Thu, 22 Aug 2019 17:08:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566493719;
        bh=JRxs4CjZsR9Mwk1SkqyAGfhLAqxCj8GtLVUw0Wj+tr8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aEUILieXTTBA43BxI7EAcuB3muCrqYVhIsVHW+E9XA0XYYoUw3xCKEkvCTvAY3Ma1
         cjgUx1gDN1Oj46KsyQHF2e/aayY1e6qSQrdyHWa3Tl/rPpsweVFGPjt2aGcws8wQCO
         FnuEG3Q5ReRhqupmWoGP9Lv9Y/sJWMsr4+kEKueM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     YueHaibing <yuehaibing@huawei.com>, Hulk Robot <hulkci@huawei.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Juergen Gross <jgross@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 046/135] xen/pciback: remove set but not used variable 'old_state'
Date:   Thu, 22 Aug 2019 13:06:42 -0400
Message-Id: <20190822170811.13303-47-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190822170811.13303-1-sashal@kernel.org>
References: <20190822170811.13303-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.2.10-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.2.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.2.10-rc1
X-KernelTest-Deadline: 2019-08-24T17:07+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>

[ Upstream commit 09e088a4903bd0dd911b4f1732b250130cdaffed ]

Fixes gcc '-Wunused-but-set-variable' warning:

drivers/xen/xen-pciback/conf_space_capability.c: In function pm_ctrl_write:
drivers/xen/xen-pciback/conf_space_capability.c:119:25: warning:
 variable old_state set but not used [-Wunused-but-set-variable]

It is never used so can be removed.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Reviewed-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Signed-off-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/xen/xen-pciback/conf_space_capability.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/xen/xen-pciback/conf_space_capability.c b/drivers/xen/xen-pciback/conf_space_capability.c
index 73427d8e01161..e5694133ebe57 100644
--- a/drivers/xen/xen-pciback/conf_space_capability.c
+++ b/drivers/xen/xen-pciback/conf_space_capability.c
@@ -116,13 +116,12 @@ static int pm_ctrl_write(struct pci_dev *dev, int offset, u16 new_value,
 {
 	int err;
 	u16 old_value;
-	pci_power_t new_state, old_state;
+	pci_power_t new_state;
 
 	err = pci_read_config_word(dev, offset, &old_value);
 	if (err)
 		goto out;
 
-	old_state = (pci_power_t)(old_value & PCI_PM_CTRL_STATE_MASK);
 	new_state = (pci_power_t)(new_value & PCI_PM_CTRL_STATE_MASK);
 
 	new_value &= PM_OK_BITS;
-- 
2.20.1

