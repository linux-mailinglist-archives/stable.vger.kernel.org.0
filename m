Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 752DF6280AB
	for <lists+stable@lfdr.de>; Mon, 14 Nov 2022 14:08:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237850AbiKNNIA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Nov 2022 08:08:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237854AbiKNNHy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Nov 2022 08:07:54 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CFE12B1B4
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 05:07:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1CF9161184
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 13:07:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3235EC433C1;
        Mon, 14 Nov 2022 13:07:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1668431272;
        bh=Ohy91wSNQM7wh3iawGDCuotHLUMINbW35wA1AQ3XlGU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Qt/XUoDfoNEHi7rXaRyldiqolGSwmEDZ5mKLbNojnnt216m5mEvTLpwk3MjbXUqhJ
         nGmArPrgTuAR7/dBspuhotqVBHk0meMQ9KXQZr5L1WnDaWpg2K4LyhTs/CVmGSsviF
         j1WHw+b8nq34u6DDVAnW/r/uoPWDsiywdDtsoBL4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Biju Das <biju.das.jz@bp.renesas.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 6.0 164/190] can: rcar_canfd: Add missing ECC error checks for channels 2-7
Date:   Mon, 14 Nov 2022 13:46:28 +0100
Message-Id: <20221114124506.002130844@linuxfoundation.org>
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

From: Geert Uytterhoeven <geert+renesas@glider.be>

commit 8b043dfb3dc7c32f9c2c0c93e3c2de346ee5e358 upstream.

When introducing support for R-Car V3U, which has 8 instead of 2
channels, the ECC error bitmask was extended to take into account the
extra channels, but rcar_canfd_global_error() was not updated to act
upon the extra bits.

Replace the RCANFD_GERFL_EEF[01] macros by a new macro that takes the
channel number, fixing R-Car V3U while simplifying the code.

Fixes: 45721c406dcf50d4 ("can: rcar_canfd: Add support for r8a779a0 SoC")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Biju Das <biju.das.jz@bp.renesas.com>
Link: https://lore.kernel.org/all/4edb2ea46cc64d0532a08a924179827481e14b4f.1666951503.git.geert+renesas@glider.be
Cc: stable@vger.kernel.org
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/can/rcar/rcar_canfd.c |   13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

--- a/drivers/net/can/rcar/rcar_canfd.c
+++ b/drivers/net/can/rcar/rcar_canfd.c
@@ -81,8 +81,7 @@ enum rcanfd_chip_id {
 
 /* RSCFDnCFDGERFL / RSCFDnGERFL */
 #define RCANFD_GERFL_EEF0_7		GENMASK(23, 16)
-#define RCANFD_GERFL_EEF1		BIT(17)
-#define RCANFD_GERFL_EEF0		BIT(16)
+#define RCANFD_GERFL_EEF(ch)		BIT(16 + (ch))
 #define RCANFD_GERFL_CMPOF		BIT(3)	/* CAN FD only */
 #define RCANFD_GERFL_THLES		BIT(2)
 #define RCANFD_GERFL_MES		BIT(1)
@@ -90,7 +89,7 @@ enum rcanfd_chip_id {
 
 #define RCANFD_GERFL_ERR(gpriv, x) \
 	((x) & (reg_v3u(gpriv, RCANFD_GERFL_EEF0_7, \
-			RCANFD_GERFL_EEF0 | RCANFD_GERFL_EEF1) | \
+			RCANFD_GERFL_EEF(0) | RCANFD_GERFL_EEF(1)) | \
 		RCANFD_GERFL_MES | \
 		((gpriv)->fdmode ? RCANFD_GERFL_CMPOF : 0)))
 
@@ -936,12 +935,8 @@ static void rcar_canfd_global_error(stru
 	u32 ridx = ch + RCANFD_RFFIFO_IDX;
 
 	gerfl = rcar_canfd_read(priv->base, RCANFD_GERFL);
-	if ((gerfl & RCANFD_GERFL_EEF0) && (ch == 0)) {
-		netdev_dbg(ndev, "Ch0: ECC Error flag\n");
-		stats->tx_dropped++;
-	}
-	if ((gerfl & RCANFD_GERFL_EEF1) && (ch == 1)) {
-		netdev_dbg(ndev, "Ch1: ECC Error flag\n");
+	if (gerfl & RCANFD_GERFL_EEF(ch)) {
+		netdev_dbg(ndev, "Ch%u: ECC Error flag\n", ch);
 		stats->tx_dropped++;
 	}
 	if (gerfl & RCANFD_GERFL_MES) {


