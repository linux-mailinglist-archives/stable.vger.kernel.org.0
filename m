Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C6D66280C3
	for <lists+stable@lfdr.de>; Mon, 14 Nov 2022 14:09:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237882AbiKNNJB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Nov 2022 08:09:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237529AbiKNNJA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Nov 2022 08:09:00 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B16165C4
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 05:08:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EB4D76116E
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 13:08:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CAFBC433C1;
        Mon, 14 Nov 2022 13:08:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1668431332;
        bh=J5VxFoS/ua8cOHz+suSb3lSohyhX0zXiWt3nvVKxkR0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G2K1wuCmEGLX2y0E0Kwj+ofqHvV0LayOvZOJqwmMnu3wV82sFqSidWJHSNon1mKdz
         3oLClY7gOpTr1aOREdCV2r20LPwBx5iiw9GZUPXt2k6irHzKY36ALav6cX7nTr46PW
         JmeMDVtPFBa/iOd2YQSXC9datBC0WR1NgXSdNCME=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Tudor Ambarus <tudor.ambarus@microchip.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 6.0 187/190] dmaengine: at_hdmac: Fix impossible condition
Date:   Mon, 14 Nov 2022 13:46:51 +0100
Message-Id: <20221114124507.061517106@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221114124458.806324402@linuxfoundation.org>
References: <20221114124458.806324402@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tudor Ambarus <tudor.ambarus@microchip.com>

commit 28cbe5a0a46a6637adbda52337d7b2777fc04027 upstream.

The iterator can not be greater than ATC_MAX_DSCR_TRIALS, as the for loop
will stop when i == ATC_MAX_DSCR_TRIALS. While here, use the common "i"
name for the iterator.

Fixes: 93dce3a6434f ("dmaengine: at_hdmac: fix residue computation")
Signed-off-by: Tudor Ambarus <tudor.ambarus@microchip.com>
Cc: stable@vger.kernel.org
Acked-by: Nicolas Ferre <nicolas.ferre@microchip.com>
Link: https://lore.kernel.org/r/20221025090306.297886-1-tudor.ambarus@microchip.com
Link: https://lore.kernel.org/r/20221025090306.297886-15-tudor.ambarus@microchip.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/dma/at_hdmac.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/drivers/dma/at_hdmac.c
+++ b/drivers/dma/at_hdmac.c
@@ -318,7 +318,8 @@ static int atc_get_bytes_left(struct dma
 	struct at_desc *desc_first = atc_first_active(atchan);
 	struct at_desc *desc;
 	int ret;
-	u32 ctrla, dscr, trials;
+	u32 ctrla, dscr;
+	unsigned int i;
 
 	/*
 	 * If the cookie doesn't match to the currently running transfer then
@@ -388,7 +389,7 @@ static int atc_get_bytes_left(struct dma
 		dscr = channel_readl(atchan, DSCR);
 		rmb(); /* ensure DSCR is read before CTRLA */
 		ctrla = channel_readl(atchan, CTRLA);
-		for (trials = 0; trials < ATC_MAX_DSCR_TRIALS; ++trials) {
+		for (i = 0; i < ATC_MAX_DSCR_TRIALS; ++i) {
 			u32 new_dscr;
 
 			rmb(); /* ensure DSCR is read after CTRLA */
@@ -414,7 +415,7 @@ static int atc_get_bytes_left(struct dma
 			rmb(); /* ensure DSCR is read before CTRLA */
 			ctrla = channel_readl(atchan, CTRLA);
 		}
-		if (unlikely(trials >= ATC_MAX_DSCR_TRIALS))
+		if (unlikely(i == ATC_MAX_DSCR_TRIALS))
 			return -ETIMEDOUT;
 
 		/* for the first descriptor we can be more accurate */


