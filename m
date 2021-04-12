Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6815D35BECE
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 11:02:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238739AbhDLJCE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 05:02:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:48976 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239043AbhDLI7C (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 04:59:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BEA1861369;
        Mon, 12 Apr 2021 08:57:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618217842;
        bh=V1OlOY5U2Rw1k7ZX8DzfHThSuCDmT3epTak46REhlDk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tncneYtNyrht+MmsAbdHaCjmzIYXvDNO7z03WqGzZ2+/ZUOYhREzPo1KxxbBkOKrV
         gHIqXpA6l2ZzL6Ok18GOIO5xxNlMPJ+1GREb0ZBRK7YjoiLdyVftWfdefW+4WnbtPf
         AdlOT2bMCxd5zu153WNJzIKBF9992x5u1S1Uig30=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dom Cobley <popcornmix@gmail.com>,
        Maxime Ripard <maxime@cerno.tech>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 164/188] drm/vc4: crtc: Reduce PV fifo threshold on hvs4
Date:   Mon, 12 Apr 2021 10:41:18 +0200
Message-Id: <20210412084019.086654852@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210412084013.643370347@linuxfoundation.org>
References: <20210412084013.643370347@linuxfoundation.org>
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
index 482219fb4db2..1d2416d466a3 100644
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



