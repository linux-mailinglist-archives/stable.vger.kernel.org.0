Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43ABE4091B8
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 16:04:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245391AbhIMOEC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 10:04:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:50992 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245612AbhIMOBh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 10:01:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7269761A0C;
        Mon, 13 Sep 2021 13:38:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631540288;
        bh=lVDVoa1sP9R2MLoIob+fd5qtkGB87avFrZ2575JGRtQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D3eGh7BnCFctQ3Xmt913TXl33rsWjPmeVGuzAcurFxcvcmiZ2Uk0sN0NgUoo16wJo
         Nlkg4+PW9JlUdL7z9R7Hy/bQVINlMJ0C3986zLJ9oFD+/lPrQdVPPYsZzYTXsjOESi
         yqVn05S2Z3B2wlmld0rZAS5kn+cuWY/eUo8FYgak=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Julia Lawall <Julia.Lawall@inria.fr>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 089/300] drm/of: free the right object
Date:   Mon, 13 Sep 2021 15:12:30 +0200
Message-Id: <20210913131112.388603657@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131109.253835823@linuxfoundation.org>
References: <20210913131109.253835823@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Julia Lawall <Julia.Lawall@inria.fr>

[ Upstream commit b557a5f8da5798d27370ed6b73e673aae33efd55 ]

There is no need to free a NULL value.  Instead, free the object
that is leaking due to the iterator.

The semantic patch that finds this problem is as follows:

// <smpl>
@@
expression x,e;
identifier f;
@@
 x = f(...);
 if (x == NULL) {
	... when any
	    when != x = e
*	of_node_put(x);
	...
 }
// </smpl>

Fixes: 6529007522de ("drm: of: Add drm_of_lvds_get_dual_link_pixel_order")
Signed-off-by: Julia Lawall <Julia.Lawall@inria.fr>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Link: https://patchwork.freedesktop.org/patch/msgid/20210709200717.3676376-1-Julia.Lawall@inria.fr
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_of.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/drm_of.c b/drivers/gpu/drm/drm_of.c
index ca04c34e8251..197c57477344 100644
--- a/drivers/gpu/drm/drm_of.c
+++ b/drivers/gpu/drm/drm_of.c
@@ -315,7 +315,7 @@ static int drm_of_lvds_get_remote_pixels_type(
 
 		remote_port = of_graph_get_remote_port(endpoint);
 		if (!remote_port) {
-			of_node_put(remote_port);
+			of_node_put(endpoint);
 			return -EPIPE;
 		}
 
-- 
2.30.2



