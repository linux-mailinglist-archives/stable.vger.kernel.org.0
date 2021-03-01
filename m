Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF94D3288F3
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 18:52:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235982AbhCARrN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 12:47:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:60232 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238313AbhCARlm (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 12:41:42 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9F0A8650C9;
        Mon,  1 Mar 2021 16:57:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614617825;
        bh=QWf5KA6Q7ONSpxkmBHHYXcCdlxgUzjlPgHWdomIsv1g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ti53beJsqQG5v/nmYuxhcgSJoe5prpbiCV/ulY2DyB6a+RBEOiD0FUL6zakXdi+9U
         Ps0A1mr5DADerV0PSkA5trS7OtDh5iLcHnPriVUDbw7IfJHAZidgykg3iHO2h1JfhG
         q3VEwrKk5hoNeG6vO0boEgHRbVmy3ggGu8sBimYc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Iskren Chernev <iskren.chernev@gmail.com>,
        Rob Clark <robdclark@gmail.com>,
        Rob Clark <robdclark@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 210/340] drm/msm/mdp5: Fix wait-for-commit for cmd panels
Date:   Mon,  1 Mar 2021 17:12:34 +0100
Message-Id: <20210301161058.634180432@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161048.294656001@linuxfoundation.org>
References: <20210301161048.294656001@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Iskren Chernev <iskren.chernev@gmail.com>

[ Upstream commit 68e4f01fddb4ead80e8c7084db489307f22c9cbb ]

Before the offending commit in msm_atomic_commit_tail wait_flush was
called once per frame, after the commit was submitted. After it
wait_flush is also called at the beginning to ensure previous
potentially async commits are done.

For cmd panels the source of wait_flush is a ping-pong irq notifying
a completion. The completion needs to be notified with complete_all so
multiple waiting parties (new async committers) can proceed.

Signed-off-by: Iskren Chernev <iskren.chernev@gmail.com>
Suggested-by: Rob Clark <robdclark@gmail.com>
Fixes: 2d99ced787e3d ("drm/msm: async commit support")
Signed-off-by: Rob Clark <robdclark@chromium.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/disp/mdp5/mdp5_crtc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/msm/disp/mdp5/mdp5_crtc.c b/drivers/gpu/drm/msm/disp/mdp5/mdp5_crtc.c
index 03c6d6157e4d0..395146884a222 100644
--- a/drivers/gpu/drm/msm/disp/mdp5/mdp5_crtc.c
+++ b/drivers/gpu/drm/msm/disp/mdp5/mdp5_crtc.c
@@ -1099,7 +1099,7 @@ static void mdp5_crtc_pp_done_irq(struct mdp_irq *irq, uint32_t irqstatus)
 	struct mdp5_crtc *mdp5_crtc = container_of(irq, struct mdp5_crtc,
 								pp_done);
 
-	complete(&mdp5_crtc->pp_completion);
+	complete_all(&mdp5_crtc->pp_completion);
 }
 
 static void mdp5_crtc_wait_for_pp_done(struct drm_crtc *crtc)
-- 
2.27.0



