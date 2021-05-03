Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA920371AC0
	for <lists+stable@lfdr.de>; Mon,  3 May 2021 18:40:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232470AbhECQlC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 May 2021 12:41:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:38488 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231825AbhECQjL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 May 2021 12:39:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DB967613F0;
        Mon,  3 May 2021 16:37:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620059826;
        bh=tCP26YbwEpPEeLdj2qXeWKhdyg5mohmzE7NfUrQ93+I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KWtgKSecPBCkTvm84YYctkp1v7DF19uBQ37sL9cmkO6VCBUsBYttU36jKPgZUSLZ3
         kDTaka/Q6hsb9JtqxHYlgzjuHUoIodtFvbluznMG6fs09aEX9/cp2gzoRVzkA5R8F9
         xxRS/2HrrngPaodSqAigQ6vMzMqbRhMhGIwNGGfY5A/a5CjB/wiONXvU9sBt5QhZfH
         lkaZfJipDYmbMqCYjHtNC9W1r6bISM59jB/haiwwaOjgOYzcVd47iH53Sw+KxeF7QE
         yltyVNUy1NpLNjWIMAaW7WMa9owXklgVOU8EgXw0w4iOwLKWUN2RIcXMnew6YOw9nR
         DrAIrXFVDd/bg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Thomas Zimmermann <tzimmermann@suse.de>,
        Gerd Hoffmann <kraxel@redhat.com>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.11 004/115] drm/ast: Fix invalid usage of AST_MAX_HWC_WIDTH in cursor atomic_check
Date:   Mon,  3 May 2021 12:35:08 -0400
Message-Id: <20210503163700.2852194-4-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210503163700.2852194-1-sashal@kernel.org>
References: <20210503163700.2852194-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Zimmermann <tzimmermann@suse.de>

[ Upstream commit ee4a92d690f30f3793df942939726bec0338e65b ]

Use AST_MAX_HWC_HEIGHT for setting offset_y in the cursor plane's
atomic_check. The code used AST_MAX_HWC_WIDTH instead. This worked
because both constants has the same value.

Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Acked-by: Gerd Hoffmann <kraxel@redhat.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20210209134632.12157-3-tzimmermann@suse.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/ast/ast_mode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/ast/ast_mode.c b/drivers/gpu/drm/ast/ast_mode.c
index 9db371f4054f..c86ed2ffb725 100644
--- a/drivers/gpu/drm/ast/ast_mode.c
+++ b/drivers/gpu/drm/ast/ast_mode.c
@@ -688,7 +688,7 @@ ast_cursor_plane_helper_atomic_update(struct drm_plane *plane,
 	unsigned int offset_x, offset_y;
 
 	offset_x = AST_MAX_HWC_WIDTH - fb->width;
-	offset_y = AST_MAX_HWC_WIDTH - fb->height;
+	offset_y = AST_MAX_HWC_HEIGHT - fb->height;
 
 	if (state->fb != old_state->fb) {
 		/* A new cursor image was installed. */
-- 
2.30.2

