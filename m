Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6C823F63C8
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 18:58:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238457AbhHXQ6M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 12:58:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:38972 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234451AbhHXQ5h (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Aug 2021 12:57:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3078B61414;
        Tue, 24 Aug 2021 16:56:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629824212;
        bh=aUFHNpRV7mY+71E2wirnUi9kGGYnChRWtQHqWCR75OI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PTIfTicRkeZ0I0DnpCvxGZF56nHeEidywVHOEsnxL/waN2XzeBIDrEBQZ0mdB4dIH
         mfUP9t8CvKM/gcWChlu4sDS5LYq053MYmPrx61If+AxouvsTZYu/3U9b5CpI/i837u
         gpLrSTag9CN4MVkrspKOhyNcfD9OXDJtdmdNap43RUphWAiSyzRHwOjM7ZQofqVVku
         8Q9b/rx2YD/5ZHRlTWYoNIALSdABsNeygzWwQZujomJcp9jgHCvZRXnGSpoTrdnYB9
         Z7zC5Km2PJ/D9Dp47cl0kgtcrNAuBZ1GtpSLrVHxJIgj9TRzwOoVvIPQMefHeiRFPm
         f4czKlsYtHqrg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Xie Yongji <xieyongji@bytedance.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 044/127] vp_vdpa: Fix return value check for vdpa_alloc_device()
Date:   Tue, 24 Aug 2021 12:54:44 -0400
Message-Id: <20210824165607.709387-45-sashal@kernel.org>
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

[ Upstream commit 9632e78e82648aa98340df78eab9106f63da151e ]

The vdpa_alloc_device() returns an error pointer upon
failure, not NULL. To handle the failure correctly, this
replaces NULL check with IS_ERR() check and propagate the
error upwards.

Fixes: 64b9f64f80a6 ("vdpa: introduce virtio pci driver")
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Xie Yongji <xieyongji@bytedance.com>
Link: https://lore.kernel.org/r/20210715080026.242-2-xieyongji@bytedance.com
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Acked-by: Jason Wang <jasowang@redhat.com>
Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vdpa/virtio_pci/vp_vdpa.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/vdpa/virtio_pci/vp_vdpa.c b/drivers/vdpa/virtio_pci/vp_vdpa.c
index 9145e0624565..54b313e4e63f 100644
--- a/drivers/vdpa/virtio_pci/vp_vdpa.c
+++ b/drivers/vdpa/virtio_pci/vp_vdpa.c
@@ -400,9 +400,9 @@ static int vp_vdpa_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 
 	vp_vdpa = vdpa_alloc_device(struct vp_vdpa, vdpa,
 				    dev, &vp_vdpa_ops, NULL);
-	if (vp_vdpa == NULL) {
+	if (IS_ERR(vp_vdpa)) {
 		dev_err(dev, "vp_vdpa: Failed to allocate vDPA structure\n");
-		return -ENOMEM;
+		return PTR_ERR(vp_vdpa);
 	}
 
 	mdev = &vp_vdpa->mdev;
-- 
2.30.2

