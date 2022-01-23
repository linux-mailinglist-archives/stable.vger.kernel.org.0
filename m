Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25B12496EE7
	for <lists+stable@lfdr.de>; Sun, 23 Jan 2022 01:15:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235786AbiAWAPM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Jan 2022 19:15:12 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:46648 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231290AbiAWAOL (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Jan 2022 19:14:11 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 430AACE0ACD;
        Sun, 23 Jan 2022 00:14:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B84DC340E9;
        Sun, 23 Jan 2022 00:14:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642896848;
        bh=OksXVQlW/gPJ9LytV3kqPMDJ6mNVmLh35P/E7cdZ5+s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q5oD0NH6hx1iOgMtCwnm/zhiPl2lCFsKFSWBjxLT+isbdqlDC6bgdh5giF7TYE+KS
         juggp7Tqt6SnE0N14TrKdEc7+jd8zNcoYWdivtwrx6LZ5VKrLePzEzCGyxoUUqSHwM
         ULDAOkeZagOJwOlj1HD523v9smPHDeHTvQktVy5qOkhxB1gvZhivF3CQ8jLMWxc55/
         follhv02K9ktRsMsVnzbsBrfD3QA0k5gO4g+EqDO8GKrGX7x5QG6zoWJsUdzTAHP06
         Q4jQzm4jaUEsTEytQk09+FVWG9iF3aG7J0YCCI7UZfRzozr1lAoCpK9kFGhn7mGIk7
         JorwN8lWhmiHg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?=E7=8E=8B=E8=B4=87?= <yun.wang@linux.alibaba.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Sasha Levin <sashal@kernel.org>, jasowang@redhat.com,
        virtualization@lists.linux-foundation.org
Subject: [PATCH AUTOSEL 4.19 4/5] virtio-pci: fix the confusing error message
Date:   Sat, 22 Jan 2022 19:13:50 -0500
Message-Id: <20220123001353.2460870-4-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220123001353.2460870-1-sashal@kernel.org>
References: <20220123001353.2460870-1-sashal@kernel.org>
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
index de062fb201bc2..61add42862017 100644
--- a/drivers/virtio/virtio_pci_legacy.c
+++ b/drivers/virtio/virtio_pci_legacy.c
@@ -145,7 +145,7 @@ static struct virtqueue *setup_vq(struct virtio_pci_device *vp_dev,
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

