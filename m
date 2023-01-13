Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04681669CF5
	for <lists+stable@lfdr.de>; Fri, 13 Jan 2023 16:53:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230400AbjAMPxG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Jan 2023 10:53:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230323AbjAMPwJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 13 Jan 2023 10:52:09 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3D7F8BAB8
        for <stable@vger.kernel.org>; Fri, 13 Jan 2023 07:45:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 879BBB82170
        for <stable@vger.kernel.org>; Fri, 13 Jan 2023 15:45:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 201EEC433EF;
        Fri, 13 Jan 2023 15:45:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673624714;
        bh=3iOYHGiKv3k8lUJgWCEysilG5M+el9pjpx/HSQzCFOM=;
        h=Subject:To:Cc:From:Date:From;
        b=TR4dL8qcv4mTV6Oa8kG6/AxDOHRs60eoZE90MjDRTMBziapVzcGA9BgVIH6BM1RqO
         qsIeEpLwt1n3xChVnuvWhk3iiTRTUJBC05UMD+5AXEyA+E8oDiIdUwIE97WH7fxDbG
         anoKcSHhOQjCVLOZpUYyk7wfx8SzC44/2s7cHRgk=
Subject: FAILED: patch "[PATCH] Revert "ALSA: usb-audio: Drop superfluous interface setup at" failed to apply to 6.1-stable tree
To:     tiwai@suse.de, michael@ralston.id.au, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 13 Jan 2023 16:45:03 +0100
Message-ID: <167362470314207@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 6.1-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

16f1f838442d ("Revert "ALSA: usb-audio: Drop superfluous interface setup at parsing"")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 16f1f838442dc6430d32d51ddda347b8421ec34b Mon Sep 17 00:00:00 2001
From: Takashi Iwai <tiwai@suse.de>
Date: Wed, 4 Jan 2023 16:09:44 +0100
Subject: [PATCH] Revert "ALSA: usb-audio: Drop superfluous interface setup at
 parsing"

This reverts commit ac5e2fb425e1121ceef2b9d1b3ffccc195d55707.

The commit caused a regression on Behringer UMC404HD (and likely
others).  As the change was meant only as a minor optimization, it's
better to revert it to address the regression.

Reported-and-tested-by: Michael Ralston <michael@ralston.id.au>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/CAC2975JXkS1A5Tj9b02G_sy25ZWN-ys+tc9wmkoS=qPgKCogSg@mail.gmail.com
Link: https://lore.kernel.org/r/20230104150944.24918-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>

diff --git a/sound/usb/stream.c b/sound/usb/stream.c
index f75601ca2d52..f10f4e6d3fb8 100644
--- a/sound/usb/stream.c
+++ b/sound/usb/stream.c
@@ -1222,6 +1222,12 @@ static int __snd_usb_parse_audio_interface(struct snd_usb_audio *chip,
 			if (err < 0)
 				return err;
 		}
+
+		/* try to set the interface... */
+		usb_set_interface(chip->dev, iface_no, 0);
+		snd_usb_init_pitch(chip, fp);
+		snd_usb_init_sample_rate(chip, fp, fp->rate_max);
+		usb_set_interface(chip->dev, iface_no, altno);
 	}
 	return 0;
 }

