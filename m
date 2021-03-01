Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CCE9328F12
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 20:46:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241782AbhCATmq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 14:42:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:50942 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242151AbhCATf1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:35:27 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8505E65077;
        Mon,  1 Mar 2021 17:27:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614619621;
        bh=yGdYWvNuFZncbwZNiLQfD7jXjmOmiTOQhKTxlaNTqVg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u/3mwueMXz72OVILAejUU90z/3gfJakavkVNzmjZOF70HOAvzE8IUk+f9zyub+5YR
         /Uy5QnKjYWoIVFZvtF1R960hTTMieH/Rq49ELN1h7PU7bvSF+rBIT56FfWWcmXykct
         U0BfBviSq7d/UvGaN1uALwN9kjGh74Ca3qeRG3tY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
        <ville.syrjala@linux.intel.com>,
        Chris Wilson <chris@chris-wilson.co.uk>
Subject: [PATCH 5.10 519/663] drm/modes: Switch to 64bit maths to avoid integer overflow
Date:   Mon,  1 Mar 2021 17:12:47 +0100
Message-Id: <20210301161207.522823064@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161141.760350206@linuxfoundation.org>
References: <20210301161141.760350206@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ville Syrjälä <ville.syrjala@linux.intel.com>

commit 5b34ab52401f0f1f191bcb83a182c83b506f4763 upstream.

The new >8k CEA modes have dotclocks reaching 5.94 GHz, which
means our clock*1000 will now overflow the 32bit unsigned
integer. Switch to 64bit maths to avoid it.

Cc: stable@vger.kernel.org
Reported-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20201022194256.30978-1-ville.syrjala@linux.intel.com
Tested-by: Randy Dunlap <rdunlap@infradead.org>
Reviewed-by: Chris Wilson <chris@chris-wilson.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/drm_modes.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/drm_modes.c
+++ b/drivers/gpu/drm/drm_modes.c
@@ -762,7 +762,7 @@ int drm_mode_vrefresh(const struct drm_d
 	if (mode->htotal == 0 || mode->vtotal == 0)
 		return 0;
 
-	num = mode->clock * 1000;
+	num = mode->clock;
 	den = mode->htotal * mode->vtotal;
 
 	if (mode->flags & DRM_MODE_FLAG_INTERLACE)
@@ -772,7 +772,7 @@ int drm_mode_vrefresh(const struct drm_d
 	if (mode->vscan > 1)
 		den *= mode->vscan;
 
-	return DIV_ROUND_CLOSEST(num, den);
+	return DIV_ROUND_CLOSEST_ULL(mul_u32_u32(num, 1000), den);
 }
 EXPORT_SYMBOL(drm_mode_vrefresh);
 


