Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2CC9A1F032
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 13:41:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732028AbfEOL2b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 07:28:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:39596 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732395AbfEOL2a (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 07:28:30 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3AFEE206BF;
        Wed, 15 May 2019 11:28:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557919709;
        bh=e2MtqTSZ3nrJhGKG3P7qiVm73W9Shig/UosHZO8yi+A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1O/JUuVixrV2uaVCzBs8kmbV2PauzY7UvHFLZkZeP88C1UvJr2WEG3dpF/zB/W8gd
         OMjSce3/JMk+v0ULJEgOueowRWcH2Zz+KmbGzGsek8qDEXw6nViylvLA8N64BwpMi/
         fqdxYxFLEOG1iOtMg9vBKJN8P/oQPbyVv9YcAjew=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jonas Karlman <jonas@kwiboo.se>,
        Heiko Stueber <heiko@sntech.de>,
        Andrzej Hajda <a.hajda@samsung.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.0 063/137] drm: bridge: dw-hdmi: Fix overflow workaround for Rockchip SoCs
Date:   Wed, 15 May 2019 12:55:44 +0200
Message-Id: <20190515090658.041220026@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190515090651.633556783@linuxfoundation.org>
References: <20190515090651.633556783@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit d15d9fd02575ecfada92d42f655940c4f10af842 ]

The Rockchip RK3288 SoC (v2.00a) and RK3328/RK3399 SoCs (v2.11a) have
also been identified as needing this workaround with a single iteration.

Fixes: be41fc55f1aa ("drm: bridge: dw-hdmi: Handle overflow workaround based on device version")
Signed-off-by: Jonas Karlman <jonas@kwiboo.se>
Tested-by: Heiko Stueber <heiko@sntech.de>
Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
Link: https://patchwork.freedesktop.org/patch/msgid/AM3PR03MB0966818FAAAE6192FF4ED11AAC7D0@AM3PR03MB0966.eurprd03.prod.outlook.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/synopsys/dw-hdmi.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/gpu/drm/bridge/synopsys/dw-hdmi.c b/drivers/gpu/drm/bridge/synopsys/dw-hdmi.c
index 64c3cf0275182..14223c0ee7843 100644
--- a/drivers/gpu/drm/bridge/synopsys/dw-hdmi.c
+++ b/drivers/gpu/drm/bridge/synopsys/dw-hdmi.c
@@ -1655,6 +1655,8 @@ static void dw_hdmi_clear_overflow(struct dw_hdmi *hdmi)
 	 * iteration for others.
 	 * The Amlogic Meson GX SoCs (v2.01a) have been identified as needing
 	 * the workaround with a single iteration.
+	 * The Rockchip RK3288 SoC (v2.00a) and RK3328/RK3399 SoCs (v2.11a) have
+	 * been identified as needing the workaround with a single iteration.
 	 */
 
 	switch (hdmi->version) {
@@ -1663,7 +1665,9 @@ static void dw_hdmi_clear_overflow(struct dw_hdmi *hdmi)
 		break;
 	case 0x131a:
 	case 0x132a:
+	case 0x200a:
 	case 0x201a:
+	case 0x211a:
 	case 0x212a:
 		count = 1;
 		break;
-- 
2.20.1



