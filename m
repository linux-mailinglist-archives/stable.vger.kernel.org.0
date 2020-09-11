Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1F9C266198
	for <lists+stable@lfdr.de>; Fri, 11 Sep 2020 16:56:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726053AbgIKO4Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Sep 2020 10:56:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:54386 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726179AbgIKNCU (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 11 Sep 2020 09:02:20 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1B2C1222B8;
        Fri, 11 Sep 2020 12:57:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599829035;
        bh=ClG/J2D28CSekcsEzvDrVhqfY9dWzpT8JjtNaDePcb8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MVeDAuWkiA7o1MJosvUYy92ZX3ltQWkyWtE1ngLOI8Q6BefPwyC7GOFOXT+PhKtTZ
         r4b0GZCAU7vXjsRdLWVoBv6Aa0Zm1dQluBuVD6n+DX65+mlgiJvdpkV52eF2tgVxue
         UZE1YbQrvTIvuxfpSD47NKXwe1Q+to3ozNpver1A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+23b22dc2e0b81cbfcc95@syzkaller.appspotmail.com,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 4.9 41/71] ALSA: pcm: oss: Remove superfluous WARN_ON() for mulaw sanity check
Date:   Fri, 11 Sep 2020 14:46:25 +0200
Message-Id: <20200911122506.974371137@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200911122504.928931589@linuxfoundation.org>
References: <20200911122504.928931589@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

commit 949a1ebe8cea7b342085cb6a4946b498306b9493 upstream.

The PCM OSS mulaw plugin has a check of the format of the counter part
whether it's a linear format.  The check is with snd_BUG_ON() that
emits WARN_ON() when the debug config is set, and it confuses
syzkaller as if it were a serious issue.  Let's drop snd_BUG_ON() for
avoiding that.

While we're at it, correct the error code to a more suitable, EINVAL.

Reported-by: syzbot+23b22dc2e0b81cbfcc95@syzkaller.appspotmail.com
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20200901131802.18157-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/core/oss/mulaw.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/sound/core/oss/mulaw.c
+++ b/sound/core/oss/mulaw.c
@@ -329,8 +329,8 @@ int snd_pcm_plugin_build_mulaw(struct sn
 		snd_BUG();
 		return -EINVAL;
 	}
-	if (snd_BUG_ON(!snd_pcm_format_linear(format->format)))
-		return -ENXIO;
+	if (!snd_pcm_format_linear(format->format))
+		return -EINVAL;
 
 	err = snd_pcm_plugin_build(plug, "Mu-Law<->linear conversion",
 				   src_format, dst_format,


