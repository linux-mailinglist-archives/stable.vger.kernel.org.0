Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9F6A7CD775
	for <lists+stable@lfdr.de>; Sun,  6 Oct 2019 20:02:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728197AbfJFR3a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Oct 2019 13:29:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:55174 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728987AbfJFR32 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 6 Oct 2019 13:29:28 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 43CDA2087E;
        Sun,  6 Oct 2019 17:29:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570382967;
        bh=TivASpM3/86zANGlVZN2Uu3v/DewE3+KHlZDVvnmyWc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kvNqqKYsvHMhjHU7DyxnU4RrBAYe7PJpTEuu+QkDDwCgfnZzkP48IevRvF9fhW/zo
         UEoiDNEU/sBKU8bDUu4xbZrEp9xMAQ9zgE5nVSMBVVOWDysJEwlGK5IncI0Faj7QoM
         krH3adA/UzRJzufF4C2bfh5kXUW44VsfzoKpkg4A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lucas Stach <l.stach@pengutronix.de>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Sam Ravnborg <sam@ravnborg.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 004/106] drm/panel: simple: fix AUO g185han01 horizontal blanking
Date:   Sun,  6 Oct 2019 19:20:10 +0200
Message-Id: <20191006171126.937604511@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191006171124.641144086@linuxfoundation.org>
References: <20191006171124.641144086@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lucas Stach <l.stach@pengutronix.de>

[ Upstream commit f8c6bfc612b56f02e1b8fae699dff12738aaf889 ]

The horizontal blanking periods are too short, as the values are
specified for a single LVDS channel. Since this panel is dual LVDS
they need to be doubled. With this change the panel reaches its
nominal vrefresh rate of 60Fps, instead of the 64Fps with the
current wrong blanking.

Philipp Zabel added:
The datasheet specifies 960 active clocks + 40/128/160 clocks blanking
on each of the two LVDS channels (min/typical/max), so doubled this is
now correct.

Signed-off-by: Lucas Stach <l.stach@pengutronix.de>
Reviewed-by: Philipp Zabel <p.zabel@pengutronix.de>
Reviewed-by: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Link: https://patchwork.freedesktop.org/patch/msgid/1562764060.23869.12.camel@pengutronix.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panel/panel-simple.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/panel/panel-simple.c b/drivers/gpu/drm/panel/panel-simple.c
index 5fd94e2060297..654fea2b43124 100644
--- a/drivers/gpu/drm/panel/panel-simple.c
+++ b/drivers/gpu/drm/panel/panel-simple.c
@@ -689,9 +689,9 @@ static const struct panel_desc auo_g133han01 = {
 static const struct display_timing auo_g185han01_timings = {
 	.pixelclock = { 120000000, 144000000, 175000000 },
 	.hactive = { 1920, 1920, 1920 },
-	.hfront_porch = { 18, 60, 74 },
-	.hback_porch = { 12, 44, 54 },
-	.hsync_len = { 10, 24, 32 },
+	.hfront_porch = { 36, 120, 148 },
+	.hback_porch = { 24, 88, 108 },
+	.hsync_len = { 20, 48, 64 },
 	.vactive = { 1080, 1080, 1080 },
 	.vfront_porch = { 6, 10, 40 },
 	.vback_porch = { 2, 5, 20 },
-- 
2.20.1



