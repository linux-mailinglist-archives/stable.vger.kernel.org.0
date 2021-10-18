Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 381BE431E8E
	for <lists+stable@lfdr.de>; Mon, 18 Oct 2021 16:00:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234413AbhJROCX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Oct 2021 10:02:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:41920 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234519AbhJROAY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Oct 2021 10:00:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4206461353;
        Mon, 18 Oct 2021 13:42:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634564536;
        bh=SyN04pPK4PBEiS8Av1SoZaec2ubE95+27Hq9MKHlG14=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ah3bkGoHCdN871P1QBYcIINPbR/WCDAETufW2FxbwRdMs95Y6kGHRFQwlEuWqE0oo
         g0s0hWCaj67EuwLXIwnTwizJFYsM2x2w7SJzWAEsnyS7/ZC9gduA7trfwJZppbfmjL
         axFJjR20VRiCHY6ocpsHyAUfoeIFn7u40m4pBIxs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
        <ville.syrjala@linux.intel.com>,
        Douglas Anderson <dianders@chromium.org>,
        Dave Airlie <airlied@redhat.com>
Subject: [PATCH 5.14 126/151] drm/edid: In connector_bad_edid() cap num_of_ext by num_blocks read
Date:   Mon, 18 Oct 2021 15:25:05 +0200
Message-Id: <20211018132344.770075577@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211018132340.682786018@linuxfoundation.org>
References: <20211018132340.682786018@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Douglas Anderson <dianders@chromium.org>

commit 97794170b696856483f74b47bfb6049780d2d3a0 upstream.

In commit e11f5bd8228f ("drm: Add support for DP 1.4 Compliance edid
corruption test") the function connector_bad_edid() started assuming
that the memory for the EDID passed to it was big enough to hold
`edid[0x7e] + 1` blocks of data (1 extra for the base block). It
completely ignored the fact that the function was passed `num_blocks`
which indicated how much memory had been allocated for the EDID.

Let's fix this by adding a bounds check.

This is important for handling the case where there's an error in the
first block of the EDID. In that case we will call
connector_bad_edid() without having re-allocated memory based on
`edid[0x7e]`.

Fixes: e11f5bd8228f ("drm: Add support for DP 1.4 Compliance edid corruption test")
Reported-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Reviewed-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20211005192905.v2.1.Ib059f9c23c2611cb5a9d760e7d0a700c1295928d@changeid
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/drm_edid.c |   15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/drm_edid.c
+++ b/drivers/gpu/drm/drm_edid.c
@@ -1834,11 +1834,20 @@ static void connector_bad_edid(struct dr
 			       u8 *edid, int num_blocks)
 {
 	int i;
-	u8 num_of_ext = edid[0x7e];
+	u8 last_block;
+
+	/*
+	 * 0x7e in the EDID is the number of extension blocks. The EDID
+	 * is 1 (base block) + num_ext_blocks big. That means we can think
+	 * of 0x7e in the EDID of the _index_ of the last block in the
+	 * combined chunk of memory.
+	 */
+	last_block = edid[0x7e];
 
 	/* Calculate real checksum for the last edid extension block data */
-	connector->real_edid_checksum =
-		drm_edid_block_checksum(edid + num_of_ext * EDID_LENGTH);
+	if (last_block < num_blocks)
+		connector->real_edid_checksum =
+			drm_edid_block_checksum(edid + last_block * EDID_LENGTH);
 
 	if (connector->bad_edid_counter++ && !drm_debug_enabled(DRM_UT_KMS))
 		return;


