Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92184408E91
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 15:35:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242316AbhIMNfx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 09:35:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:33598 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241583AbhIMNdB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 09:33:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D129A6137C;
        Mon, 13 Sep 2021 13:26:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631539570;
        bh=lVDVoa1sP9R2MLoIob+fd5qtkGB87avFrZ2575JGRtQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YvPd4k+3FJxz6/WnF3v0hfpUaY7LSC/mSaNvudQsONJIqF+4hyzNervknrh1ukqcz
         c7RA2zbDP0ee4WEyxD3ClTUsdBLW3bytq6nZWbFWk0rnmYctXNKKRlwbVhAtwz4zPp
         /jtm8JmtXoZB2rjql2Tma7+5aDeZTfXKgFbLM5WQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Julia Lawall <Julia.Lawall@inria.fr>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 076/236] drm/of: free the right object
Date:   Mon, 13 Sep 2021 15:13:01 +0200
Message-Id: <20210913131102.949560582@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131100.316353015@linuxfoundation.org>
References: <20210913131100.316353015@linuxfoundation.org>
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



