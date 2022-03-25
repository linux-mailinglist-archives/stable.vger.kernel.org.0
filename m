Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64D654E774B
	for <lists+stable@lfdr.de>; Fri, 25 Mar 2022 16:26:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376573AbiCYP1s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Mar 2022 11:27:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378079AbiCYPYw (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Mar 2022 11:24:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91478E9C9D;
        Fri, 25 Mar 2022 08:19:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 115FC61451;
        Fri, 25 Mar 2022 15:19:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 230ACC340E9;
        Fri, 25 Mar 2022 15:19:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1648221583;
        bh=+K+8ORVeew4aVIzDkKIXqrFRlhb+qisqa78eUU2k22Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gNPhcHgfccp89JLuxc1OoVgIT8v67q5Jy4RII3gkjuztxcKeAO7Y1FvtO8l+qnVmt
         9BKy10rNVA6rJssklHYSy7z2GWj6mqdUReuZb22Iji9ivpFM2uNmBSZSApprPHNXGh
         JFnkhNzzLSN9LNpg+qVLJelbwb9joLzCw+rnLgxk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+72732c532ac1454eeee9@syzkaller.appspotmail.com,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.17 05/39] ALSA: oss: Fix PCM OSS buffer allocation overflow
Date:   Fri, 25 Mar 2022 16:14:20 +0100
Message-Id: <20220325150420.401576412@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220325150420.245733653@linuxfoundation.org>
References: <20220325150420.245733653@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

commit efb6402c3c4a7c26d97c92d70186424097b6e366 upstream.

We've got syzbot reports hitting INT_MAX overflow at vmalloc()
allocation that is called from snd_pcm_plug_alloc().  Although we
apply the restrictions to input parameters, it's based only on the
hw_params of the underlying PCM device.  Since the PCM OSS layer
allocates a temporary buffer for the data conversion, the size may
become unexpectedly large when more channels or higher rates is given;
in the reported case, it went over INT_MAX, hence it hits WARN_ON().

This patch is an attempt to avoid such an overflow and an allocation
for too large buffers.  First off, it adds the limit of 1MB as the
upper bound for period bytes.  This must be large enough for all use
cases, and we really don't want to handle a larger temporary buffer
than this size.  The size check is performed at two places, where the
original period bytes is calculated and where the plugin buffer size
is calculated.

In addition, the driver uses array_size() and array3_size() for
multiplications to catch overflows for the converted period size and
buffer bytes.

Reported-by: syzbot+72732c532ac1454eeee9@syzkaller.appspotmail.com
Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/00000000000085b1b305da5a66f3@google.com
Link: https://lore.kernel.org/r/20220318082036.29699-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/core/oss/pcm_oss.c    |   12 ++++++++----
 sound/core/oss/pcm_plugin.c |    5 ++++-
 2 files changed, 12 insertions(+), 5 deletions(-)

--- a/sound/core/oss/pcm_oss.c
+++ b/sound/core/oss/pcm_oss.c
@@ -774,6 +774,11 @@ static int snd_pcm_oss_period_size(struc
 
 	if (oss_period_size < 16)
 		return -EINVAL;
+
+	/* don't allocate too large period; 1MB period must be enough */
+	if (oss_period_size > 1024 * 1024)
+		return -ENOMEM;
+
 	runtime->oss.period_bytes = oss_period_size;
 	runtime->oss.period_frames = 1;
 	runtime->oss.periods = oss_periods;
@@ -1043,10 +1048,9 @@ static int snd_pcm_oss_change_params_loc
 			goto failure;
 	}
 #endif
-	oss_period_size *= oss_frame_size;
-
-	oss_buffer_size = oss_period_size * runtime->oss.periods;
-	if (oss_buffer_size < 0) {
+	oss_period_size = array_size(oss_period_size, oss_frame_size);
+	oss_buffer_size = array_size(oss_period_size, runtime->oss.periods);
+	if (oss_buffer_size <= 0) {
 		err = -EINVAL;
 		goto failure;
 	}
--- a/sound/core/oss/pcm_plugin.c
+++ b/sound/core/oss/pcm_plugin.c
@@ -62,7 +62,10 @@ static int snd_pcm_plugin_alloc(struct s
 	width = snd_pcm_format_physical_width(format->format);
 	if (width < 0)
 		return width;
-	size = frames * format->channels * width;
+	size = array3_size(frames, format->channels, width);
+	/* check for too large period size once again */
+	if (size > 1024 * 1024)
+		return -ENOMEM;
 	if (snd_BUG_ON(size % 8))
 		return -ENXIO;
 	size /= 8;


