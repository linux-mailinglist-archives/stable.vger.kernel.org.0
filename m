Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BA372E373B
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 13:54:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727924AbgL1Mwx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 07:52:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:49800 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727913AbgL1Mwx (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 07:52:53 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 967EF229C5;
        Mon, 28 Dec 2020 12:51:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609159913;
        bh=IBN4FXt4kUT2e8XoT0yEQUrj7qMsz1qCie4Ktrr0Kto=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gc3GvmnsWTfYGE9Tp94q3uaVAbF+lnAjdReYaibUs+OoL4ou6n5oUHmoMu6gH4hB6
         GLYBnlo7SSEauNo+ezMiTx+tuID6WybPVBthiz3/IJtUEeyzNyZMm7c4QEJ744AcMt
         QYKcFd/uMxW7N70Mz91gds0Ry98t4KpOxNFE/O3c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+df7dc146ebdd6435eea3@syzkaller.appspotmail.com,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 4.4 019/132] ALSA: pcm: oss: Fix potential out-of-bounds shift
Date:   Mon, 28 Dec 2020 13:48:23 +0100
Message-Id: <20201228124847.339806144@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124846.409999325@linuxfoundation.org>
References: <20201228124846.409999325@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

commit 175b8d89fe292796811fdee87fa39799a5b6b87a upstream.

syzbot spotted a potential out-of-bounds shift in the PCM OSS layer
where it calculates the buffer size with the arbitrary shift value
given via an ioctl.

Add a range check for avoiding the undefined behavior.
As the value can be treated by a signed integer, the max shift should
be 30.

Reported-by: syzbot+df7dc146ebdd6435eea3@syzkaller.appspotmail.com
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20201209084552.17109-2-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/core/oss/pcm_oss.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/sound/core/oss/pcm_oss.c
+++ b/sound/core/oss/pcm_oss.c
@@ -2000,11 +2000,15 @@ static int snd_pcm_oss_set_subdivide(str
 static int snd_pcm_oss_set_fragment1(struct snd_pcm_substream *substream, unsigned int val)
 {
 	struct snd_pcm_runtime *runtime;
+	int fragshift;
 
 	runtime = substream->runtime;
 	if (runtime->oss.subdivision || runtime->oss.fragshift)
 		return -EINVAL;
-	runtime->oss.fragshift = val & 0xffff;
+	fragshift = val & 0xffff;
+	if (fragshift >= 31)
+		return -EINVAL;
+	runtime->oss.fragshift = fragshift;
 	runtime->oss.maxfrags = (val >> 16) & 0xffff;
 	if (runtime->oss.fragshift < 4)		/* < 16 */
 		runtime->oss.fragshift = 4;


