Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B33D41D8551
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 20:18:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731591AbgERR4I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 13:56:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:33818 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730533AbgERR4I (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 May 2020 13:56:08 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 22BDD20674;
        Mon, 18 May 2020 17:56:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589824567;
        bh=oumdqq5M0SuM2SQsIaos21dD5nC+FF03EA6GtDsuixI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zRUJFIrTi6Pl2JfUH49ycirvBmyUeEbvjEGpLVoNvIjStfC9hrPLDrlru0rFNUPfO
         dVjiq8E0CVWAYnzBo7sIaogP+9RNL+1Mxu04I+euAM+hQH//2wuqAovgMNYhAhk8R1
         5nwrNZ1lX+TrKi2aVpZkK3b9WgIrcbJaB+ApWXcs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sultan Alsawaf <sultan@kerneltoast.com>,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
        <ville.syrjala@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 063/147] drm/i915: Dont enable WaIncreaseLatencyIPCEnabled when IPC is disabled
Date:   Mon, 18 May 2020 19:36:26 +0200
Message-Id: <20200518173521.888772096@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200518173513.009514388@linuxfoundation.org>
References: <20200518173513.009514388@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sultan Alsawaf <sultan@kerneltoast.com>

[ Upstream commit 421abe200321a2c907ede1a6208c558284ba0b75 ]

In commit 5a7d202b1574, a logical AND was erroneously changed to an OR,
causing WaIncreaseLatencyIPCEnabled to be enabled unconditionally for
kabylake and coffeelake, even when IPC is disabled. Fix the logic so
that WaIncreaseLatencyIPCEnabled is only used when IPC is enabled.

Fixes: 5a7d202b1574 ("drm/i915: Drop WaIncreaseLatencyIPCEnabled/1140 for cnl")
Cc: stable@vger.kernel.org # 5.3.x+
Signed-off-by: Sultan Alsawaf <sultan@kerneltoast.com>
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20200430214654.51314-1-sultan@kerneltoast.com
(cherry picked from commit 690d22dafa88b82453516387b475664047a6bd14)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/intel_pm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/intel_pm.c b/drivers/gpu/drm/i915/intel_pm.c
index 3ccfc025fde21..ade607d93e45d 100644
--- a/drivers/gpu/drm/i915/intel_pm.c
+++ b/drivers/gpu/drm/i915/intel_pm.c
@@ -4784,7 +4784,7 @@ static void skl_compute_plane_wm(const struct intel_crtc_state *crtc_state,
 	 * WaIncreaseLatencyIPCEnabled: kbl,cfl
 	 * Display WA #1141: kbl,cfl
 	 */
-	if ((IS_KABYLAKE(dev_priv) || IS_COFFEELAKE(dev_priv)) ||
+	if ((IS_KABYLAKE(dev_priv) || IS_COFFEELAKE(dev_priv)) &&
 	    dev_priv->ipc_enabled)
 		latency += 4;
 
-- 
2.20.1



