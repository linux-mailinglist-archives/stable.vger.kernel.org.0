Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E03529C2A0
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 18:38:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1807529AbgJ0RiG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 13:38:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:33812 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1760553AbgJ0OfG (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:35:06 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EB590207BB;
        Tue, 27 Oct 2020 14:35:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603809301;
        bh=ecoBDCSGDdJ4lAPxADSnnNAvA1owgE4R6gdpbqHD6ZQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cZR601s/lo462tlMLj4WPLU1wWPzryXfPejje7qAd4vyF31Bt6hb9bePrWUQOPlJA
         jpl78Bi5qBVt8zhM6ylLC483Ymg5ePvClurKV6RmZB13N+/aZFTMz4orAQSstuL4pd
         xDxLN9uAJ2yzXFVFDLNkxTF+/nTd305lJMgMChH8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tom Rix <trix@redhat.com>,
        Patrik Jakobsson <patrik.r.jakobsson@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 117/408] drm/gma500: fix error check
Date:   Tue, 27 Oct 2020 14:50:55 +0100
Message-Id: <20201027135500.532172233@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135455.027547757@linuxfoundation.org>
References: <20201027135455.027547757@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tom Rix <trix@redhat.com>

[ Upstream commit cdd296cdae1af2d27dae3fcfbdf12c5252ab78cf ]

Reviewing this block of code in cdv_intel_dp_init()

ret = cdv_intel_dp_aux_native_read(gma_encoder, DP_DPCD_REV, ...

cdv_intel_edp_panel_vdd_off(gma_encoder);
if (ret == 0) {
	/* if this fails, presume the device is a ghost */
	DRM_INFO("failed to retrieve link info, disabling eDP\n");
	drm_encoder_cleanup(encoder);
	cdv_intel_dp_destroy(connector);
	goto err_priv;
} else {

The (ret == 0) is not strict enough.
cdv_intel_dp_aux_native_read() returns > 0 on success
otherwise it is failure.

So change to <=

Fixes: d112a8163f83 ("gma500/cdv: Add eDP support")

Signed-off-by: Tom Rix <trix@redhat.com>
Signed-off-by: Patrik Jakobsson <patrik.r.jakobsson@gmail.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20200805205911.20927-1-trix@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/gma500/cdv_intel_dp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/gma500/cdv_intel_dp.c b/drivers/gpu/drm/gma500/cdv_intel_dp.c
index 570b59520fd13..2ff4b35151bf8 100644
--- a/drivers/gpu/drm/gma500/cdv_intel_dp.c
+++ b/drivers/gpu/drm/gma500/cdv_intel_dp.c
@@ -2120,7 +2120,7 @@ cdv_intel_dp_init(struct drm_device *dev, struct psb_intel_mode_device *mode_dev
 					       intel_dp->dpcd,
 					       sizeof(intel_dp->dpcd));
 		cdv_intel_edp_panel_vdd_off(gma_encoder);
-		if (ret == 0) {
+		if (ret <= 0) {
 			/* if this fails, presume the device is a ghost */
 			DRM_INFO("failed to retrieve link info, disabling eDP\n");
 			cdv_intel_dp_encoder_destroy(encoder);
-- 
2.25.1



