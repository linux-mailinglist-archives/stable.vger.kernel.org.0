Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5AB29144FE9
	for <lists+stable@lfdr.de>; Wed, 22 Jan 2020 10:42:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387698AbgAVJmT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jan 2020 04:42:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:34088 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733172AbgAVJmS (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Jan 2020 04:42:18 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0B37424680;
        Wed, 22 Jan 2020 09:42:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579686138;
        bh=mVsDAopeiFdOOAJlD7vY5WAS4z+/vv+buahmyoiVCKE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gNadaqNH4womxjxwd4wUEE87CGyi/CNgJtTd9P3fe3saUtCX1lGh8Q/HCwYnmgZq6
         5DZMm6oXQ47bsQa02ZplXeRnlKvPquuDe+hGVfO3rkmMijUrS0z7silEbZbApky5Ea
         2Af/kQD3gyBUp2lDo823a224Trn16UcR6PCQDAnI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Sakamoto <o-takashi@sakamocchi.jp>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 4.19 023/103] ALSA: dice: fix fallback from protocol extension into limited functionality
Date:   Wed, 22 Jan 2020 10:28:39 +0100
Message-Id: <20200122092807.241889346@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200122092803.587683021@linuxfoundation.org>
References: <20200122092803.587683021@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Sakamoto <o-takashi@sakamocchi.jp>

commit 3e2dc6bdb56893bc28257e482e1dbe5d39f313df upstream.

At failure of attempt to detect protocol extension, ALSA dice driver
should be fallback to limited functionality. However it's not.

This commit fixes it.

Cc: <stable@vger.kernel.org> # v4.18+
Fixes: 58579c056c1c9 ("ALSA: dice: use extended protocol to detect available stream formats")
Signed-off-by: Takashi Sakamoto <o-takashi@sakamocchi.jp>
Link: https://lore.kernel.org/r/20200113084630.14305-2-o-takashi@sakamocchi.jp
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/firewire/dice/dice-extension.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/sound/firewire/dice/dice-extension.c
+++ b/sound/firewire/dice/dice-extension.c
@@ -159,8 +159,11 @@ int snd_dice_detect_extension_formats(st
 		int j;
 
 		for (j = i + 1; j < 9; ++j) {
-			if (pointers[i * 2] == pointers[j * 2])
+			if (pointers[i * 2] == pointers[j * 2]) {
+				// Fallback to limited functionality.
+				err = -ENXIO;
 				goto end;
+			}
 		}
 	}
 


