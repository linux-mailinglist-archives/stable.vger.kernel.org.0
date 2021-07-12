Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CD193C4768
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:27:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235435AbhGLGcf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:32:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:54420 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235750AbhGLGbl (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:31:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 003FD60234;
        Mon, 12 Jul 2021 06:28:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626071333;
        bh=h+k84+0MbyDGgViUk+0tb+vj69tJF6UgaHARYATaxGQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rjgsiiF0sExly/uz4h0ztFX0hJSXS9pqSTZUJubB8M5q25RKocj7lzrnNrGxHZlkj
         2NKHXwPzpkGwCyZ0wIC3KaPAgEERlFwdKXWakSbY1a80UWYHTKLF7RXSXyBl6CZxZX
         Zleb1xIBMd0i9pUaYC8Lat1bEKFWyV44q4HjMf7g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Takashi Iwai <tiwai@suse.de>, Max Filippov <jcmvbkbc@gmail.com>
Subject: [PATCH 5.10 008/593] ALSA: intel8x0: Fix breakage at ac97 clock measurement
Date:   Mon, 12 Jul 2021 08:02:48 +0200
Message-Id: <20210712060844.093430508@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060843.180606720@linuxfoundation.org>
References: <20210712060843.180606720@linuxfoundation.org>
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
@@ -715,7 +715,7 @@ static inline void snd_intel8x0_update(s
 	int status, civ, i, step;
 	int ack = 0;
 
-	if (!ichdev->prepared || ichdev->suspended)
+	if (!(ichdev->prepared || chip->in_measurement) || ichdev->suspended)
 		return;
 
 	spin_lock_irqsave(&chip->reg_lock, flags);


