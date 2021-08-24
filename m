Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40FBF3F63C9
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 18:58:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238474AbhHXQ6N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 12:58:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:38858 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235005AbhHXQ5h (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Aug 2021 12:57:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 517DD611AF;
        Tue, 24 Aug 2021 16:56:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629824213;
        bh=rimgFvUleR9VZUN3vmff9gSZtwLT1iP7hG8qVkf3WPc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qO61OUwCoyF8lS5igkFdqeTRjK11PiLdL/AtTj36psoS3uUaz6H8fuf+gvpS5zYWS
         Gbu1/MpAMijFc/6zX2mgSNtWJva8fI0X9VWAsG5jAZgYWUfMXS7OgmsTp9LxWh7nWE
         9Lo0xGT86dl7pgjc01aVAoCoWTCQNkBxqm4QpGXXJb/YTqr8BsDJfgn5prfCKtGxd2
         +0EcWAgCAW7NwmvPlfYChSV8+/vkjALmVc3cJWv6kwR6ralROyxhD0bF6xUhYyT3+1
         HRyOzaGwIG236f4UuTT0yp6uTxjupzHHbGRxRkjhHszKP7JmeocwOWV3dKGGLUhW/+
         giTweLMNkJQLQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Xie Yongji <xieyongji@bytedance.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 045/127] vDPA/ifcvf: Fix return value check for vdpa_alloc_device()
Date:   Tue, 24 Aug 2021 12:54:45 -0400
Message-Id: <20210824165607.709387-46-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824165607.709387-1-sashal@kernel.org>
References: <20210824165607.709387-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.13.13-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.13.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.13.13-rc1
X-KernelTest-Deadline: 2021-08-26T16:55+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xie Yongji <xieyongji@bytedance.com>

[ Upstream commit 1057afa0121db8bd3ca4718c8e0ca12388ab7759 ]

The vdpa_alloc_device() returns an error pointer upon
failure, not NULL. To handle the failure correctly, this
replaces NULL check with IS_ERR() check and propagate the
error upwards.

Fixes: 5a2414bc454e ("virtio: Intel IFC VF driver for VDPA")
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Xie Yongji <xieyongji@bytedance.com>
Link: https://lore.kernel.org/r/20210715080026.242-3-xieyongji@bytedance.com
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Acked-by: Jason Wang <jasowang@redhat.com>
Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vdpa/ifcvf/ifcvf_main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/vdpa/ifcvf/ifcvf_main.c b/drivers/vdpa/ifcvf/ifcvf_main.c
index ab0ab5cf0f6e..1c6cd5276a50 100644
--- a/drivers/vdpa/ifcvf/ifcvf_main.c
+++ b/drivers/vdpa/ifcvf/ifcvf_main.c
@@ -477,9 +477,9 @@ static int ifcvf_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 
 	adapter = vdpa_alloc_device(struct ifcvf_adapter, vdpa,
 				    dev, &ifc_vdpa_ops, NULL);
-	if (adapter == NULL) {
+	if (IS_ERR(adapter)) {
 		IFCVF_ERR(pdev, "Failed to allocate vDPA structure");
-		return -ENOMEM;
+		return PTR_ERR(adapter);
 	}
 
 	pci_set_master(pdev);
-- 
2.30.2

