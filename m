Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51EF6329093
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 21:12:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239634AbhCAUKJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 15:10:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:36108 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242347AbhCAUBA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 15:01:00 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B3AD36534A;
        Mon,  1 Mar 2021 17:57:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614621431;
        bh=3MP58ahElmf28SkJLmVjrVG3eOZ4pl8zoP9WiVrqdyg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q12JkT7YABBUtx7h8W48zO3jyvFjPC9e9x/2CLKadNv16SgpPifNEaPXTguV0VuQ0
         lSExQYQ82xEAp6iDwEI/xLrlAAWH/JblP9wv1775svASPaUB0ipRrgBLB0uspsiLGw
         gLCdtJSHZ86VKr0ZSZlKnhLm+zaK0zGwmpn1Xrdo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sean Paul <sean@poorly.run>,
        Kuogee Hsieh <khsieh@codeaurora.org>,
        linux-arm-msm@vger.kernel.org, dri-devel@lists.freedesktop.org,
        freedreno@lists.freedesktop.org, Lee Jones <lee.jones@linaro.org>,
        Stephen Boyd <swboyd@chromium.org>,
        Rob Clark <robdclark@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 513/775] drm/msm/dp: Add a missing semi-colon
Date:   Mon,  1 Mar 2021 17:11:21 +0100
Message-Id: <20210301161226.875706220@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stephen Boyd <swboyd@chromium.org>

[ Upstream commit 182b4a2d251305201b6f9cae29067f7112f05835 ]

A missing semicolon here causes my external display to stop working.
Indeed, missing the semicolon on the return statement leads to
dp_panel_update_tu_timings() not existing because the compiler thinks
it's part of the return statement of a void function, so it must not be
important.

  $ ./scripts/bloat-o-meter before.o after.o
  add/remove: 1/1 grow/shrink: 0/1 up/down: 7400/-7540 (-140)
  Function                                     old     new   delta
  dp_panel_update_tu_timings                     -    7400   +7400
  _dp_ctrl_calc_tu.constprop                 18024   17900    -124
  dp_panel_update_tu_timings.constprop        7416       -   -7416
  Total: Before=54440, After=54300, chg -0.26%

Add a semicolon so this function works like it used to.

Cc: Sean Paul <sean@poorly.run>
Cc: Kuogee Hsieh <khsieh@codeaurora.org>
Cc: linux-arm-msm@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org
Cc: freedreno@lists.freedesktop.org
Cc: Lee Jones <lee.jones@linaro.org>
Fixes: cc9014bf63a4 ("drm/msm/dp/dp_ctrl: Move 'tu' from the stack to the heap")
Signed-off-by: Stephen Boyd <swboyd@chromium.org>
Signed-off-by: Rob Clark <robdclark@chromium.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/dp/dp_ctrl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/msm/dp/dp_ctrl.c b/drivers/gpu/drm/msm/dp/dp_ctrl.c
index e3462f5d96d75..6cbe10af0a7af 100644
--- a/drivers/gpu/drm/msm/dp/dp_ctrl.c
+++ b/drivers/gpu/drm/msm/dp/dp_ctrl.c
@@ -631,7 +631,7 @@ static void _dp_ctrl_calc_tu(struct dp_tu_calc_input *in,
 
 	tu = kzalloc(sizeof(*tu), GFP_KERNEL);
 	if (!tu)
-		return
+		return;
 
 	dp_panel_update_tu_timings(in, tu);
 
-- 
2.27.0



