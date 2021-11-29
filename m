Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C77B14623C2
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 22:50:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232072AbhK2VyD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 16:54:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232966AbhK2Vvx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 16:51:53 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3E3FC0F4B14;
        Mon, 29 Nov 2021 10:25:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 0D8E6CE13E1;
        Mon, 29 Nov 2021 18:25:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB518C53FC7;
        Mon, 29 Nov 2021 18:25:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638210346;
        bh=aIsSuVCCgbUOpWoXf+WcMrC7S9RJFcJFxztfTo5lozw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UtNDJr8U4YE7z4qu81T4Ps4Re3soAQO1L/KHvxKNQM8Fmtd5FqdEE0AIunOQWK8Gm
         FRxZXTPFLVUm9hPQUnY90oV/ImhtQF5C4RY8+U+GnSIcqm/niWS4Hz43dz21rWmwkT
         df9rpS1Z5TITYTCiirCadvCaw332tWQssMFs5fAE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Maxime Ripard <maxime@cerno.tech>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 56/92] drm/vc4: fix error code in vc4_create_object()
Date:   Mon, 29 Nov 2021 19:18:25 +0100
Message-Id: <20211129181709.287452263@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211129181707.392764191@linuxfoundation.org>
References: <20211129181707.392764191@linuxfoundation.org>
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
index 72d30d90b856c..0af246a5609ca 100644
--- a/drivers/gpu/drm/vc4/vc4_bo.c
+++ b/drivers/gpu/drm/vc4/vc4_bo.c
@@ -389,7 +389,7 @@ struct drm_gem_object *vc4_create_object(struct drm_device *dev, size_t size)
 
 	bo = kzalloc(sizeof(*bo), GFP_KERNEL);
 	if (!bo)
-		return ERR_PTR(-ENOMEM);
+		return NULL;
 
 	bo->madv = VC4_MADV_WILLNEED;
 	refcount_set(&bo->usecnt, 0);
-- 
2.33.0



