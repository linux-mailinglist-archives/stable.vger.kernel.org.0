Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5E6B3D5F56
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 18:00:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236748AbhGZPRe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:17:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:53028 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237428AbhGZPPp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:15:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9600D61040;
        Mon, 26 Jul 2021 15:55:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627314918;
        bh=xoeTu/ciy1ZBjGG7vZFaW5uf4HESNU5jCY6YOJCYCMg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aeQdAKhfE49HSUIvskgn31T/2AyGooYzGab0Ew7zekhTwZQRDOXXCDyJ31ua64Y8w
         unuao/8xYBQJLuqyr6ypezeoARf5w5dJgd6/4ByVDA9qXWIyoQXOpTnSKHD4ZEcfNa
         GYZrT97NIxU2lzm34ODohUMsdnsYtXxBfQkiG9ec=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Casey Chen <cachen@purestorage.com>,
        Keith Busch <kbusch@kernel.org>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 019/108] nvme-pci: do not call nvme_dev_remove_admin from nvme_remove
Date:   Mon, 26 Jul 2021 17:38:20 +0200
Message-Id: <20210726153832.309371513@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153831.696295003@linuxfoundation.org>
References: <20210726153831.696295003@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Casey Chen <cachen@purestorage.com>

[ Upstream commit 251ef6f71be2adfd09546a26643426fe62585173 ]

nvme_dev_remove_admin could free dev->admin_q and the admin_tagset
while they are being accessed by nvme_dev_disable(), which can be called
by nvme_reset_work via nvme_remove_dead_ctrl.

Commit cb4bfda62afa ("nvme-pci: fix hot removal during error handling")
intended to avoid requests being stuck on a removed controller by killing
the admin queue. But the later fix c8e9e9b7646e ("nvme-pci: unquiesce
admin queue on shutdown"), together with nvme_dev_disable(dev, true)
right before nvme_dev_remove_admin() could help dispatch requests and
fail them early, so we don't need nvme_dev_remove_admin() any more.

Fixes: cb4bfda62afa ("nvme-pci: fix hot removal during error handling")
Signed-off-by: Casey Chen <cachen@purestorage.com>
Reviewed-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/pci.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index 2cb2ead7615b..f9dba1a3e655 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -2954,7 +2954,6 @@ static void nvme_remove(struct pci_dev *pdev)
 	if (!pci_device_is_present(pdev)) {
 		nvme_change_ctrl_state(&dev->ctrl, NVME_CTRL_DEAD);
 		nvme_dev_disable(dev, true);
-		nvme_dev_remove_admin(dev);
 	}
 
 	flush_work(&dev->ctrl.reset_work);
-- 
2.30.2



