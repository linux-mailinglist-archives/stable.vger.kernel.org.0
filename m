Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6C19451E9E
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 01:33:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353075AbhKPAgs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 19:36:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:45214 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345081AbhKOT0N (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:26:13 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 511C66349E;
        Mon, 15 Nov 2021 19:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637003409;
        bh=AA7g+gUe2R0sGnxAf3Rf9WiGSecM4vqbcvPumZn30nw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mhnj/AuY2hBwYsx4vCI+ucizjZVst/kFuWMqM0dXCEfymb0N+hAtaXaxht17rsBPr
         5gYrRiPH6bqyUghnoy2RWZdcPn5tAYpOmmptMuObe6Pr0sEHsGsz4xZJJEUotjESiE
         jHif4ZUXIVuy6t/sImxOJmTxjhKwFDNlr+v+/XXs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Roman Stratiienko <r.stratiienko@gmail.com>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        Chen-Yu Tsai <wens@csie.org>, Maxime Ripard <maxime@cerno.tech>
Subject: [PATCH 5.15 913/917] drm/sun4i: Fix macros in sun8i_csc.h
Date:   Mon, 15 Nov 2021 18:06:48 +0100
Message-Id: <20211115165500.001906302@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jernej Skrabec <jernej.skrabec@gmail.com>

commit c302c98da646409d657a473da202f10f417f3ff1 upstream.

Macros SUN8I_CSC_CTRL() and SUN8I_CSC_COEFF() don't follow usual
recommendation of having arguments enclosed in parenthesis. While that
didn't change anything for quite sometime, it actually become important
after CSC code rework with commit ea067aee45a8 ("drm/sun4i: de2/de3:
Remove redundant CSC matrices").

Without this fix, colours are completely off for supported YVU formats
on SoCs with DE2 (A64, H3, R40, etc.).

Fix the issue by enclosing macro arguments in parenthesis.

Cc: stable@vger.kernel.org # 5.12+
Fixes: 883029390550 ("drm/sun4i: Add DE2 CSC library")
Reported-by: Roman Stratiienko <r.stratiienko@gmail.com>
Signed-off-by: Jernej Skrabec <jernej.skrabec@gmail.com>
Reviewed-by: Chen-Yu Tsai <wens@csie.org>
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Link: https://patchwork.freedesktop.org/patch/msgid/20210831184819.93670-1-jernej.skrabec@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/sun4i/sun8i_csc.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/sun4i/sun8i_csc.h
+++ b/drivers/gpu/drm/sun4i/sun8i_csc.h
@@ -16,8 +16,8 @@ struct sun8i_mixer;
 #define CCSC10_OFFSET 0xA0000
 #define CCSC11_OFFSET 0xF0000
 
-#define SUN8I_CSC_CTRL(base)		(base + 0x0)
-#define SUN8I_CSC_COEFF(base, i)	(base + 0x10 + 4 * i)
+#define SUN8I_CSC_CTRL(base)		((base) + 0x0)
+#define SUN8I_CSC_COEFF(base, i)	((base) + 0x10 + 4 * (i))
 
 #define SUN8I_CSC_CTRL_EN		BIT(0)
 


