Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 736971574C7
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 13:35:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728154AbgBJMfw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 07:35:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:53642 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728147AbgBJMfw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:35:52 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BF8E52080C;
        Mon, 10 Feb 2020 12:35:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338151;
        bh=MZzaPF918fcnYMDkywvRaK4a8r4Ai+0JtuwlN0iSxx0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gGOHtIoyDTMCDFNSWO3Uq9BX/Y1Sun/Ni37D7xPY7zCvdxBFjd/D5rCIKRljL0+aa
         fSp0FxhW7cfSvbZxGM5wViHz+XpqXhI4T1VRg2Wxg/njx9JGpMmKA73Pf9l5unfn31
         3j3y6v+3PjuyB2+TnOBrjHtXGCWgBaZppFqwTPpo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Benjamin Gaignard <benjamin.gaignard@st.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
        <ville.syrjala@linux.intel.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [PATCH 4.19 115/195] drm/rect: Avoid division by zero
Date:   Mon, 10 Feb 2020 04:32:53 -0800
Message-Id: <20200210122316.679926513@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210122305.731206734@linuxfoundation.org>
References: <20200210122305.731206734@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ville Syrjälä <ville.syrjala@linux.intel.com>

commit 433480c1afd44f3e1e664b85063d98cefeefa0ed upstream.

Check for zero width/height destination rectangle in
drm_rect_clip_scaled() to avoid a division by zero.

Cc: stable@vger.kernel.org
Fixes: f96bdf564f3e ("drm/rect: Handle rounding errors in drm_rect_clip_scaled, v3.")
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Cc: Benjamin Gaignard <benjamin.gaignard@st.com>
Cc: Daniel Vetter <daniel@ffwll.ch>
Testcase: igt/kms_selftest/drm_rect_clip_scaled_div_by_zero
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20191122175623.13565-2-ville.syrjala@linux.intel.com
Reviewed-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Reviewed-by: Benjamin Gaignard <benjamin.gaignard@st.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/drm_rect.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/drm_rect.c
+++ b/drivers/gpu/drm/drm_rect.c
@@ -52,7 +52,12 @@ EXPORT_SYMBOL(drm_rect_intersect);
 
 static u32 clip_scaled(u32 src, u32 dst, u32 clip)
 {
-	u64 tmp = mul_u32_u32(src, dst - clip);
+	u64 tmp;
+
+	if (dst == 0)
+		return 0;
+
+	tmp = mul_u32_u32(src, dst - clip);
 
 	/*
 	 * Round toward 1.0 when clipping so that we don't accidentally


