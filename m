Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 49AD913FE3D
	for <lists+stable@lfdr.de>; Fri, 17 Jan 2020 00:35:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404360AbgAPXd3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 18:33:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:43892 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404356AbgAPXd2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 18:33:28 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 67F982072B;
        Thu, 16 Jan 2020 23:33:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579217607;
        bh=t0IHySlwctcWexuNwjOLYGC5ClqsFtkafJ6yFDAU9BE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IOB4WHvlV2pxiLHunr56vxi9C9UAEEmnhb/LVDAS1xxHk2rR6dlSd2mHLbtVZSlF3
         gDzmlarcqni3RvNdpgZqhlY5TRlT91nyL9ig91+f1EneK8v5XQmJq1I5pQzBWTelFQ
         q2m4Nr1gVLTh/01uqe+U2QD/PIPIJV0/twJphDgQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alexander Barabash <alexander.barabash@dell.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 68/71] ioat: ioat_alloc_ring() failure handling.
Date:   Fri, 17 Jan 2020 00:19:06 +0100
Message-Id: <20200116231718.774208319@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200116231709.377772748@linuxfoundation.org>
References: <20200116231709.377772748@linuxfoundation.org>
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
index f70cc74032ea..e3899ae429e0 100644
--- a/drivers/dma/ioat/dma.c
+++ b/drivers/dma/ioat/dma.c
@@ -388,10 +388,11 @@ ioat_alloc_ring(struct dma_chan *c, int order, gfp_t flags)
 
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



