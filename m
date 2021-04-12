Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D67535C08A
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 11:21:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240134AbhDLJOV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 05:14:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:35848 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240823AbhDLJLE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 05:11:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C33C96136B;
        Mon, 12 Apr 2021 09:06:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618218404;
        bh=wECuzhbGeXpB+xpAevG1GH75yDW7aMinWPmvCvHmwmo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lzEUjpJTfJTNx90eBtpEC8m3uLccpnZz/rO0zAQKGH/V7K465eziVKE8SNqrs/Nin
         LTCCpF/rBHyvmoHxL09uJHmzOvdI4Rh9ZdUXCWdCc90gZNdc2zo6vlXg3hix82WqAH
         E3DB9s+akIfPJzuMZeHG1OhXOb+we2vzwuJRyvSk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dom Cobley <popcornmix@gmail.com>,
        Maxime Ripard <maxime@cerno.tech>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 185/210] drm/vc4: crtc: Reduce PV fifo threshold on hvs4
Date:   Mon, 12 Apr 2021 10:41:30 +0200
Message-Id: <20210412084022.163670571@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210412084016.009884719@linuxfoundation.org>
References: <20210412084016.009884719@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dom Cobley <popcornmix@gmail.com>

[ Upstream commit eb9dfdd1ed40357b99a4201c8534c58c562e48c9 ]

Experimentally have found PV on hvs4 reports fifo full
error with expected settings and does not with one less

This appears as:
[drm:drm_atomic_helper_wait_for_flip_done] *ERROR* [CRTC:82:crtc-3] flip_done timed out

with bit 10 of PV_STAT set "HVS driving pixels when the PV FIFO is full"

Fixes: c8b75bca92cb ("drm/vc4: Add KMS support for Raspberry Pi.")
Signed-off-by: Dom Cobley <popcornmix@gmail.com>
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Link: https://patchwork.freedesktop.org/patch/msgid/20210318161328.1471556-3-maxime@cerno.tech
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/vc4/vc4_crtc.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/drivers/gpu/drm/vc4/vc4_crtc.c b/drivers/gpu/drm/vc4/vc4_crtc.c
index ea710beb8e00..351c601f0ddb 100644
--- a/drivers/gpu/drm/vc4/vc4_crtc.c
+++ b/drivers/gpu/drm/vc4/vc4_crtc.c
@@ -210,6 +210,7 @@ static u32 vc4_get_fifo_full_level(struct vc4_crtc *vc4_crtc, u32 format)
 {
 	const struct vc4_crtc_data *crtc_data = vc4_crtc_to_vc4_crtc_data(vc4_crtc);
 	const struct vc4_pv_data *pv_data = vc4_crtc_to_vc4_pv_data(vc4_crtc);
+	struct vc4_dev *vc4 = to_vc4_dev(vc4_crtc->base.dev);
 	u32 fifo_len_bytes = pv_data->fifo_depth;
 
 	/*
@@ -238,6 +239,22 @@ static u32 vc4_get_fifo_full_level(struct vc4_crtc *vc4_crtc, u32 format)
 		if (crtc_data->hvs_output == 5)
 			return 32;
 
+		/*
+		 * It looks like in some situations, we will overflow
+		 * the PixelValve FIFO (with the bit 10 of PV stat being
+		 * set) and stall the HVS / PV, eventually resulting in
+		 * a page flip timeout.
+		 *
+		 * Displaying the video overlay during a playback with
+		 * Kodi on an RPi3 seems to be a great solution with a
+		 * failure rate around 50%.
+		 *
+		 * Removing 1 from the FIFO full level however
+		 * seems to completely remove that issue.
+		 */
+		if (!vc4->hvs->hvs5)
+			return fifo_len_bytes - 3 * HVS_FIFO_LATENCY_PIX - 1;
+
 		return fifo_len_bytes - 3 * HVS_FIFO_LATENCY_PIX;
 	}
 }
-- 
2.30.2



