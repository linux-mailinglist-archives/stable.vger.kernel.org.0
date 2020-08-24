Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E19624FADD
	for <lists+stable@lfdr.de>; Mon, 24 Aug 2020 12:00:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726777AbgHXIcj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Aug 2020 04:32:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:39538 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726718AbgHXIcg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Aug 2020 04:32:36 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 14228206F0;
        Mon, 24 Aug 2020 08:32:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598257955;
        bh=t8QFWqTolVo7c1qLgcmQjDz0wNlZ8unAbXNGpquMF7c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N9qrY1E/L8ae2sNuqRomQfOzugotw0vUhHd7xBdG6mtoywRKMLKsMD4ZcvVm5VgGF
         5a0jq3Jl+lu7GMGxNtVc5R/aqjs/W+jnbLoOLsTBReSp5a+FBvhTIFizp9Ta/xFMBE
         FxQe/dxh8Irq6PXyV618On3TKmtvaz+69kzT6UN0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thomas Zimmermann <tzimmermann@suse.de>,
        Sam Ravnborg <sam@ravnborg.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Joel Stanley <joel@jms.id.au>,
        "Y.C. Chen" <yc_chen@aspeedtech.com>,
        Dave Airlie <airlied@redhat.com>,
        Gerd Hoffmann <kraxel@redhat.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Emil Velikov <emil.l.velikov@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 004/148] drm/ast: Initialize DRAM type before posting GPU
Date:   Mon, 24 Aug 2020 10:28:22 +0200
Message-Id: <20200824082414.156735452@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200824082413.900489417@linuxfoundation.org>
References: <20200824082413.900489417@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Zimmermann <tzimmermann@suse.de>

[ Upstream commit 244d012801dae30c91983b360457c78d481584b0 ]

Posting the GPU requires the correct DRAM type to be stored in
struct ast_private. Therefore first initialize the DRAM info and
then post the GPU. This restores the original order of instructions
in this function.

Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Reviewed-by: Sam Ravnborg <sam@ravnborg.org>
Acked-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Fixes: bad09da6deab ("drm/ast: Fixed vram size incorrect issue on POWER")
Cc: Joel Stanley <joel@jms.id.au>
Cc: Y.C. Chen <yc_chen@aspeedtech.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Dave Airlie <airlied@redhat.com>
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Cc: Gerd Hoffmann <kraxel@redhat.com>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Emil Velikov <emil.l.velikov@gmail.com>
Cc: "Y.C. Chen" <yc_chen@aspeedtech.com>
Cc: <stable@vger.kernel.org> # v4.11+
Link: https://patchwork.freedesktop.org/patch/msgid/20200716125353.31512-6-tzimmermann@suse.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/ast/ast_main.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/ast/ast_main.c b/drivers/gpu/drm/ast/ast_main.c
index f48a9f62368c0..99c11b51f0207 100644
--- a/drivers/gpu/drm/ast/ast_main.c
+++ b/drivers/gpu/drm/ast/ast_main.c
@@ -458,9 +458,6 @@ int ast_driver_load(struct drm_device *dev, unsigned long flags)
 
 	ast_detect_chip(dev, &need_post);
 
-	if (need_post)
-		ast_post_gpu(dev);
-
 	ret = ast_get_dram_info(dev);
 	if (ret)
 		goto out_free;
@@ -469,6 +466,9 @@ int ast_driver_load(struct drm_device *dev, unsigned long flags)
 		 ast->mclk, ast->dram_type,
 		 ast->dram_bus_width, ast->vram_size);
 
+	if (need_post)
+		ast_post_gpu(dev);
+
 	ret = ast_mm_init(ast);
 	if (ret)
 		goto out_free;
-- 
2.25.1



