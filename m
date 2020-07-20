Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E09F5226829
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 18:17:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732293AbgGTQRg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 12:17:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:56506 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388426AbgGTQPd (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 12:15:33 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9973F20656;
        Mon, 20 Jul 2020 16:15:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595261733;
        bh=2TS1Ea2a7AafsiS9gEeKEBmZzM6gZPlCqXNpl+2It98=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vdL2bz012duSK3iFiwxFjffW8nj5wxgpx48ywzZdn/0wyJuWOf4OXSUXCE8rkcehH
         Bff1EuAbkuIA2N0ACpqiiuSMo+jFz3xrUwYeT6A5dd4qysyH00yq9/4Xp/AmmAnsvz
         YRsbHb2pu3EcNyUf+aS2fikNo2fR3cAHI//+YRxI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Charmaine Lee <charmainel@vmware.com>,
        Roland Scheidegger <sroland@vmware.com>
Subject: [PATCH 5.7 223/244] drm/vmwgfx: fix update of display surface when resolution changes
Date:   Mon, 20 Jul 2020 17:38:14 +0200
Message-Id: <20200720152836.458938189@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200720152825.863040590@linuxfoundation.org>
References: <20200720152825.863040590@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Roland Scheidegger <sroland@vmware.com>

commit 1f054fd26e29784d373c3d29c348ee48f1c41fb2 upstream.

The assignment of metadata overwrote the new display resolution values,
hence we'd miss the size actually changed and wouldn't redefine the
surface. This would then lead to command buffer error when trying to
update the screen target (due to the size mismatch), and result in a
VM with black screen.

Fixes: 504901dbb0b5 ("drm/vmwgfx: Refactor surface_define to use vmw_surface_metadata")
Reviewed-by: Charmaine Lee <charmainel@vmware.com>
Signed-off-by: Roland Scheidegger <sroland@vmware.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/vmwgfx/vmwgfx_stdu.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/gpu/drm/vmwgfx/vmwgfx_stdu.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_stdu.c
@@ -1069,10 +1069,6 @@ vmw_stdu_primary_plane_prepare_fb(struct
 	if (new_content_type != SAME_AS_DISPLAY) {
 		struct vmw_surface_metadata metadata = {0};
 
-		metadata.base_size.width = hdisplay;
-		metadata.base_size.height = vdisplay;
-		metadata.base_size.depth = 1;
-
 		/*
 		 * If content buffer is a buffer object, then we have to
 		 * construct surface info
@@ -1104,6 +1100,10 @@ vmw_stdu_primary_plane_prepare_fb(struct
 			metadata = new_vfbs->surface->metadata;
 		}
 
+		metadata.base_size.width = hdisplay;
+		metadata.base_size.height = vdisplay;
+		metadata.base_size.depth = 1;
+
 		if (vps->surf) {
 			struct drm_vmw_size cur_base_size =
 				vps->surf->metadata.base_size;


