Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D68A3371B5A
	for <lists+stable@lfdr.de>; Mon,  3 May 2021 18:45:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232233AbhECQpj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 May 2021 12:45:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:50704 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232762AbhECQmm (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 May 2021 12:42:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 80BD761402;
        Mon,  3 May 2021 16:38:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620059898;
        bh=vhNdZITQLLu1Vqwt/HaWW/3rsi9z4orMusNDvuWFim8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=grc704HIZV7nsT4pDk93U0DPVWtNIryqRwJwVnZgOE35CJ6dwqL+23QWtnfNnUiF3
         z8gVk4RsUb4bhhcVtLqSvmCqHuqdUd8v+1BkKgmZk7bsiQT4bSMd8XL7ul6PLTSaQV
         GBR8JZe9mcRrH+PVDjwCcLGUyqqfs3Pep8ksBzZ8scq5Cc5vlKZplyVmcc7KlaT5VP
         TgidJOUKLC7hNRtNLPlj84oPIGkOQhyWnQYUo4q+cK3JJzEyDwuXt/jO2WbQpdIxtL
         tVRjC6J0buGmYVcLrPpFWyys5IggqKj8Kus14ep0ErlvmiOuCqls0//uGoYLeUxap3
         8cU7SKkbRvoGA==
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
Subject: [PATCH AUTOSEL 5.11 051/115] drm/vkms: fix misuse of WARN_ON
Date:   Mon,  3 May 2021 12:35:55 -0400
Message-Id: <20210503163700.2852194-51-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210503163700.2852194-1-sashal@kernel.org>
References: <20210503163700.2852194-1-sashal@kernel.org>
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
index 0443b7deeaef..758d8a98d96b 100644
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

