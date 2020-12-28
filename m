Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C60482E3C34
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 14:59:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407719AbgL1N74 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:59:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:33610 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2407684AbgL1N7z (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:59:55 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AF754206D4;
        Mon, 28 Dec 2020 13:59:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609163955;
        bh=BxiCYZ2cTh0ux6+6x50Rv2RPrYmwMf1HxovOCmgc0CA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=keglNTPlM42ASIp+N638ZBZBBU+2NgsVgrImwYAh2LcxRpXEywUkdq4cvf3ViJ86l
         nwOb79vUELKBgZpmREsRmIPt3ewaAAdGyl22MvVB9ENAv4o7ZmrzShS0oQz9Q1zslk
         2WhfS8GiTWIMqoITb5BZmDKstai2IBVmanLlORTs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tom Rix <trix@redhat.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 002/717] drm/gma500: fix double free of gma_connector
Date:   Mon, 28 Dec 2020 13:40:00 +0100
Message-Id: <20201228125021.100600052@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tom Rix <trix@redhat.com>

[ Upstream commit 4e19d51ca5b28a1d435a844c7b2a8e1b1b6fa237 ]

clang static analysis reports this problem:

cdv_intel_dp.c:2101:2: warning: Attempt to free released memory
        kfree(gma_connector);
        ^~~~~~~~~~~~~~~~~~~~

In cdv_intel_dp_init() when the call to cdv_intel_edp_panel_vdd_off()
fails, the handler calls cdv_intel_dp_destroy(connector) which does
the first free of gma_connector. So adjust the goto label and skip
the second free.

Fixes: d112a8163f83 ("gma500/cdv: Add eDP support")
Signed-off-by: Tom Rix <trix@redhat.com>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Link: https://patchwork.freedesktop.org/patch/msgid/20201003193928.18869-1-trix@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/gma500/cdv_intel_dp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/gma500/cdv_intel_dp.c b/drivers/gpu/drm/gma500/cdv_intel_dp.c
index 720a767118c9c..deb4fd13591d2 100644
--- a/drivers/gpu/drm/gma500/cdv_intel_dp.c
+++ b/drivers/gpu/drm/gma500/cdv_intel_dp.c
@@ -2083,7 +2083,7 @@ cdv_intel_dp_init(struct drm_device *dev, struct psb_intel_mode_device *mode_dev
 			DRM_INFO("failed to retrieve link info, disabling eDP\n");
 			drm_encoder_cleanup(encoder);
 			cdv_intel_dp_destroy(connector);
-			goto err_priv;
+			goto err_connector;
 		} else {
         		DRM_DEBUG_KMS("DPCD: Rev=%x LN_Rate=%x LN_CNT=%x LN_DOWNSP=%x\n",
 				intel_dp->dpcd[0], intel_dp->dpcd[1], 
-- 
2.27.0



