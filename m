Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DE794989AA
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 19:57:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233711AbiAXS5n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 13:57:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344555AbiAXSyr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 13:54:47 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66EBCC061348;
        Mon, 24 Jan 2022 10:53:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 069CB61507;
        Mon, 24 Jan 2022 18:53:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADA99C340E5;
        Mon, 24 Jan 2022 18:53:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643050418;
        bh=/5CAYepTBiNKnuaUxeDRApQltX0ss9gMvwPaaxbIzC0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S38W0PBxPryzO+sycbJXNS6y6OzUus4F9ZvKw7q14zFa9XAKl8JlIjPwED9mHNFqP
         ESjUG8i0fCfKJs9yeFpVPXoyv9+nW3LpceRSVJhetC43is53fvQf5Z7IA/Oa2tkZQd
         Llmj7FUTvjYQLMcrCnFK4TUzbKt7ffl9+AVEJXQY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Tudor Ambarus <tudor.ambarus@microchip.com>,
        Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 4.4 111/114] dmaengine: at_xdmac: Fix at_xdmac_lld struct definition
Date:   Mon, 24 Jan 2022 19:43:26 +0100
Message-Id: <20220124183930.530893189@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124183927.095545464@linuxfoundation.org>
References: <20220124183927.095545464@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tudor Ambarus <tudor.ambarus@microchip.com>

commit 912f7c6f7fac273f40e621447cf17d14b50d6e5b upstream.

The hardware channel next descriptor view structure contains just
fields of 32 bits, while dma_addr_t can be of type u64 or u32
depending on CONFIG_ARCH_DMA_ADDR_T_64BIT. Force u32 to comply with
what the hardware expects.

Fixes: e1f7c9eee707 ("dmaengine: at_xdmac: creation of the atmel eXtended DMA Controller driver")
Signed-off-by: Tudor Ambarus <tudor.ambarus@microchip.com>
Link: https://lore.kernel.org/r/20211215110115.191749-11-tudor.ambarus@microchip.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/dma/at_xdmac.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

--- a/drivers/dma/at_xdmac.c
+++ b/drivers/dma/at_xdmac.c
@@ -233,15 +233,15 @@ struct at_xdmac {
 
 /* Linked List Descriptor */
 struct at_xdmac_lld {
-	dma_addr_t	mbr_nda;	/* Next Descriptor Member */
-	u32		mbr_ubc;	/* Microblock Control Member */
-	dma_addr_t	mbr_sa;		/* Source Address Member */
-	dma_addr_t	mbr_da;		/* Destination Address Member */
-	u32		mbr_cfg;	/* Configuration Register */
-	u32		mbr_bc;		/* Block Control Register */
-	u32		mbr_ds;		/* Data Stride Register */
-	u32		mbr_sus;	/* Source Microblock Stride Register */
-	u32		mbr_dus;	/* Destination Microblock Stride Register */
+	u32 mbr_nda;	/* Next Descriptor Member */
+	u32 mbr_ubc;	/* Microblock Control Member */
+	u32 mbr_sa;	/* Source Address Member */
+	u32 mbr_da;	/* Destination Address Member */
+	u32 mbr_cfg;	/* Configuration Register */
+	u32 mbr_bc;	/* Block Control Register */
+	u32 mbr_ds;	/* Data Stride Register */
+	u32 mbr_sus;	/* Source Microblock Stride Register */
+	u32 mbr_dus;	/* Destination Microblock Stride Register */
 };
 
 /* 64-bit alignment needed to update CNDA and CUBC registers in an atomic way. */


