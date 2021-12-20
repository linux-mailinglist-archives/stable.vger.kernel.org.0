Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83E7B47ADF4
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 15:59:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238068AbhLTO47 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 09:56:59 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:33052 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238997AbhLTOyz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 09:54:55 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 85456B80EE5;
        Mon, 20 Dec 2021 14:54:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B520CC36AE7;
        Mon, 20 Dec 2021 14:54:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640012092;
        bh=9gZw/bN++qk52gub59Ns9xuNCBf2ou+tW3Ke4EBCD2c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mzsYr+MjOHv03mZEVGVNdhkThFnXj8i/TXRjiIb4m40ntNaKj3PUB6Uw9gm41umDQ
         8i31ZP429Q1DAH/smW6K0noie3N04t+9/VlLO4LiTS2NQ6gCdqxFDn+VJ62wdiPPPh
         vJiTWcg3/ZFr6iVEQRnMN7Qh6XfzviHfi3bpzPTg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiasheng Jiang <jiasheng@iscas.ac.cn>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 078/177] drm/ast: potential dereference of null pointer
Date:   Mon, 20 Dec 2021 15:33:48 +0100
Message-Id: <20211220143042.731219145@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211220143040.058287525@linuxfoundation.org>
References: <20211220143040.058287525@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiasheng Jiang <jiasheng@iscas.ac.cn>

[ Upstream commit fea3fdf975dd9f3e5248afaab8fe023db313f005 ]

The return value of kzalloc() needs to be checked.
To avoid use of null pointer '&ast_state->base' in case of the
failure of alloc.

Fixes: f0adbc382b8b ("drm/ast: Allocate initial CRTC state of the correct size")
Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Link: https://patchwork.freedesktop.org/patch/msgid/20211214014126.2211535-1-jiasheng@iscas.ac.cn
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/ast/ast_mode.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/ast/ast_mode.c b/drivers/gpu/drm/ast/ast_mode.c
index 1e30eaeb0e1b3..d5c98f79d58d3 100644
--- a/drivers/gpu/drm/ast/ast_mode.c
+++ b/drivers/gpu/drm/ast/ast_mode.c
@@ -1121,7 +1121,10 @@ static void ast_crtc_reset(struct drm_crtc *crtc)
 	if (crtc->state)
 		crtc->funcs->atomic_destroy_state(crtc, crtc->state);
 
-	__drm_atomic_helper_crtc_reset(crtc, &ast_state->base);
+	if (ast_state)
+		__drm_atomic_helper_crtc_reset(crtc, &ast_state->base);
+	else
+		__drm_atomic_helper_crtc_reset(crtc, NULL);
 }
 
 static struct drm_crtc_state *
-- 
2.33.0



