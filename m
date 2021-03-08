Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D620330E67
	for <lists+stable@lfdr.de>; Mon,  8 Mar 2021 13:37:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232207AbhCHMg4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Mar 2021 07:36:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:46466 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232312AbhCHMge (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Mar 2021 07:36:34 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D22CF65202;
        Mon,  8 Mar 2021 12:36:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615206992;
        bh=IueDbkhTl8hBVc5SO1/D8FeDFxJjAhWSs06PEWeQBlY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C38Cb4i1QTrghAsshlIrcZy0Sbl7naRpgYS7rx6I17QCIcRb8GJaKOVA8hhwrx00Y
         /pNChw2ntvcqjbNpnXkJkmm9LbzvgpZZljwLeGlWrDJ5rvTcR9KfrXgrWvGMdVfJZz
         ovAsCgS8V4ecM2bRWdbnqrVmzFVf7UweMp/+h2mU=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nicolas MURE <nicolas.mure2019@gmail.com>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 31/44] ALSA: usb-audio: Fix Pioneer DJM devices URB_CONTROL request direction to set samplerate
Date:   Mon,  8 Mar 2021 13:35:09 +0100
Message-Id: <20210308122720.085196430@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210308122718.586629218@linuxfoundation.org>
References: <20210308122718.586629218@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Nicolas MURE <nicolas.mure2019@gmail.com>

[ Upstream commit 2c9119001dcb1dc7027257c5d8960d30f5ba58be ]

This commit only contains the fix about the `URB_CONTROL` request
direction to set the samplerate of Pioneer DJM devices (`URB_CONTROL out`).

Fixes: 3b85f5fc75d5 ("ALSA: usb-audio: Add DJM450 to Pioneer format quirk")
Signed-off-by: Nicolas MURE <nicolas.mure2019@gmail.com>
Link: https://lore.kernel.org/r/20210301142927.14552-1-nicolas.mure2019@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/quirks.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/usb/quirks.c b/sound/usb/quirks.c
index 9ba4682ebc48..737b2729c0d3 100644
--- a/sound/usb/quirks.c
+++ b/sound/usb/quirks.c
@@ -1482,7 +1482,7 @@ static int pioneer_djm_set_format_quirk(struct snd_usb_substream *subs,
 	usb_set_interface(subs->dev, 0, 1);
 	// we should derive windex from fmt-sync_ep but it's not set
 	snd_usb_ctl_msg(subs->stream->chip->dev,
-		usb_rcvctrlpipe(subs->stream->chip->dev, 0),
+		usb_sndctrlpipe(subs->stream->chip->dev, 0),
 		0x01, 0x22, 0x0100, windex, &sr, 0x0003);
 	return 0;
 }
-- 
2.30.1



