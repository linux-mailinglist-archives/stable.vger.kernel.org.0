Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9EB3962406
	for <lists+stable@lfdr.de>; Mon,  8 Jul 2019 17:39:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389335AbfGHP2w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jul 2019 11:28:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:57490 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389380AbfGHP2w (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jul 2019 11:28:52 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 467C6204EC;
        Mon,  8 Jul 2019 15:28:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562599731;
        bh=FRCL4MOe6ef/4Edzynh7ItEGQrJbwD2kHXeiG2W/lIk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QmDf1FgL1mB9vN6CpxXNlMhxLniAsj7YobRK2naqt1yMrNPmQxNsZteAGPTaMbJZy
         mEuytc0dodOAI6DYVwnYlLYKFeXRaoouQLc9TuFvr5XpdXbCG7dtNztNy5UcKL6N64
         ZhPjHmgG9TFz6U78nUYXtK7Uq+k4+TKx2Ih3VugE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Robert Beckett <bob.beckett@collabora.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH 4.19 59/90] drm/imx: only send event on crtc disable if kept disabled
Date:   Mon,  8 Jul 2019 17:13:26 +0200
Message-Id: <20190708150525.419802764@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190708150521.829733162@linuxfoundation.org>
References: <20190708150521.829733162@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Robert Beckett <bob.beckett@collabora.com>

commit 5aeab2bfc9ffa72d3ca73416635cb3785dfc076f upstream.

The event will be sent as part of the vblank enable during the modeset
if the crtc is not being kept disabled.

Fixes: 5f2f911578fb ("drm/imx: atomic phase 3 step 1: Use atomic configuration")

Signed-off-by: Robert Beckett <bob.beckett@collabora.com>
Reviewed-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/imx/ipuv3-crtc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/imx/ipuv3-crtc.c
+++ b/drivers/gpu/drm/imx/ipuv3-crtc.c
@@ -101,7 +101,7 @@ static void ipu_crtc_atomic_disable(stru
 	drm_crtc_vblank_off(crtc);
 
 	spin_lock_irq(&crtc->dev->event_lock);
-	if (crtc->state->event) {
+	if (crtc->state->event && !crtc->state->active) {
 		drm_crtc_send_vblank_event(crtc, crtc->state->event);
 		crtc->state->event = NULL;
 	}


