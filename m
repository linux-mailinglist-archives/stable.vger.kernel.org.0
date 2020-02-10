Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EB2EC157770
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 14:00:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727752AbgBJNAR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 08:00:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:42070 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729555AbgBJMlA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:41:00 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8BB1E20838;
        Mon, 10 Feb 2020 12:40:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338459;
        bh=mER//Xvie/6H/Xs1QdZ3VlSUenuLA157YBjo4JLRCJ8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s3SYkS3MyQSRvOGtft/66WAyQn8kcVgwthUwm6HuwOxjaDMufhj/3gAAJL5anIL6t
         yD7oybRq9WA/ZjWgxtZdJ7AbP7t+OmhhPE4QXnAaEL4Th9E737Du+R9QkKs9PlVs/R
         v8ji1dnLj6r4H2lRV7wOKS4Kp2/adKK8JKneVMbA=
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
Subject: [PATCH 5.5 215/367] drm/rect: Avoid division by zero
Date:   Mon, 10 Feb 2020 04:32:08 -0800
Message-Id: <20200210122444.083805445@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210122423.695146547@linuxfoundation.org>
References: <20200210122423.695146547@linuxfoundation.org>
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
@@ -54,7 +54,12 @@ EXPORT_SYMBOL(drm_rect_intersect);
 
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


