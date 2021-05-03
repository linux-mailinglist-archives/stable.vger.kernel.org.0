Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 889BA371BCE
	for <lists+stable@lfdr.de>; Mon,  3 May 2021 18:50:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232864AbhECQsn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 May 2021 12:48:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:58932 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232970AbhECQqo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 May 2021 12:46:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id ED11F616E9;
        Mon,  3 May 2021 16:39:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620059971;
        bh=BDZsQZwC4C1fqBMdlxZ9PI+d1PKZotm8EjjbhzH/qS8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uAVuXsx8drTL9ZkpaBAywXDqYZ2KOSOJBV/E3hG1E9lZ2RmB9ge5UdJi/i4gE9mLM
         Jm4h8wJt+CbkivQzRRx0WNdFyuFYq0p5vHraCbndO7D9JOFbWQi/SdrIzavD2dqoJk
         fe0nvqHZVSxWUR41tdo158gsEBclWnt+hCht2ZMAe+RHfStHjoMb725OOSaxANdp/6
         fRJ33betoV8vRn4e7ZIq2+H7RlEo6iFmIAmSFKwJSNsDYL5T5osAb1/TmCdQAfUgdA
         Ycn6hIgzWJ2FVnHHwB+neKPzCTNY13ZaZvJvrv0KTEKOAIZchU7VcK50VCEi8YKub6
         94JYPb7tdp/Yg==
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
Subject: [PATCH AUTOSEL 5.10 040/100] drm/vkms: fix misuse of WARN_ON
Date:   Mon,  3 May 2021 12:37:29 -0400
Message-Id: <20210503163829.2852775-40-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210503163829.2852775-1-sashal@kernel.org>
References: <20210503163829.2852775-1-sashal@kernel.org>
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
index 09c012d54d58..1ae5cd47d954 100644
--- a/drivers/gpu/drm/vkms/vkms_crtc.c
+++ b/drivers/gpu/drm/vkms/vkms_crtc.c
@@ -18,7 +18,8 @@ static enum hrtimer_restart vkms_vblank_simulate(struct hrtimer *timer)
 
 	ret_overrun = hrtimer_forward_now(&output->vblank_hrtimer,
 					  output->period_ns);
-	WARN_ON(ret_overrun != 1);
+	if (ret_overrun != 1)
+		pr_warn("%s: vblank timer overrun\n", __func__);
 
 	spin_lock(&output->lock);
 	ret = drm_crtc_handle_vblank(crtc);
-- 
2.30.2

