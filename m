Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A18B53005EF
	for <lists+stable@lfdr.de>; Fri, 22 Jan 2021 15:49:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728188AbhAVOsZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Jan 2021 09:48:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:40270 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728664AbhAVOYr (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Jan 2021 09:24:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5E92C23BC6;
        Fri, 22 Jan 2021 14:19:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611325161;
        bh=Ar3nlBZEd6pnfuBCxxLR7CV3H4PcbB/GaN7UXd0DAek=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=e7aCzDyCF7GTjMY+bI2KOpFISyab8OrbHPAMikOSgAXBfXdkR9D9PFHKhl7a+Qx7f
         qsIfkSaUc7eASYI+Cg8wsF1x1Ii1JTm94a09IbiPXdbOprr1DmU4+DQchfTWRT2NRa
         P3C1KAXpqEy33J1LqkqgxtCXTOVcidrR01M2i4ls=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Antonio Borneo <antonio.borneo@st.com>,
        Yannick Fertre <yannick.fertre@st.com>,
        Sam Ravnborg <sam@ravnborg.org>,
        "Alex G." <mr.nuke.me@gmail.com>
Subject: [PATCH 5.10 37/43] drm/panel: otm8009a: allow using non-continuous dsi clock
Date:   Fri, 22 Jan 2021 15:12:53 +0100
Message-Id: <20210122135737.167629941@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210122135735.652681690@linuxfoundation.org>
References: <20210122135735.652681690@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Antonio Borneo <antonio.borneo@st.com>

commit 880ee3b7615e7cc087f659cb80ce22f5db56f9a2 upstream.

The panel is able to work when dsi clock is non-continuous, thus
the system power consumption can be reduced using such feature.

Add MIPI_DSI_CLOCK_NON_CONTINUOUS to panel's mode_flags.

Changes in v2:
  - Added my signed-off

Signed-off-by: Antonio Borneo <antonio.borneo@st.com>
Signed-off-by: Yannick Fertre <yannick.fertre@st.com>
Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20200922074253.28810-1-yannick.fertre@st.com
Cc: "Alex G." <mr.nuke.me@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/panel/panel-orisetech-otm8009a.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/panel/panel-orisetech-otm8009a.c
+++ b/drivers/gpu/drm/panel/panel-orisetech-otm8009a.c
@@ -452,7 +452,7 @@ static int otm8009a_probe(struct mipi_ds
 	dsi->lanes = 2;
 	dsi->format = MIPI_DSI_FMT_RGB888;
 	dsi->mode_flags = MIPI_DSI_MODE_VIDEO | MIPI_DSI_MODE_VIDEO_BURST |
-			  MIPI_DSI_MODE_LPM;
+			  MIPI_DSI_MODE_LPM | MIPI_DSI_CLOCK_NON_CONTINUOUS;
 
 	drm_panel_init(&ctx->panel, dev, &otm8009a_drm_funcs,
 		       DRM_MODE_CONNECTOR_DSI);


