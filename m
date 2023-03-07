Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59F466AEE80
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:12:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232342AbjCGSMe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:12:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232434AbjCGSMQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:12:16 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4001F99C06
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:07:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B88EBB81851
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:07:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB5DBC433EF;
        Tue,  7 Mar 2023 18:07:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678212452;
        bh=egd3I2EozBNRofRAadQXFMoNC2qnX3UGJXidFpjjpbE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mzkTZivVIteA3pbZummVhximer3RrLWI85H4U4/rNsarHsf//IECs+3qSXzAC9z9g
         4Vzry9P6Ow+Ax4d7+2irrbNgr36hnkIBfTbpZemyqBceogVHbhbvqhXjDcErHXQxQm
         DCqay5FEjEIvGkzGEoBZ+LGxyWRTJ604K7isbeCk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 189/885] can: rcar_canfd: Fix R-Car V3U GAFLCFG field accesses
Date:   Tue,  7 Mar 2023 17:52:03 +0100
Message-Id: <20230307170010.218630829@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit 9be8c5583581244d8a77e41afa16b8b0a5ddabc0 ]

Each Global Acceptance Filter List Configuration Register (GAFLCFG)
contains two fields, and stores the number of channel rules for one
channel pair.

As R-Car V3U and later can have more than 2 channels, the field
selection should be based on the LSB (even or odd) of the channel
number, instead of on the full channel number.

Fixes: 45721c406dcf50d4 ("can: rcar_canfd: Add support for r8a779a0 SoC")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://lore.kernel.org/all/36bcf0ffb96d6aaed970751f9546b901af638bcf.1674499048.git.geert+renesas@glider.be
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/rcar/rcar_canfd.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/can/rcar/rcar_canfd.c b/drivers/net/can/rcar/rcar_canfd.c
index b306cf554634f..e68291697c33f 100644
--- a/drivers/net/can/rcar/rcar_canfd.c
+++ b/drivers/net/can/rcar/rcar_canfd.c
@@ -98,10 +98,10 @@ enum rcanfd_chip_id {
 /* RSCFDnCFDGAFLCFG0 / RSCFDnGAFLCFG0 */
 #define RCANFD_GAFLCFG_SETRNC(gpriv, n, x) \
 	(((x) & reg_v3u(gpriv, 0x1ff, 0xff)) << \
-	 (reg_v3u(gpriv, 16, 24) - (n) * reg_v3u(gpriv, 16, 8)))
+	 (reg_v3u(gpriv, 16, 24) - ((n) & 1) * reg_v3u(gpriv, 16, 8)))
 
 #define RCANFD_GAFLCFG_GETRNC(gpriv, n, x) \
-	(((x) >> (reg_v3u(gpriv, 16, 24) - (n) * reg_v3u(gpriv, 16, 8))) & \
+	(((x) >> (reg_v3u(gpriv, 16, 24) - ((n) & 1) * reg_v3u(gpriv, 16, 8))) & \
 	 reg_v3u(gpriv, 0x1ff, 0xff))
 
 /* RSCFDnCFDGAFLECTR / RSCFDnGAFLECTR */
-- 
2.39.2



