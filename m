Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B1124627CC
	for <lists+stable@lfdr.de>; Tue, 30 Nov 2021 00:07:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235825AbhK2XKg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 18:10:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236562AbhK2XJz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 18:09:55 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3847C1A25D1;
        Mon, 29 Nov 2021 10:38:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 4CA8BCE140D;
        Mon, 29 Nov 2021 18:38:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF050C53FAD;
        Mon, 29 Nov 2021 18:38:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638211085;
        bh=QOcdK1kyUZfXvAXujVWp0y4yKjztf7Q8QM/TaNAbygI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wG076XAk1ppDtfIKEueWy0JONw4D6cwdqhp1tEpl8Q7wLDztP4jNj6xNdCF5X/bkP
         4FMhD5FGg91lvtT4DZ7gFp/cwpF9IgZi3tX66k7q3iP8H0He3sTV8SBmgpL1uE4rj+
         fJa049HFDNJ1JC/m/9TtE+CSE83qfopQRSrTpaKI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Maxime Ripard <maxime@cerno.tech>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 091/179] drm/vc4: fix error code in vc4_create_object()
Date:   Mon, 29 Nov 2021 19:18:05 +0100
Message-Id: <20211129181721.931033082@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211129181718.913038547@linuxfoundation.org>
References: <20211129181718.913038547@linuxfoundation.org>
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
index fddaeb0b09c11..f642bd6e71ff4 100644
--- a/drivers/gpu/drm/vc4/vc4_bo.c
+++ b/drivers/gpu/drm/vc4/vc4_bo.c
@@ -391,7 +391,7 @@ struct drm_gem_object *vc4_create_object(struct drm_device *dev, size_t size)
 
 	bo = kzalloc(sizeof(*bo), GFP_KERNEL);
 	if (!bo)
-		return ERR_PTR(-ENOMEM);
+		return NULL;
 
 	bo->madv = VC4_MADV_WILLNEED;
 	refcount_set(&bo->usecnt, 0);
-- 
2.33.0



