Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50B07496E7E
	for <lists+stable@lfdr.de>; Sun, 23 Jan 2022 01:12:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235428AbiAWAMn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Jan 2022 19:12:43 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:40848 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235284AbiAWAMH (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Jan 2022 19:12:07 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A8163B80B19;
        Sun, 23 Jan 2022 00:12:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7B6BC340E4;
        Sun, 23 Jan 2022 00:12:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642896725;
        bh=38RC1PJn8/37II7ZwgeuvRYEswuHJdj9JkLG7IReO1Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LicHFLk5srb4l6W1Ds4Td+WSjaCvGqee0iBfpAlpy6frqVABclowkuUp/FDKNMUbs
         7zUK3OLtSbMj89bCxMp54ahS8vd+FDOpTYgE1LTIL5yavn6TEYTM4MSLZwof4xPatP
         lCRR3yptPvxDBWqywWg729ZyxsC3u9U2NP2iAd4gzKdaH0VtB78pWuwy6mY9cdcWfL
         +VT22Sc9jjhWhRGbEOYgugez2rHp9nEc6GJDqXOglZ3yd6AunscxOaZevhWZD/cKhV
         bswVaKGG8rNqGYdX6PzhaG9auqAWIdqH2nRRIDmjQGJbh9XKAIUV/CNFxfPX7nh0m2
         a/S5Yg+9FsHIw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?=E7=8E=8B=E8=B4=87?= <yun.wang@linux.alibaba.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Sasha Levin <sashal@kernel.org>, jasowang@redhat.com,
        virtualization@lists.linux-foundation.org
Subject: [PATCH AUTOSEL 5.16 14/19] virtio-pci: fix the confusing error message
Date:   Sat, 22 Jan 2022 19:11:07 -0500
Message-Id: <20220123001113.2460140-14-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220123001113.2460140-1-sashal@kernel.org>
References: <20220123001113.2460140-1-sashal@kernel.org>
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
index b3f8128b7983b..34141b9abe278 100644
--- a/drivers/virtio/virtio_pci_legacy.c
+++ b/drivers/virtio/virtio_pci_legacy.c
@@ -138,7 +138,7 @@ static struct virtqueue *setup_vq(struct virtio_pci_device *vp_dev,
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

