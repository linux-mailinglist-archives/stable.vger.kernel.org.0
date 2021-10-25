Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D317943A24C
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 21:45:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235361AbhJYTra (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 15:47:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:36946 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236852AbhJYTpY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Oct 2021 15:45:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B069861163;
        Mon, 25 Oct 2021 19:38:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635190739;
        bh=7/FwZ3S+RKMWqfp5HY0FBjrrd1kvnZAtu3ogX/RSwbA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EdBnkmnXLYrruOWlKQoZwaFBWB3yH33X8Qr9xGiVm/yLO+uaOmaUAx/Z5mqcFKJsC
         t9PVT41wzwhd7PVurNHfNiFeawOsBmyhLD3xQs0wruXdHusrMiBxpaK0iPKiiCn4d9
         T4sdfe6O4OOxCjSSm0YBR/FtOlVOe2e/gGJKbAxo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Anitha Chrisanthus <anitha.chrisanthus@intel.com>,
        Sam Ravnborg <sam@ravnborg.org>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 058/169] drm/kmb: Work around for higher system clock
Date:   Mon, 25 Oct 2021 21:13:59 +0200
Message-Id: <20211025191024.905543787@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211025191017.756020307@linuxfoundation.org>
References: <20211025191017.756020307@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Anitha Chrisanthus <anitha.chrisanthus@intel.com>

[ Upstream commit 3e4c31e8f70251732529a10934355084c7fab0ac ]

Use a different value for system clock offset in the
ppl/llp ratio calculations for clocks higher than 500 Mhz.

Fixes: 98521f4d4b4c ("drm/kmb: Mipi DSI part of the display driver")
Signed-off-by: Anitha Chrisanthus <anitha.chrisanthus@intel.com>
Acked-by: Sam Ravnborg <sam@ravnborg.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20211013233632.471892-1-anitha.chrisanthus@intel.com
Signed-off-by: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/kmb/kmb_dsi.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/kmb/kmb_dsi.c b/drivers/gpu/drm/kmb/kmb_dsi.c
index 231041b269f5..7e2371ffcb18 100644
--- a/drivers/gpu/drm/kmb/kmb_dsi.c
+++ b/drivers/gpu/drm/kmb/kmb_dsi.c
@@ -482,6 +482,10 @@ static u32 mipi_tx_fg_section_cfg(struct kmb_dsi *kmb_dsi,
 	return 0;
 }
 
+#define CLK_DIFF_LOW 50
+#define CLK_DIFF_HI 60
+#define SYSCLK_500  500
+
 static void mipi_tx_fg_cfg_regs(struct kmb_dsi *kmb_dsi, u8 frame_gen,
 				struct mipi_tx_frame_timing_cfg *fg_cfg)
 {
@@ -492,7 +496,12 @@ static void mipi_tx_fg_cfg_regs(struct kmb_dsi *kmb_dsi, u8 frame_gen,
 	/* 500 Mhz system clock minus 50 to account for the difference in
 	 * MIPI clock speed in RTL tests
 	 */
-	sysclk = kmb_dsi->sys_clk_mhz - 50;
+	if (kmb_dsi->sys_clk_mhz == SYSCLK_500) {
+		sysclk = kmb_dsi->sys_clk_mhz - CLK_DIFF_LOW;
+	} else {
+		/* 700 Mhz clk*/
+		sysclk = kmb_dsi->sys_clk_mhz - CLK_DIFF_HI;
+	}
 
 	/* PPL-Pixel Packing Layer, LLP-Low Level Protocol
 	 * Frame genartor timing parameters are clocked on the system clock,
-- 
2.33.0



