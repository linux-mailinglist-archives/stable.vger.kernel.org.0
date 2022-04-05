Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CA4B4F34E4
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 15:41:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242276AbiDEJgk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 05:36:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234944AbiDEJA6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:00:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87FBE27B32;
        Tue,  5 Apr 2022 01:53:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 21F9761511;
        Tue,  5 Apr 2022 08:53:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31ED5C385A0;
        Tue,  5 Apr 2022 08:53:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649148821;
        bh=FEhFHiceQxymASY0Cnhc+plWks288D4lT8BKESj8hAc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BH9g66znNAfQkaVP8r6HIJSdr82HCQ0e8B21mpC384swSQy68bLMXJqBFztx1n4KZ
         ZoVZjx10wzNerx8j2t0uD6DR6kvXp+u0iRKaz27wey4Xf+vKYijIQZM+RwOAkbwNVQ
         pW4EuG5uF/savoQyXuhvaDDU7FEuCnV8oeGU3XEE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Biju Das <biju.das.jz@bp.renesas.com>,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Robert Foss <robert.foss@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0493/1017] drm/bridge: dw-hdmi: use safe format when first in bridge chain
Date:   Tue,  5 Apr 2022 09:23:26 +0200
Message-Id: <20220405070408.933296758@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070354.155796697@linuxfoundation.org>
References: <20220405070354.155796697@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Neil Armstrong <narmstrong@baylibre.com>

[ Upstream commit 1528038385c0a706aac9ac165eeb24044fef6825 ]

When the dw-hdmi bridge is in first place of the bridge chain, this
means there is no way to select an input format of the dw-hdmi HW
component.

Since introduction of display-connector, negotiation was broken since
the dw-hdmi negotiation code only worked when the dw-hdmi bridge was
in last position of the bridge chain or behind another bridge also
supporting input & output format negotiation.

Commit 7cd70656d128 ("drm/bridge: display-connector: implement bus fmts callbacks")
was introduced to make negotiation work again by making display-connector
act as a pass-through concerning input & output format negotiation.

But in the case where the dw-hdmi is single in the bridge chain, for
example on Renesas SoCs, with the display-connector bridge the dw-hdmi
is no more single, breaking output format.

Reported-by: Biju Das <biju.das.jz@bp.renesas.com>
Bisected-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Tested-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Fixes: 6c3c719936da ("drm/bridge: synopsys: dw-hdmi: add bus format negociation")
Signed-off-by: Neil Armstrong <narmstrong@baylibre.com>
[narmstrong: add proper fixes commit]
Reviewed-by: Robert Foss <robert.foss@linaro.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20220204143337.89221-1-narmstrong@baylibre.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/synopsys/dw-hdmi.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/bridge/synopsys/dw-hdmi.c b/drivers/gpu/drm/bridge/synopsys/dw-hdmi.c
index e1211a5b334b..25d58dcfc87e 100644
--- a/drivers/gpu/drm/bridge/synopsys/dw-hdmi.c
+++ b/drivers/gpu/drm/bridge/synopsys/dw-hdmi.c
@@ -2551,8 +2551,9 @@ static u32 *dw_hdmi_bridge_atomic_get_output_bus_fmts(struct drm_bridge *bridge,
 	if (!output_fmts)
 		return NULL;
 
-	/* If dw-hdmi is the only bridge, avoid negociating with ourselves */
-	if (list_is_singular(&bridge->encoder->bridge_chain)) {
+	/* If dw-hdmi is the first or only bridge, avoid negociating with ourselves */
+	if (list_is_singular(&bridge->encoder->bridge_chain) ||
+	    list_is_first(&bridge->chain_node, &bridge->encoder->bridge_chain)) {
 		*num_output_fmts = 1;
 		output_fmts[0] = MEDIA_BUS_FMT_FIXED;
 
-- 
2.34.1



