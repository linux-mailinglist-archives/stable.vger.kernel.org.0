Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C7585145158
	for <lists+stable@lfdr.de>; Wed, 22 Jan 2020 10:53:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729906AbgAVJfN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jan 2020 04:35:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:50148 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731155AbgAVJfN (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Jan 2020 04:35:13 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AEE072071E;
        Wed, 22 Jan 2020 09:35:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579685712;
        bh=WuYRffSgBX86O5J9D4bEgZ3JshmLgnXCdJv7qzipHAo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WNUcrm0Nuqp3m0+0AJ6EV2SUzD06VAdb/z7xFwmRaRfQgmsT6MaSdVMlHbHt7+8oF
         XagsWqNOY+NcZRfOxCaaj3LFcoWlYpp5pSAjsSNw+SmvASqp9pTPxGwG0Q6jPpPN53
         78qRX/z79KyZ/kh/gquh+jtCG/lfcT5AlaqQ2E2k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alexander Barabash <alexander.barabash@dell.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 47/97] ioat: ioat_alloc_ring() failure handling.
Date:   Wed, 22 Jan 2020 10:28:51 +0100
Message-Id: <20200122092804.100092205@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200122092755.678349497@linuxfoundation.org>
References: <20200122092755.678349497@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander.Barabash@dell.com <Alexander.Barabash@dell.com>

[ Upstream commit b0b5ce1010ffc50015eaec72b0028aaae3f526bb ]

If dma_alloc_coherent() returns NULL in ioat_alloc_ring(), ring
allocation must not proceed.

Until now, if the first call to dma_alloc_coherent() in
ioat_alloc_ring() returned NULL, the processing could proceed, failing
with NULL-pointer dereferencing further down the line.

Signed-off-by: Alexander Barabash <alexander.barabash@dell.com>
Acked-by: Dave Jiang <dave.jiang@intel.com>
Link: https://lore.kernel.org/r/75e9c0e84c3345d693c606c64f8b9ab5@x13pwhopdag1307.AMER.DELL.COM
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/ioat/dma.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/dma/ioat/dma.c b/drivers/dma/ioat/dma.c
index 49386ce04bf5..1389f0582e29 100644
--- a/drivers/dma/ioat/dma.c
+++ b/drivers/dma/ioat/dma.c
@@ -394,10 +394,11 @@ ioat_alloc_ring(struct dma_chan *c, int order, gfp_t flags)
 
 		descs->virt = dma_alloc_coherent(to_dev(ioat_chan),
 						 SZ_2M, &descs->hw, flags);
-		if (!descs->virt && (i > 0)) {
+		if (!descs->virt) {
 			int idx;
 
 			for (idx = 0; idx < i; idx++) {
+				descs = &ioat_chan->descs[idx];
 				dma_free_coherent(to_dev(ioat_chan), SZ_2M,
 						  descs->virt, descs->hw);
 				descs->virt = NULL;
-- 
2.20.1



