Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97387205E00
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 22:21:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389455AbgFWUSz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 16:18:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:35928 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389725AbgFWUSy (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:18:54 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 492C02080C;
        Tue, 23 Jun 2020 20:18:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592943534;
        bh=qaVw5Jwkwz40kgKAzs3U1bNblcZODpB3TkUe58bTpwo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eB1sNrIc0kaURIqqkHblikGWkrFhjiiRdp1N41+guj+XZJE2qIBvHjAYwtzvOdc61
         oTh3/z/00xGUr6fPWsiGFjwfzMOCVrqKPnhZ6XolmeBZpaxcRkc/HoYdODQ8eOlV9Q
         uSxzO4QNRR6WMmcsKybCgMBoQX1RCWxvPxF6ZbD4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thomas Zimmermann <tzimmermann@suse.de>,
        Cary Garrett <cogarre@gmail.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Gerd Hoffmann <kraxel@redhat.com>,
        Dave Airlie <airlied@redhat.com>,
        Sam Ravnborg <sam@ravnborg.org>
Subject: [PATCH 5.7 429/477] drm/ast: Dont check new mode if CRTC is being disabled
Date:   Tue, 23 Jun 2020 21:57:06 +0200
Message-Id: <20200623195427.809069441@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195407.572062007@linuxfoundation.org>
References: <20200623195407.572062007@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Zimmermann <tzimmermann@suse.de>

commit d6ddbd5c97d1b9156646ac5c42b8851edd664ee2 upstream.

Suspending failed because there's no mode if the CRTC is being
disabled. Early-out in this case. This fixes runtime PM for ast.

v3:
	* fixed commit message
v2:
	* added Tested-by/Reported-by tags
	* added Fixes tags and CC (Sam)
	* improved comment

Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Reported-by: Cary Garrett <cogarre@gmail.com>
Tested-by: Cary Garrett <cogarre@gmail.com>
Reviewed-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Fixes: b48e1b6ffd28 ("drm/ast: Add CRTC helpers for atomic modesetting")
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Cc: Gerd Hoffmann <kraxel@redhat.com>
Cc: Dave Airlie <airlied@redhat.com>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: <stable@vger.kernel.org> # v5.6+
Link: https://patchwork.freedesktop.org/patch/msgid/20200507090640.21561-1-tzimmermann@suse.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/ast/ast_mode.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/gpu/drm/ast/ast_mode.c
+++ b/drivers/gpu/drm/ast/ast_mode.c
@@ -802,6 +802,9 @@ static int ast_crtc_helper_atomic_check(
 		return -EINVAL;
 	}
 
+	if (!state->enable)
+		return 0; /* no mode checks if CRTC is being disabled */
+
 	ast_state = to_ast_crtc_state(state);
 
 	format = ast_state->format;


