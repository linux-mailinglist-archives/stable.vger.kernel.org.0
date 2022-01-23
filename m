Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96655496F32
	for <lists+stable@lfdr.de>; Sun, 23 Jan 2022 01:17:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236026AbiAWARO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Jan 2022 19:17:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236127AbiAWAPv (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Jan 2022 19:15:51 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84BCAC061775;
        Sat, 22 Jan 2022 16:14:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 058D4CE0AE1;
        Sun, 23 Jan 2022 00:14:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8A2CC340E5;
        Sun, 23 Jan 2022 00:14:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642896870;
        bh=I6JUIP3YQtj+ZM5pthyUzl9iUgDWByA3Z3meRZYFfzg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MJOMKgLHtlOdJS4ZYKgqG0mi1ZFp9XI+KTCuq5awe1TksvbcFCQ6uBLMOOZ+OV+WT
         J0Td7SmeBrrquzTy/6fPtL9576TqhxiF7ktfQMDIOhtsksZ7BpQLsbHGf7y1VOFjTb
         TrRbEddVhi+TyV2WNF69Hocxci60Mp3eh++XidYB5GWLzacJDYk1Gna8HBU5ASymop
         m+sCvnKJ5tfEd5CMciGKrm7vNxi7JVN0PARuI0hV801E5Cl9Z79itd2REkHrYmU3Q+
         l7R0GHa/ZSR45cqBraxx1qeA/uM0x3gIoGzCiq0AVQnYVcEp4YO89A4fAXsGO0QWyw
         M664Uvi05H7dg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?=E7=8E=8B=E8=B4=87?= <yun.wang@linux.alibaba.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Sasha Levin <sashal@kernel.org>, jasowang@redhat.com,
        virtualization@lists.linux-foundation.org
Subject: [PATCH AUTOSEL 4.9 3/4] virtio-pci: fix the confusing error message
Date:   Sat, 22 Jan 2022 19:14:20 -0500
Message-Id: <20220123001423.2461009-3-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220123001423.2461009-1-sashal@kernel.org>
References: <20220123001423.2461009-1-sashal@kernel.org>
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
index fbc4761987e85..be4e099c117ac 100644
--- a/drivers/virtio/virtio_pci_legacy.c
+++ b/drivers/virtio/virtio_pci_legacy.c
@@ -143,7 +143,7 @@ static struct virtqueue *setup_vq(struct virtio_pci_device *vp_dev,
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

