Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 441F12265EC
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 17:59:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731265AbgGTP6n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 11:58:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:58976 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726381AbgGTP6m (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 11:58:42 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 77A28206E9;
        Mon, 20 Jul 2020 15:58:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595260722;
        bh=zDSyxu2YXcDJh5X+IeinN7sL68/NDNOnG0qakRrgff8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ec7Vlasa/Gg9XWyfbHRR/NfwhlPgb/ak97KN1J6PvicqPt+A1/F3cbuMEqVHPmKTF
         ZffrIKTHYUhldxynuTZvHT3u44Aa178gzpluaQNEsQeOZP7wo7ikp2wgmm5RwGp72c
         Tms2PwC9hAG36csyPcbCSI3pDfFQ3l19XYAHPnjQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrey Lebedev <andrey@lebedev.lt>,
        Maxime Ripard <maxime@cerno.tech>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 072/215] drm/sun4i: tcon: Separate quirks for tcon0 and tcon1 on A20
Date:   Mon, 20 Jul 2020 17:35:54 +0200
Message-Id: <20200720152823.638384545@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200720152820.122442056@linuxfoundation.org>
References: <20200720152820.122442056@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrey Lebedev <andrey@lebedev.lt>

[ Upstream commit cd0ecabdc953397ed0378022b3b90e0c0871c2eb ]

Timing controllers on A20 are not equivalent: tcon0 on A20 supports
LVDS output and tcon1 does not. Separate the capabilities by
introducing independent set of quirks for each of the tcons.

Signed-off-by: Andrey Lebedev <andrey@lebedev.lt>
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Link: https://patchwork.freedesktop.org/patch/msgid/20200219180858.4806-3-andrey.lebedev@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/sun4i/sun4i_tcon.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/sun4i/sun4i_tcon.c b/drivers/gpu/drm/sun4i/sun4i_tcon.c
index 27c80c9e2b83b..0f7eafedfe8f5 100644
--- a/drivers/gpu/drm/sun4i/sun4i_tcon.c
+++ b/drivers/gpu/drm/sun4i/sun4i_tcon.c
@@ -1504,6 +1504,8 @@ const struct of_device_id sun4i_tcon_of_table[] = {
 	{ .compatible = "allwinner,sun6i-a31-tcon", .data = &sun6i_a31_quirks },
 	{ .compatible = "allwinner,sun6i-a31s-tcon", .data = &sun6i_a31s_quirks },
 	{ .compatible = "allwinner,sun7i-a20-tcon", .data = &sun7i_a20_quirks },
+	{ .compatible = "allwinner,sun7i-a20-tcon0", .data = &sun7i_a20_quirks },
+	{ .compatible = "allwinner,sun7i-a20-tcon1", .data = &sun7i_a20_quirks },
 	{ .compatible = "allwinner,sun8i-a23-tcon", .data = &sun8i_a33_quirks },
 	{ .compatible = "allwinner,sun8i-a33-tcon", .data = &sun8i_a33_quirks },
 	{ .compatible = "allwinner,sun8i-a83t-tcon-lcd", .data = &sun8i_a83t_lcd_quirks },
-- 
2.25.1



