Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2EEC593D00
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 22:39:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345034AbiHOU2c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 16:28:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347390AbiHOU1d (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 16:27:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37F81A0608;
        Mon, 15 Aug 2022 12:04:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 474A961299;
        Mon, 15 Aug 2022 19:03:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B17DC433C1;
        Mon, 15 Aug 2022 19:03:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660590234;
        bh=5H4tar8fnHRgidQpmaez/5zo8Yhc3S0NY+XkZsD8nr8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pUyo0bgjO5a7IH1TQIunDGqbCWlAegPgs8uuOGaYWG2QJ4Byehjr7SIxalPyaCj03
         xwihzFo0/AFP6fD0rWiuxEHXBVekQ5AGq3JenvSyan9M2oICh/rFRFlKCOlc4PGalL
         kpDxkQBLf4IxxpSgiKY2G7Ihd3z0773mq0uIH1lo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Renesas Vietnam via Yoshihiro Shimoda 
        <yoshihiro.shimoda.uh@renesas.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0194/1095] soc: renesas: r8a779a0-sysc: Fix A2DP1 and A2CV[2357] PDR values
Date:   Mon, 15 Aug 2022 19:53:13 +0200
Message-Id: <20220815180437.654258777@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit bccceabb92ce8eb78bbf2de08308e2cc2761a2e5 ]

The PDR values for the A2DP1 and A2CV[2357] power areas on R-Car V3U are
incorrect (copied-and-pasted from A2DP0 and A2CV[0146]).
Fix them.

Reported-by: Renesas Vietnam via Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Fixes: 1b4298f000064cc2 ("soc: renesas: r8a779a0-sysc: Add r8a779a0 support")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://lore.kernel.org/r/87bc2e70ba4082970cf8c65871beae4be3503189.1654696188.git.geert+renesas@glider.be
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/renesas/r8a779a0-sysc.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/soc/renesas/r8a779a0-sysc.c b/drivers/soc/renesas/r8a779a0-sysc.c
index fdfc857df334..04f1bc322ae7 100644
--- a/drivers/soc/renesas/r8a779a0-sysc.c
+++ b/drivers/soc/renesas/r8a779a0-sysc.c
@@ -57,11 +57,11 @@ static struct rcar_gen4_sysc_area r8a779a0_areas[] __initdata = {
 	{ "a2cv6",	R8A779A0_PD_A2CV6, R8A779A0_PD_A3IR },
 	{ "a2cn2",	R8A779A0_PD_A2CN2, R8A779A0_PD_A3IR },
 	{ "a2imp23",	R8A779A0_PD_A2IMP23, R8A779A0_PD_A3IR },
-	{ "a2dp1",	R8A779A0_PD_A2DP0, R8A779A0_PD_A3IR },
-	{ "a2cv2",	R8A779A0_PD_A2CV0, R8A779A0_PD_A3IR },
-	{ "a2cv3",	R8A779A0_PD_A2CV1, R8A779A0_PD_A3IR },
-	{ "a2cv5",	R8A779A0_PD_A2CV4, R8A779A0_PD_A3IR },
-	{ "a2cv7",	R8A779A0_PD_A2CV6, R8A779A0_PD_A3IR },
+	{ "a2dp1",	R8A779A0_PD_A2DP1, R8A779A0_PD_A3IR },
+	{ "a2cv2",	R8A779A0_PD_A2CV2, R8A779A0_PD_A3IR },
+	{ "a2cv3",	R8A779A0_PD_A2CV3, R8A779A0_PD_A3IR },
+	{ "a2cv5",	R8A779A0_PD_A2CV5, R8A779A0_PD_A3IR },
+	{ "a2cv7",	R8A779A0_PD_A2CV7, R8A779A0_PD_A3IR },
 	{ "a2cn1",	R8A779A0_PD_A2CN1, R8A779A0_PD_A3IR },
 	{ "a1cnn0",	R8A779A0_PD_A1CNN0, R8A779A0_PD_A2CN0 },
 	{ "a1cnn2",	R8A779A0_PD_A1CNN2, R8A779A0_PD_A2CN2 },
-- 
2.35.1



