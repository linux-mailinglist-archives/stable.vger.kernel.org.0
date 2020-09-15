Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DC8126B560
	for <lists+stable@lfdr.de>; Wed, 16 Sep 2020 01:43:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727195AbgIOXnH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Sep 2020 19:43:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:47678 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726950AbgIOOd4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Sep 2020 10:33:56 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A57B423C2E;
        Tue, 15 Sep 2020 14:25:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600179926;
        bh=h0bT9/HF0nyEOp1mbAalye8RkKgB5Cd+oHv1C9ens2k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zMAXgFgAOxytfkxBUS0z1JhNf5Snhe4iAlUnjv+4R079+pvxjVbBEZW53/4L8SJen
         Skbi2457byXXgRvUgapgH7rjVlFOmwfQDB8e0hW00hDIVKcCf5f9LXK0RlI4ITvR1T
         f0dnEjmWOxjgo357nx/5F/z3A/hggB8tXQ+VPU3I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maxime Ripard <maxime@cerno.tech>,
        Chen-Yu Tsai <wens@csie.org>,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 040/177] drm/sun4i: backend: Disable alpha on the lowest plane on the A20
Date:   Tue, 15 Sep 2020 16:11:51 +0200
Message-Id: <20200915140655.559291915@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200915140653.610388773@linuxfoundation.org>
References: <20200915140653.610388773@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maxime Ripard <maxime@cerno.tech>

[ Upstream commit 5e2e2600a3744491a8b49b92597c13b693692082 ]

Unlike we previously thought, the per-pixel alpha is just as broken on the
A20 as it is on the A10. Remove the quirk that says we can use it.

Fixes: dcf496a6a608 ("drm/sun4i: sun4i: Introduce a quirk for lowest plane alpha support")
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Reviewed-by: Chen-Yu Tsai <wens@csie.org>
Cc: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20200728134810.883457-2-maxime@cerno.tech
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/sun4i/sun4i_backend.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/gpu/drm/sun4i/sun4i_backend.c b/drivers/gpu/drm/sun4i/sun4i_backend.c
index 30672c4c634da..ed5d866178028 100644
--- a/drivers/gpu/drm/sun4i/sun4i_backend.c
+++ b/drivers/gpu/drm/sun4i/sun4i_backend.c
@@ -994,7 +994,6 @@ static const struct sun4i_backend_quirks sun6i_backend_quirks = {
 
 static const struct sun4i_backend_quirks sun7i_backend_quirks = {
 	.needs_output_muxing = true,
-	.supports_lowest_plane_alpha = true,
 };
 
 static const struct sun4i_backend_quirks sun8i_a33_backend_quirks = {
-- 
2.25.1



