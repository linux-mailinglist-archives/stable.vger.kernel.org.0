Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6202E4B4A62
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 11:38:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243851AbiBNKcW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 05:32:22 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:41292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348968AbiBNKbN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 05:31:13 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AB309DD75;
        Mon, 14 Feb 2022 01:59:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4C77960B31;
        Mon, 14 Feb 2022 09:59:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24A1CC340E9;
        Mon, 14 Feb 2022 09:59:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644832788;
        bh=+3V7kLPNkHtBcTLCEvk6zqPxgRYdatEipC65smgMYe0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nOxpilClTw/DyWOTn4Tcyohvwy61m0+unemrcM3byACA2WNpANn0Ubul80HemS/De
         QQHJJMANKsN1S9rWsZQ1XDvKzY9UG7ksy+WvnnNXqErJglNVYHAQj3ICFtH+DQcduy
         Xn7Cbp3n2gCV+xJLx3vnw4ClGrbUdPRKjLaH7GiQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christoph Niedermaier <cniedermaier@dh-electronics.com>,
        Marek Vasut <marex@denx.de>,
        Thierry Reding <thierry.reding@gmail.com>,
        Sam Ravnborg <sam@ravnborg.org>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 125/203] drm/panel: simple: Assign data from panel_dpi_probe() correctly
Date:   Mon, 14 Feb 2022 10:26:09 +0100
Message-Id: <20220214092514.490834060@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220214092510.221474733@linuxfoundation.org>
References: <20220214092510.221474733@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christoph Niedermaier <cniedermaier@dh-electronics.com>

[ Upstream commit 6df4432a5eca101b5fd80fbee41d309f3d67928d ]

In the function panel_simple_probe() the pointer panel->desc is
assigned to the passed pointer desc. If function panel_dpi_probe()
is called panel->desc will be updated, but further on only desc
will be evaluated. So update the desc pointer to be able to use
the data from the function panel_dpi_probe().

Fixes: 4a1d0dbc8332 ("drm/panel: simple: add panel-dpi support")

Signed-off-by: Christoph Niedermaier <cniedermaier@dh-electronics.com>
Cc: Marek Vasut <marex@denx.de>
Cc: Thierry Reding <thierry.reding@gmail.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: David Airlie <airlied@linux.ie>
Cc: Daniel Vetter <daniel@ffwll.ch>
To: dri-devel@lists.freedesktop.org
Reviewed-by: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Marek Vasut <marex@denx.de>
Link: https://patchwork.freedesktop.org/patch/msgid/20220201110153.3479-1-cniedermaier@dh-electronics.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panel/panel-simple.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/panel/panel-simple.c b/drivers/gpu/drm/panel/panel-simple.c
index eb475a3a774b7..87f30bced7b7e 100644
--- a/drivers/gpu/drm/panel/panel-simple.c
+++ b/drivers/gpu/drm/panel/panel-simple.c
@@ -588,6 +588,7 @@ static int panel_simple_probe(struct device *dev, const struct panel_desc *desc)
 		err = panel_dpi_probe(dev, panel);
 		if (err)
 			goto free_ddc;
+		desc = panel->desc;
 	} else {
 		if (!of_get_display_timing(dev->of_node, "panel-timing", &dt))
 			panel_simple_parse_panel_timing_node(dev, panel, &dt);
-- 
2.34.1



