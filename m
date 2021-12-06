Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 271CF469A12
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:02:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345281AbhLFPFW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:05:22 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:37716 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345840AbhLFPFG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:05:06 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 291A1B81018;
        Mon,  6 Dec 2021 15:01:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DCB0C341C2;
        Mon,  6 Dec 2021 15:01:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638802896;
        bh=jKU58qYBU1NkFuvldMOvizh0Knkf91UgxaZbbVpWYDc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ozA6xNfszoSJiOQOBpvJQFv57dfmtBTecC98/+W0SWgMEYWvVZ9YhLV9K7DzNUt9O
         HcLlcjo4buBGLYPSu4dbAPRldWSA9U4Dj04vlT0atQGxyJnwnvrW9RSeiQ9sVLS07u
         5wWU2D3l6OocRBZbD2E/KTtX7C8CYyVJGPntep2g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Maxime Ripard <maxime@cerno.tech>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 19/62] drm/vc4: fix error code in vc4_create_object()
Date:   Mon,  6 Dec 2021 15:56:02 +0100
Message-Id: <20211206145549.838509537@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211206145549.155163074@linuxfoundation.org>
References: <20211206145549.155163074@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit 96c5f82ef0a145d3e56e5b26f2bf6dcd2ffeae1c ]

The ->gem_create_object() functions are supposed to return NULL if there
is an error.  None of the callers expect error pointers so returing one
will lead to an Oops.  See drm_gem_vram_create(), for example.

Fixes: c826a6e10644 ("drm/vc4: Add a BO cache.")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Link: https://patchwork.freedesktop.org/patch/msgid/20211118111416.GC1147@kili
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/vc4/vc4_bo.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/vc4/vc4_bo.c b/drivers/gpu/drm/vc4/vc4_bo.c
index d53e805d392f9..64fc99cf54d5b 100644
--- a/drivers/gpu/drm/vc4/vc4_bo.c
+++ b/drivers/gpu/drm/vc4/vc4_bo.c
@@ -198,7 +198,7 @@ struct drm_gem_object *vc4_create_object(struct drm_device *dev, size_t size)
 
 	bo = kzalloc(sizeof(*bo), GFP_KERNEL);
 	if (!bo)
-		return ERR_PTR(-ENOMEM);
+		return NULL;
 
 	mutex_lock(&vc4->bo_lock);
 	vc4->bo_stats.num_allocated++;
-- 
2.33.0



