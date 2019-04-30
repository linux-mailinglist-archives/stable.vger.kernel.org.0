Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CE500F693
	for <lists+stable@lfdr.de>; Tue, 30 Apr 2019 13:49:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731023AbfD3Lti (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Apr 2019 07:49:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:36182 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730709AbfD3Ltg (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 30 Apr 2019 07:49:36 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A2CE22054F;
        Tue, 30 Apr 2019 11:49:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556624976;
        bh=jW8B9fYnNhCMmM+VOfJleRK+4+pNzZlDG3cyYS2Wj5M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fpaVVSB/vhPM91pvmlGG+17r/n8Oy9lpjVtjwzy1FktvCFGmX4tF683oWyzO47i78
         RhIiAr41cp3m/xw+X+E7SWWY1DACgAT1ArhfOt8R2EsMSuf2snpPjNut6XPAhkUlo/
         Ngym9AbmQx5fND5PUvNyYxgA7YYyRb8/35d/hnv4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Anholt <eric@anholt.net>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Subject: [PATCH 5.0 42/89] drm/vc4: Fix memory leak during gpu reset.
Date:   Tue, 30 Apr 2019 13:38:33 +0200
Message-Id: <20190430113611.755099705@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190430113609.741196396@linuxfoundation.org>
References: <20190430113609.741196396@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>

commit d08106796a78a4273e39e1bbdf538dc4334b2635 upstream.

__drm_atomic_helper_crtc_destroy_state does not free memory, it only
cleans it up. Fix this by calling the functions own destroy function.

Fixes: 6d6e50039187 ("drm/vc4: Allocate the right amount of space for boot-time CRTC state.")
Cc: Eric Anholt <eric@anholt.net>
Cc: <stable@vger.kernel.org> # v4.6+
Reviewed-by: Eric Anholt <eric@anholt.net>
Signed-off-by: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20190301125627.7285-2-maarten.lankhorst@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/vc4/vc4_crtc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/vc4/vc4_crtc.c
+++ b/drivers/gpu/drm/vc4/vc4_crtc.c
@@ -999,7 +999,7 @@ static void
 vc4_crtc_reset(struct drm_crtc *crtc)
 {
 	if (crtc->state)
-		__drm_atomic_helper_crtc_destroy_state(crtc->state);
+		vc4_crtc_destroy_state(crtc->state);
 
 	crtc->state = kzalloc(sizeof(struct vc4_crtc_state), GFP_KERNEL);
 	if (crtc->state)


