Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE1A82E6976
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 17:50:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728508AbgL1QtP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 11:49:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:49800 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728049AbgL1MxI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 07:53:08 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 60E0622B45;
        Mon, 28 Dec 2020 12:52:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609159950;
        bh=3S7ORPcgh0u7YbAgO1rKmqlum0k39KZUXcXfuJPHr3o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bSZz5eJCoc5/b0Y8sEUl9mUhgcYyDIqVS0dgqnfufaP/4cqCyDkcTqMljyOUcOTqV
         jbIapi2XfLP9Bj3HF1yzwg53hP+xnAHCRkdYeCSMmpY8UfsaDAwznEH4kj6Q7Dhkqg
         joB7cgxvvGPkKmfZ9xVWVmSOvZNvW9+0SZh5/Vf4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tom Rix <trix@redhat.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 032/132] drm/gma500: fix double free of gma_connector
Date:   Mon, 28 Dec 2020 13:48:36 +0100
Message-Id: <20201228124847.954698214@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124846.409999325@linuxfoundation.org>
References: <20201228124846.409999325@linuxfoundation.org>
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
index 25c68e4dc7a53..e465d71272584 100644
--- a/drivers/gpu/drm/gma500/cdv_intel_dp.c
+++ b/drivers/gpu/drm/gma500/cdv_intel_dp.c
@@ -2125,7 +2125,7 @@ cdv_intel_dp_init(struct drm_device *dev, struct psb_intel_mode_device *mode_dev
 			DRM_INFO("failed to retrieve link info, disabling eDP\n");
 			cdv_intel_dp_encoder_destroy(encoder);
 			cdv_intel_dp_destroy(connector);
-			goto err_priv;
+			goto err_connector;
 		} else {
         		DRM_DEBUG_KMS("DPCD: Rev=%x LN_Rate=%x LN_CNT=%x LN_DOWNSP=%x\n",
 				intel_dp->dpcd[0], intel_dp->dpcd[1], 
-- 
2.27.0



