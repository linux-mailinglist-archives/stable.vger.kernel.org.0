Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BE4821674F1
	for <lists+stable@lfdr.de>; Fri, 21 Feb 2020 09:30:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387627AbgBUITp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Feb 2020 03:19:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:58462 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387764AbgBUITn (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Feb 2020 03:19:43 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A068024694;
        Fri, 21 Feb 2020 08:19:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582273183;
        bh=EuFzhoLZW1Xqcn9uKBwQn2yQLYSQNUgB5uOubWxz5C8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Nh86zzYdfAfRbphBttweWknTVSBNr/Bk4Q98sjxYoHmf9G2ZgMdwAs+OESp4+cuSw
         8nMeP28qTSdl8THlLt33EUvJpclBaHID0SjR5V6BwdGWVPE6LShZ3FM8HxJwcoQqgK
         JRBf5ByBKwuQ9hGzYI2jVjespCz31wxGuSvxWqbI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Larry Finger <Larry.Finger@lwfinger.net>,
        Phong Tran <tranmanphong@gmail.com>,
        Kees Cook <keescook@chromium.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 075/191] b43legacy: Fix -Wcast-function-type
Date:   Fri, 21 Feb 2020 08:40:48 +0100
Message-Id: <20200221072300.301492414@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200221072250.732482588@linuxfoundation.org>
References: <20200221072250.732482588@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Phong Tran <tranmanphong@gmail.com>

[ Upstream commit 475eec112e4267232d10f4afe2f939a241692b6c ]

correct usage prototype of callback in tasklet_init().
Report by https://github.com/KSPP/linux/issues/20

Tested-by: Larry Finger <Larry.Finger@lwfinger.net>
Signed-off-by: Phong Tran <tranmanphong@gmail.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/broadcom/b43legacy/main.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/broadcom/b43legacy/main.c b/drivers/net/wireless/broadcom/b43legacy/main.c
index 55f411925960e..770cc218ca4bd 100644
--- a/drivers/net/wireless/broadcom/b43legacy/main.c
+++ b/drivers/net/wireless/broadcom/b43legacy/main.c
@@ -1304,8 +1304,9 @@ static void handle_irq_ucode_debug(struct b43legacy_wldev *dev)
 }
 
 /* Interrupt handler bottom-half */
-static void b43legacy_interrupt_tasklet(struct b43legacy_wldev *dev)
+static void b43legacy_interrupt_tasklet(unsigned long data)
 {
+	struct b43legacy_wldev *dev = (struct b43legacy_wldev *)data;
 	u32 reason;
 	u32 dma_reason[ARRAY_SIZE(dev->dma_reason)];
 	u32 merged_dma_reason = 0;
@@ -3775,7 +3776,7 @@ static int b43legacy_one_core_attach(struct ssb_device *dev,
 	b43legacy_set_status(wldev, B43legacy_STAT_UNINIT);
 	wldev->bad_frames_preempt = modparam_bad_frames_preempt;
 	tasklet_init(&wldev->isr_tasklet,
-		     (void (*)(unsigned long))b43legacy_interrupt_tasklet,
+		     b43legacy_interrupt_tasklet,
 		     (unsigned long)wldev);
 	if (modparam_pio)
 		wldev->__using_pio = true;
-- 
2.20.1



