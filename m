Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E17A3C50CC
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:46:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243392AbhGLHfS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:35:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:49338 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346954AbhGLHbS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:31:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 982D86052B;
        Mon, 12 Jul 2021 07:28:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626074910;
        bh=lxWKkhWvx7weg2HTlJ+Tg5ExhWIeVZT0LJuJjQ5AMro=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ADmkQFI1taJRPuG9xappVzXgLjt4KLIMuEPKrLNneViA51be4Q1077VznX3REbRWb
         RpNsHrsDPC8DJKPniYkKJdD/8KI4gu7gkjyRy8d2mqEkB8gxGCYQJoV5j3WnAWZg5A
         vGca+NhmWKneNaP93xhYiAVGjEmomSgy0JnQjfpU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Takashi Iwai <tiwai@suse.de>, Max Filippov <jcmvbkbc@gmail.com>
Subject: [PATCH 5.13 009/800] ALSA: intel8x0: Fix breakage at ac97 clock measurement
Date:   Mon, 12 Jul 2021 08:00:32 +0200
Message-Id: <20210712060914.420979735@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

commit 24d1e49415be546470b20429d748e240d0518b7e upstream.

The recent workaround for the wild interrupts in commit c1f0616124c4
("ALSA: intel8x0: Don't update period unless prepared") leaded to a
regression, causing the interrupt storm during ac97 clock measurement
at the driver probe.  We need to handle the interrupt while the clock
measurement as well as the proper PCM streams.

Fixes: c1f0616124c4 ("ALSA: intel8x0: Don't update period unless prepared")
Reported-and-tested-by: Max Filippov <jcmvbkbc@gmail.com>
Tested-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/CAMo8BfKKMQkcsbOQaeEjq_FsJhdK=fn598dvh7YOcZshUSOH=g@mail.gmail.com
Link: https://lore.kernel.org/r/20210708090738.1569-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/intel8x0.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/pci/intel8x0.c
+++ b/sound/pci/intel8x0.c
@@ -692,7 +692,7 @@ static inline void snd_intel8x0_update(s
 	int status, civ, i, step;
 	int ack = 0;
 
-	if (!ichdev->prepared || ichdev->suspended)
+	if (!(ichdev->prepared || chip->in_measurement) || ichdev->suspended)
 		return;
 
 	spin_lock_irqsave(&chip->reg_lock, flags);


