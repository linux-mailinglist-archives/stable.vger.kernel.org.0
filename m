Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12D1E3783E2
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 12:47:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232685AbhEJKr4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 06:47:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:59364 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233328AbhEJKpi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 06:45:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C7EF5619A5;
        Mon, 10 May 2021 10:35:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620642949;
        bh=E2g8ime9QkUYS40eEOyvOOQeeqASSg3edaevTPAa3hA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VKpDplJ4gHJf3L+QQsfiEX/wGe80hLOs77TPA6unloe8lhw+/btfNrmpBu2Bys7P6
         KKTrkeTKu74h7hvLEf6F6mV9MzDwbITiKcnMW57ZNSsIf9uKF+VWOWiYgXGn23uAj1
         Td/2wpFzKLuju31e4Dog7Oe5/VGYm8WNCojz4sy4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thomas Zimmermann <tzimmermann@suse.de>,
        Gerd Hoffmann <kraxel@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 116/299] drm/ast: Fix invalid usage of AST_MAX_HWC_WIDTH in cursor atomic_check
Date:   Mon, 10 May 2021 12:18:33 +0200
Message-Id: <20210510102008.802160295@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102004.821838356@linuxfoundation.org>
References: <20210510102004.821838356@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



