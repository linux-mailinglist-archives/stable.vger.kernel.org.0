Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6013B4989C6
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 19:59:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344118AbiAXS6R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 13:58:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344530AbiAXSyq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 13:54:46 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EA8CC061394;
        Mon, 24 Jan 2022 10:53:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A087C614E3;
        Mon, 24 Jan 2022 18:53:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E806C340EC;
        Mon, 24 Jan 2022 18:53:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643050415;
        bh=5Xvu8d/C0wWF0Z0O/hZRvCFnTmXcuejuftS0FbGyOM4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=locq8A0qfIrk5HT/7iFzihBrJD0g1h6ocwlw7Ud5eeQUJ1kk3kwW1BUOgi/eu3u17
         X06mdOYjDOOXHvAxzCfRBNo0j9hARfzXGBPTPcvCTBJVMCtAQn5OWz53X7IGC0zfmm
         EMb7JEpCRqmMGVSasLbOaWrhAQgq8p55TXkXcTq8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Tudor Ambarus <tudor.ambarus@microchip.com>,
        Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 4.4 110/114] dmaengine: at_xdmac: Fix lld view setting
Date:   Mon, 24 Jan 2022 19:43:25 +0100
Message-Id: <20220124183930.501498125@linuxfoundation.org>
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
@@ -360,7 +361,8 @@ static void at_xdmac_start_xfer(struct a
 	 */
 	if (at_xdmac_chan_is_cyclic(atchan))
 		reg = AT_XDMAC_CNDC_NDVIEW_NDV1;
-	else if (first->lld.mbr_ubc & AT_XDMAC_MBR_UBC_NDV3)
+	else if ((first->lld.mbr_ubc &
+		  AT_XDMAC_CNDC_NDVIEW_MASK) == AT_XDMAC_MBR_UBC_NDV3)
 		reg = AT_XDMAC_CNDC_NDVIEW_NDV3;
 	else
 		reg = AT_XDMAC_CNDC_NDVIEW_NDV2;


