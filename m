Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81EF6496EA7
	for <lists+stable@lfdr.de>; Sun, 23 Jan 2022 01:13:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235445AbiAWANj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Jan 2022 19:13:39 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:45906 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235446AbiAWAMv (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Jan 2022 19:12:51 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 66472CE0ACB;
        Sun, 23 Jan 2022 00:12:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFB40C340E7;
        Sun, 23 Jan 2022 00:12:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642896767;
        bh=r/Y07ZyV6TUV05w7OeUWXtVCO1ajHkTeHmjd4WcHEPY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ULVeoVb3kM0+hKPGWdh1mLLQ0AN3HPgc1H1rom6S/mA116JUYZ2YAyqldGqjPwYoi
         A6+lPZ/eI5o2iQBa2HdD0gkggHKYL/NTHgLuT+vkf6vTNfQOdRwYfkCzJota5PIGXN
         cccK0QQIoaW7rVCsUhvztwiDDWvSgRmiqDvxqPp9J+QOM2KrEpleTozL2yaAhiS0cK
         JCaf25q2La6J+/2/qjy+5nGBlBFGKdGHDnWeGimrBi7D7dsM342tDWQyzhgWN6ZeJK
         peaTP3tHJn1j4plNCnMCtsWOuB6YmTXJnS05ErxUBQODvmCnaFdQe/vS/NpMmVvLzU
         2mbVJPZ4/tE6Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?=E7=8E=8B=E8=B4=87?= <yun.wang@linux.alibaba.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Sasha Levin <sashal@kernel.org>, jasowang@redhat.com,
        virtualization@lists.linux-foundation.org
Subject: [PATCH AUTOSEL 5.15 11/16] virtio-pci: fix the confusing error message
Date:   Sat, 22 Jan 2022 19:12:10 -0500
Message-Id: <20220123001216.2460383-11-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220123001216.2460383-1-sashal@kernel.org>
References: <20220123001216.2460383-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: 王贇 <yun.wang@linux.alibaba.com>

[ Upstream commit 6017599bb25c20b7a68cbb8e7d534bdc1c36b5e4 ]

The error message on the failure of pfn check should tell
virtio-pci rather than virtio-mmio, just fix it.

Signed-off-by: Michael Wang <yun.wang@linux.alibaba.com>
Suggested-by: Michael S. Tsirkin <mst@redhat.com>
Link: https://lore.kernel.org/r/ae5e154e-ac59-f0fa-a7c7-091a2201f581@linux.alibaba.com
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/virtio/virtio_pci_legacy.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/virtio/virtio_pci_legacy.c b/drivers/virtio/virtio_pci_legacy.c
index d62e9835aeeca..0ede3bf43669d 100644
--- a/drivers/virtio/virtio_pci_legacy.c
+++ b/drivers/virtio/virtio_pci_legacy.c
@@ -144,7 +144,7 @@ static struct virtqueue *setup_vq(struct virtio_pci_device *vp_dev,
 	q_pfn = virtqueue_get_desc_addr(vq) >> VIRTIO_PCI_QUEUE_ADDR_SHIFT;
 	if (q_pfn >> 32) {
 		dev_err(&vp_dev->pci_dev->dev,
-			"platform bug: legacy virtio-mmio must not be used with RAM above 0x%llxGB\n",
+			"platform bug: legacy virtio-pci must not be used with RAM above 0x%llxGB\n",
 			0x1ULL << (32 + PAGE_SHIFT - 30));
 		err = -E2BIG;
 		goto out_del_vq;
-- 
2.34.1

