Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1F5E56FB19
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 11:25:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232129AbiGKJZT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 05:25:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232427AbiGKJYl (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 05:24:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18ED82A42E;
        Mon, 11 Jul 2022 02:15:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A87D46125D;
        Mon, 11 Jul 2022 09:15:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4F58C34115;
        Mon, 11 Jul 2022 09:15:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657530906;
        bh=OLnwXVKD707ZZ+mGhuVMLJQBSfiNvdmdll5ulhhZKEM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MSLGebucLkhOlmKH+KekzFkdwBbo7xt08Fss2snbkyafpyZGa/U4f4EC5jKVPLEsJ
         6MBaGGizjuSJf4r+KwBRkgive8ye6uSBGX//6D1Ry4abLuUzuGjgc5K9GToDBXaVvk
         f2KphAPTOnofuSiHsGBPbnFbqCWlsr3xzVmiYVMg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Duy Nguyen <duy.nguyen.rh@renesas.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 5.18 026/112] can: rcar_canfd: Fix data transmission failed on R-Car V3U
Date:   Mon, 11 Jul 2022 11:06:26 +0200
Message-Id: <20220711090550.302308045@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220711090549.543317027@linuxfoundation.org>
References: <20220711090549.543317027@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Duy Nguyen <duy.nguyen.rh@renesas.com>

commit 374e11f1bde91545674233459e5a0416ba842b69 upstream.

On R-Car V3U, this driver should use suitable register offset instead of
other SoCs' one. Otherwise, data transmission failed on R-Car V3U.

Fixes: 45721c406dcf ("can: rcar_canfd: Add support for r8a779a0 SoC")
Link: https://lore.kernel.org/all/20220704074611.957191-1-yoshihiro.shimoda.uh@renesas.com
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Duy Nguyen <duy.nguyen.rh@renesas.com>
Signed-off-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/can/rcar/rcar_canfd.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/net/can/rcar/rcar_canfd.c
+++ b/drivers/net/can/rcar/rcar_canfd.c
@@ -1334,7 +1334,10 @@ static void rcar_canfd_set_bittiming(str
 		cfg = (RCANFD_DCFG_DTSEG1(gpriv, tseg1) | RCANFD_DCFG_DBRP(brp) |
 		       RCANFD_DCFG_DSJW(sjw) | RCANFD_DCFG_DTSEG2(gpriv, tseg2));
 
-		rcar_canfd_write(priv->base, RCANFD_F_DCFG(ch), cfg);
+		if (is_v3u(gpriv))
+			rcar_canfd_write(priv->base, RCANFD_V3U_DCFG(ch), cfg);
+		else
+			rcar_canfd_write(priv->base, RCANFD_F_DCFG(ch), cfg);
 		netdev_dbg(priv->ndev, "drate: brp %u, sjw %u, tseg1 %u, tseg2 %u\n",
 			   brp, sjw, tseg1, tseg2);
 	} else {


