Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5434B498B6C
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 20:13:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242064AbiAXTNW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 14:13:22 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:40644 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233789AbiAXTLU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 14:11:20 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 21F4961291;
        Mon, 24 Jan 2022 19:11:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D51A4C340E5;
        Mon, 24 Jan 2022 19:11:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643051479;
        bh=1pszC8haO9AcQCNEv/+zUuqg25w5JfFjf7bNYenSnDA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iPUxlK0IuZUdEbdgfvv0sIoS1HXq3krQ/WwRo/VyxbnzTbPA9GNzT+XWfC3gsiHR5
         Uq7juqXZpmUdNRAJ2An3MWKsyZqcmxDdYLK08JwQRT+06O8xdNNQCobZcItKo/KSpK
         3a5dAxlv+5wB5KjCGK8YJuLysdluzuW4qkSZPwog=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Tudor Ambarus <tudor.ambarus@microchip.com>,
        Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 4.14 174/186] dmaengine: at_xdmac: Fix lld view setting
Date:   Mon, 24 Jan 2022 19:44:09 +0100
Message-Id: <20220124183942.706499188@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124183937.101330125@linuxfoundation.org>
References: <20220124183937.101330125@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tudor Ambarus <tudor.ambarus@microchip.com>

commit 1385eb4d14d447cc5d744bc2ac34f43be66c9963 upstream.

AT_XDMAC_CNDC_NDVIEW_NDV3 was set even for AT_XDMAC_MBR_UBC_NDV2,
because of the wrong bit handling. Fix it.

Fixes: ee0fe35c8dcd ("dmaengine: xdmac: Handle descriptor's view 3 registers")
Signed-off-by: Tudor Ambarus <tudor.ambarus@microchip.com>
Link: https://lore.kernel.org/r/20211215110115.191749-10-tudor.ambarus@microchip.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/dma/at_xdmac.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/dma/at_xdmac.c
+++ b/drivers/dma/at_xdmac.c
@@ -100,6 +100,7 @@
 #define		AT_XDMAC_CNDC_NDE		(0x1 << 0)		/* Channel x Next Descriptor Enable */
 #define		AT_XDMAC_CNDC_NDSUP		(0x1 << 1)		/* Channel x Next Descriptor Source Update */
 #define		AT_XDMAC_CNDC_NDDUP		(0x1 << 2)		/* Channel x Next Descriptor Destination Update */
+#define		AT_XDMAC_CNDC_NDVIEW_MASK	GENMASK(28, 27)
 #define		AT_XDMAC_CNDC_NDVIEW_NDV0	(0x0 << 3)		/* Channel x Next Descriptor View 0 */
 #define		AT_XDMAC_CNDC_NDVIEW_NDV1	(0x1 << 3)		/* Channel x Next Descriptor View 1 */
 #define		AT_XDMAC_CNDC_NDVIEW_NDV2	(0x2 << 3)		/* Channel x Next Descriptor View 2 */
@@ -359,7 +360,8 @@ static void at_xdmac_start_xfer(struct a
 	 */
 	if (at_xdmac_chan_is_cyclic(atchan))
 		reg = AT_XDMAC_CNDC_NDVIEW_NDV1;
-	else if (first->lld.mbr_ubc & AT_XDMAC_MBR_UBC_NDV3)
+	else if ((first->lld.mbr_ubc &
+		  AT_XDMAC_CNDC_NDVIEW_MASK) == AT_XDMAC_MBR_UBC_NDV3)
 		reg = AT_XDMAC_CNDC_NDVIEW_NDV3;
 	else
 		reg = AT_XDMAC_CNDC_NDVIEW_NDV2;


