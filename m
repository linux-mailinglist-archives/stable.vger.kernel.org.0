Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1BB774E771D
	for <lists+stable@lfdr.de>; Fri, 25 Mar 2022 16:25:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376620AbiCYP1I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Mar 2022 11:27:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376968AbiCYPXf (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Mar 2022 11:23:35 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D6B6A5EAB;
        Fri, 25 Mar 2022 08:17:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D068EB8288D;
        Fri, 25 Mar 2022 15:17:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EF80C340E9;
        Fri, 25 Mar 2022 15:17:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1648221421;
        bh=+K+8ORVeew4aVIzDkKIXqrFRlhb+qisqa78eUU2k22Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lImYnvu25m9ASG8kDIT7me/fqDoD0L9xfOeX4jITgTwauDJteirrg30tFkWRgEVi4
         m9NY1EVZjb8n+driaLWvqjxcXbcbf6xMIts4SNrU6W4zoClvIsFxYOv/VenZLYuP/E
         Yq6iDR3tXuGVGe9jP/pwphuEwh098Vbt0ae6mxOQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+72732c532ac1454eeee9@syzkaller.appspotmail.com,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.16 04/37] ALSA: oss: Fix PCM OSS buffer allocation overflow
Date:   Fri, 25 Mar 2022 16:14:14 +0100
Message-Id: <20220325150420.175382831@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220325150420.046488912@linuxfoundation.org>
References: <20220325150420.046488912@linuxfoundation.org>
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


