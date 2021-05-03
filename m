Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1C16371B6B
	for <lists+stable@lfdr.de>; Mon,  3 May 2021 18:45:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232055AbhECQpv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 May 2021 12:45:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:49816 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232917AbhECQoL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 May 2021 12:44:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5092C61403;
        Mon,  3 May 2021 16:38:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620059916;
        bh=E2g8ime9QkUYS40eEOyvOOQeeqASSg3edaevTPAa3hA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YlpqdvTBKgJAgrVQ5KTtrSCOBjsBo80vIDBhdYRWXbdpEOxIx6mR5r33NRU7b39cW
         slBQOYu3l8Cr58lo2wNuEVTv5KOJjpC4kYD87VV3Ab/HyzDc0q3OplRB0K4bWSqcIE
         RzUD2f1hQgkGaLZbiHLQ8sB6k3YEaZCwyj8ixNNBptdVehsA7id4RMCPxCu/e3ee+k
         xbXxq342RSl4ajyo9Kr8jvI3nMwYNWkjr3aNgArdkFUdNlDVRB/zzfvIesIXKmmojg
         flE66/55tUdHFdhWC9YtCuDeQp6OsVX3Eyp22QFcJj81CFhs51d0zcJyufzOzjWn7s
         4p1KWzOdTW/wA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Thomas Zimmermann <tzimmermann@suse.de>,
        Gerd Hoffmann <kraxel@redhat.com>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.10 004/100] drm/ast: Fix invalid usage of AST_MAX_HWC_WIDTH in cursor atomic_check
Date:   Mon,  3 May 2021 12:36:53 -0400
Message-Id: <20210503163829.2852775-4-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210503163829.2852775-1-sashal@kernel.org>
References: <20210503163829.2852775-1-sashal@kernel.org>
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
index 0a1e1cf57e19..a3c2f76668ab 100644
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

