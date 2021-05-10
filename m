Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C1943782BC
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 12:37:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232455AbhEJKhL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 06:37:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:41940 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232888AbhEJKfV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 06:35:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A133161929;
        Mon, 10 May 2021 10:28:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620642521;
        bh=sOPULUfEgZmCDIB0ObI3ldEFx6HgXF7iWobRnkFKyuo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KPFhopUzYY1qIaA/6kVYSasyCPo51T33pjCBbIozHWnFJh6Zdd7BupK4kcnui9cLp
         ZlAqrKhev2MlTU7jffM7VXdbv5Drq8X2phwkv/yKpMGJrr36BFhlEIkk9Zdwzzyf1q
         Wizdsfe7IKfjeuu26pEfJJrPnuKKs7+o5rb/mXt0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dmitry Vyukov <dvyukov@google.com>,
        syzbot+4fc21a003c8332eb0bdd@syzkaller.appspotmail.com,
        Rodrigo Siqueira <rodrigosiqueiramelo@gmail.com>,
        Melissa Wen <melissa.srw@gmail.com>,
        Haneen Mohammed <hamohammed.sa@gmail.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        David Airlie <airlied@linux.ie>,
        dri-devel@lists.freedesktop.org, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 093/184] drm/vkms: fix misuse of WARN_ON
Date:   Mon, 10 May 2021 12:19:47 +0200
Message-Id: <20210510101953.232067343@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510101950.200777181@linuxfoundation.org>
References: <20210510101950.200777181@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



