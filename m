Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4B3C0F816
	for <lists+stable@lfdr.de>; Tue, 30 Apr 2019 14:06:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729105AbfD3Ll5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Apr 2019 07:41:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:50224 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729104AbfD3Ll4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 30 Apr 2019 07:41:56 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D928621670;
        Tue, 30 Apr 2019 11:41:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556624515;
        bh=dfcChI+EQWkdxdZ5HqmcxSwY/717RRoy4vDGdSijDEk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WgAxw3S7MPZEmtr5R1HN3eHSTPimY/9YDUoNtYtfJBqsAlDC8xmv2tMaoQjgqojwF
         HiOU/mIDgQPjdEUxmRdyJugJlZhtsL0iHAro6yCKm7oY54GXFZCU2oD/lOfD4xdUEz
         HRMsShgBDlbl3upL/a6KI75AaxXX7iAGMR2elhqc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        kbuild test robot <lkp@intel.com>,
        Eric Anholt <eric@anholt.net>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [PATCH 4.14 22/53] drm/vc4: Fix compilation error reported by kbuild test bot
Date:   Tue, 30 Apr 2019 13:38:29 +0200
Message-Id: <20190430113555.134060137@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190430113549.400132183@linuxfoundation.org>
References: <20190430113549.400132183@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>

commit 462ce5d963f18b71c63f6b7730a35a2ee5273540 upstream.

A pointer to crtc was missing, resulting in the following build error:
drivers/gpu/drm/vc4/vc4_crtc.c:1045:44: sparse: sparse: incorrect type in argument 1 (different base types)
drivers/gpu/drm/vc4/vc4_crtc.c:1045:44: sparse:    expected struct drm_crtc *crtc
drivers/gpu/drm/vc4/vc4_crtc.c:1045:44: sparse:    got struct drm_crtc_state *state
drivers/gpu/drm/vc4/vc4_crtc.c:1045:39: sparse: sparse: not enough arguments for function vc4_crtc_destroy_state

Signed-off-by: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Reported-by: kbuild test robot <lkp@intel.com>
Cc: Eric Anholt <eric@anholt.net>
Link: https://patchwork.freedesktop.org/patch/msgid/2b6ed5e6-81b0-4276-8860-870b54ca3262@linux.intel.com
Fixes: d08106796a78 ("drm/vc4: Fix memory leak during gpu reset.")
Cc: <stable@vger.kernel.org> # v4.6+
Acked-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/vc4/vc4_crtc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/vc4/vc4_crtc.c
+++ b/drivers/gpu/drm/vc4/vc4_crtc.c
@@ -867,7 +867,7 @@ static void
 vc4_crtc_reset(struct drm_crtc *crtc)
 {
 	if (crtc->state)
-		vc4_crtc_destroy_state(crtc->state);
+		vc4_crtc_destroy_state(crtc, crtc->state);
 
 	crtc->state = kzalloc(sizeof(struct vc4_crtc_state), GFP_KERNEL);
 	if (crtc->state)


