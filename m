Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3739593945
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 21:33:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243779AbiHOShK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 14:37:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244067AbiHOSgY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 14:36:24 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C100E2B19D;
        Mon, 15 Aug 2022 11:23:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id B216DCE125A;
        Mon, 15 Aug 2022 18:23:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C08D3C433D6;
        Mon, 15 Aug 2022 18:23:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660587783;
        bh=9P7MEiVBGsWVET67F5QBV0U1bVBX8kpT0aqZ6IbsjDI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=blQBIIKuSWwIi1g11qALRxnd7LoPW1i1QGdiePUwHUTUzyxqZhWbJ16FpRxZHwfan
         yMXv2Nq1KP9eeAOblf8L9mIMxNaCHMZZFZE4PJS5gjr3kfPDF5TxtxRigmwpbLkyww
         ykxg8zg1STaWdT7OwvBkyiFDnJDiihUIEeFjtT64=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Renesas Vietnam via Yoshihiro Shimoda 
        <yoshihiro.shimoda.uh@renesas.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 162/779] soc: renesas: r8a779a0-sysc: Fix A2DP1 and A2CV[2357] PDR values
Date:   Mon, 15 Aug 2022 19:56:46 +0200
Message-Id: <20220815180344.251302582@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180337.130757997@linuxfoundation.org>
References: <20220815180337.130757997@linuxfoundation.org>
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
index 7410b9fa9846..7e1aba9abce2 100644
--- a/drivers/soc/renesas/r8a779a0-sysc.c
+++ b/drivers/soc/renesas/r8a779a0-sysc.c
@@ -83,11 +83,11 @@ static struct r8a779a0_sysc_area r8a779a0_areas[] __initdata = {
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



