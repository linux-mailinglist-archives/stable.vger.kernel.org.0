Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DE2C371C21
	for <lists+stable@lfdr.de>; Mon,  3 May 2021 18:51:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233383AbhECQvY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 May 2021 12:51:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:60882 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233815AbhECQt3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 May 2021 12:49:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A854061878;
        Mon,  3 May 2021 16:40:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620060022;
        bh=sOPULUfEgZmCDIB0ObI3ldEFx6HgXF7iWobRnkFKyuo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a9NNcnwFYjLKV3tfpENzUTJIpgXOSoeTwJZoUbImBQaZjN2bR+P2sUdMDecep4s5H
         z8CEVLa4yMckOpSi5YrYnu7epWIhqQt4QJr8eXtlJfO6wYJKdPSLK8KKuwEbjr3ocW
         kDzfbrgRc32VAJA9kBjmPXljNUSc/lmLzp1/ZSMU9HiK3VSnTWAfx4V2oFfSnO/kw2
         Ps5RyR7/KKKb9UIyHEPpGX4bknFsUitmoCxwHMrhgRRpX5pSK0zqoWmXRl/28Yutq7
         AOaZIQ3afVJ1m3n4CETBu1ZjMTLNcPyjpBe4rBC9Tn+2CVWFaCeu3ipKUNfw8MBTtY
         n2uoGHegpiT8w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dmitry Vyukov <dvyukov@google.com>,
        syzbot+4fc21a003c8332eb0bdd@syzkaller.appspotmail.com,
        Rodrigo Siqueira <rodrigosiqueiramelo@gmail.com>,
        Melissa Wen <melissa.srw@gmail.com>,
        Haneen Mohammed <hamohammed.sa@gmail.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        David Airlie <airlied@linux.ie>,
        dri-devel@lists.freedesktop.org, Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.4 26/57] drm/vkms: fix misuse of WARN_ON
Date:   Mon,  3 May 2021 12:39:10 -0400
Message-Id: <20210503163941.2853291-26-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210503163941.2853291-1-sashal@kernel.org>
References: <20210503163941.2853291-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmitry Vyukov <dvyukov@google.com>

[ Upstream commit b4142fc4d52d051d4d8df1fb6c569e5b445d369e ]

vkms_vblank_simulate() uses WARN_ON for timing-dependent condition
(timer overrun). This is a mis-use of WARN_ON, WARN_ON must be used
to denote kernel bugs. Use pr_warn() instead.

Signed-off-by: Dmitry Vyukov <dvyukov@google.com>
Reported-by: syzbot+4fc21a003c8332eb0bdd@syzkaller.appspotmail.com
Cc: Rodrigo Siqueira <rodrigosiqueiramelo@gmail.com>
Cc: Melissa Wen <melissa.srw@gmail.com>
Cc: Haneen Mohammed <hamohammed.sa@gmail.com>
Cc: Daniel Vetter <daniel@ffwll.ch>
Cc: David Airlie <airlied@linux.ie>
Cc: dri-devel@lists.freedesktop.org
Cc: linux-kernel@vger.kernel.org
Acked-by: Melissa Wen <melissa.srw@gmail.com>
Signed-off-by: Melissa Wen <melissa.srw@gmail.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20210320132840.1315853-1-dvyukov@google.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/vkms/vkms_crtc.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/vkms/vkms_crtc.c b/drivers/gpu/drm/vkms/vkms_crtc.c
index 927dafaebc76..8b01fae65f43 100644
--- a/drivers/gpu/drm/vkms/vkms_crtc.c
+++ b/drivers/gpu/drm/vkms/vkms_crtc.c
@@ -20,7 +20,8 @@ static enum hrtimer_restart vkms_vblank_simulate(struct hrtimer *timer)
 
 	ret_overrun = hrtimer_forward_now(&output->vblank_hrtimer,
 					  output->period_ns);
-	WARN_ON(ret_overrun != 1);
+	if (ret_overrun != 1)
+		pr_warn("%s: vblank timer overrun\n", __func__);
 
 	ret = drm_crtc_handle_vblank(crtc);
 	if (!ret)
-- 
2.30.2

