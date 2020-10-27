Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2351729B089
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 15:22:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2895270AbgJ0OUk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 10:20:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:44164 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1758616AbgJ0OUT (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:20:19 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CA83F206F7;
        Tue, 27 Oct 2020 14:20:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603808419;
        bh=0v8Fu24+QRyx7jkDgm6T86sfyGxEGNkJoZOL5b0BRDI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UUuHR1Yd4I4zItT15tL3EW79pAAQuQvp2L+VI+wE4TD4ZLYpoXqQlVdQU2mqO085j
         4he7wTVoyXPTcDLKSmKlDNYbCRMOY/ba5hkqXrsBY5Rr6jpgYD2GyEI2o8vatz7WBw
         g8aiS5na8u4IxtEJuhP5rpzjZMWUqOByGtLrimpo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tom Rix <trix@redhat.com>,
        Patrik Jakobsson <patrik.r.jakobsson@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 077/264] drm/gma500: fix error check
Date:   Tue, 27 Oct 2020 14:52:15 +0100
Message-Id: <20201027135434.326130502@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135430.632029009@linuxfoundation.org>
References: <20201027135430.632029009@linuxfoundation.org>
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
index 90ed20083009f..05eba6dec5ebf 100644
--- a/drivers/gpu/drm/gma500/cdv_intel_dp.c
+++ b/drivers/gpu/drm/gma500/cdv_intel_dp.c
@@ -2119,7 +2119,7 @@ cdv_intel_dp_init(struct drm_device *dev, struct psb_intel_mode_device *mode_dev
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



