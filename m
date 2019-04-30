Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5DAADF791
	for <lists+stable@lfdr.de>; Tue, 30 Apr 2019 14:00:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730502AbfD3LqH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Apr 2019 07:46:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:58776 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730499AbfD3LqH (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 30 Apr 2019 07:46:07 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0D85B21734;
        Tue, 30 Apr 2019 11:46:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556624766;
        bh=AcU1qu3A9mj5ZHpFuzc36xawwD0FGkvOP8e7qd9xy54=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s1iY5J7hbTk/6mBl9/M5EpX+j5jqzZL+Fox3AHb/OwUPkm/QwVBMJDJasswvwdr1T
         oW/DS0yTiOHcutlniGM2q1ZilkQqtTnU3k4cfJQpCRy6+CAWXxcU5c//l/AGwM44vL
         mpDHggHfutHX2cSi1oTE4CutM5/alnWhxgcLyFpY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Anholt <eric@anholt.net>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Subject: [PATCH 4.19 047/100] drm/vc4: Fix memory leak during gpu reset.
Date:   Tue, 30 Apr 2019 13:38:16 +0200
Message-Id: <20190430113611.280201035@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190430113608.616903219@linuxfoundation.org>
References: <20190430113608.616903219@linuxfoundation.org>
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
@@ -998,7 +998,7 @@ static void
 vc4_crtc_reset(struct drm_crtc *crtc)
 {
 	if (crtc->state)
-		__drm_atomic_helper_crtc_destroy_state(crtc->state);
+		vc4_crtc_destroy_state(crtc->state);
 
 	crtc->state = kzalloc(sizeof(struct vc4_crtc_state), GFP_KERNEL);
 	if (crtc->state)


