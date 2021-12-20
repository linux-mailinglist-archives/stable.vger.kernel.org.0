Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C74D547AD2C
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 15:51:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236687AbhLTOuq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 09:50:46 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:40752 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237123AbhLTOsV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 09:48:21 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A4E6B611A3;
        Mon, 20 Dec 2021 14:48:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85544C36AE8;
        Mon, 20 Dec 2021 14:48:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640011700;
        bh=ipn41Q7NEMddUV+tBY253weXZyPXTlX5UbbkzA7UpHg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TjOtakFEE3C7XJJUMJ02YrWY9MfW6VRcEa9lj9XQncHkTIKr+iaeAdkd6gCg/pA1d
         IZGacSWbqQ3uHiWrkJ2A9QUik/r5JTpOXuf4tJykfDvpmIlHBAD4BTWYZHjjTI0wsJ
         SHbKb1ht/fD8NCYC6Nsc/juICJSoz57dVKhk2G78=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiasheng Jiang <jiasheng@iscas.ac.cn>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 42/99] drm/ast: potential dereference of null pointer
Date:   Mon, 20 Dec 2021 15:34:15 +0100
Message-Id: <20211220143030.797360355@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211220143029.352940568@linuxfoundation.org>
References: <20211220143029.352940568@linuxfoundation.org>
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
index a3c2f76668abe..d27f2840b9555 100644
--- a/drivers/gpu/drm/ast/ast_mode.c
+++ b/drivers/gpu/drm/ast/ast_mode.c
@@ -857,7 +857,10 @@ static void ast_crtc_reset(struct drm_crtc *crtc)
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



