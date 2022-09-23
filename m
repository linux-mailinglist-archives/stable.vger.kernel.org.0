Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C89C5E80C4
	for <lists+stable@lfdr.de>; Fri, 23 Sep 2022 19:33:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231379AbiIWRdc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 23 Sep 2022 13:33:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231777AbiIWRdV (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 23 Sep 2022 13:33:21 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2155214D305
        for <stable@vger.kernel.org>; Fri, 23 Sep 2022 10:33:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 87F29CE2486
        for <stable@vger.kernel.org>; Fri, 23 Sep 2022 17:33:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B2C6C433C1;
        Fri, 23 Sep 2022 17:33:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663954396;
        bh=g40hGak7ZwI9N6m2ZBCaOQnFqW+y+62qlaRJnkV17Rk=;
        h=Subject:To:Cc:From:Date:From;
        b=vLcMnM/Nx8W0FSdsc7mpyOvboW/i4Cnepb2xBSQ3vl10aA5kOQjYrmdWbDOa/g+lq
         +2psTr2WfgRqgGvATsanoQ2KSbNH+F4tzv9bpSqIsPzQDPDRYbATfyhK/TqFq6ofo4
         AiydUkn35QNFPGUJIhFhtHHEAkNYSjEcAgr4Wr8o=
Subject: FAILED: patch "[PATCH] ALSA: hda: Fix hang at HD-audio codec unbinding due to" failed to apply to 5.15-stable tree
To:     tiwai@suse.de, stable@vger.kernel.org,
        ville.syrjala@linux.intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 23 Sep 2022 19:33:14 +0200
Message-ID: <166395439470255@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

ead3d3c5b54f ("ALSA: hda: Fix hang at HD-audio codec unbinding due to refcount saturation")
37c4fd0db7c9 ("ALSA: hda: Do disconnect jacks at codec unbind")
7206998f578d ("ALSA: hda: Fix potential deadlock at codec unbinding")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From ead3d3c5b54f76da79c079e61bacb4279ec56965 Mon Sep 17 00:00:00 2001
From: Takashi Iwai <tiwai@suse.de>
Date: Sat, 10 Sep 2022 16:25:50 +0200
Subject: [PATCH] ALSA: hda: Fix hang at HD-audio codec unbinding due to
 refcount saturation
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

We fixed the potential deadlock at dynamic unbinding the HD-audio
codec at the commit 7206998f578d ("ALSA: hda: Fix potential deadlock
at codec unbinding"), but ironically, this caused another potential
deadlock.  The current code uses refcount_dec() and waits for the
pending task with wait_event for dropping the refcount to 0.  This
works fine when PCMs are assigned and actually waiting for the
refcount drop.

Meanwhile, when there was no PCM assigned, the refcount_dec() call
itself was supposed to drop to zero -- alas, it doesn't in reality;
refcount_dec() complains, spews kernel warning and it saturates
instead of dropping to 0, due to the nature of refcount_dec()
implementation.  This eventually blocks the wait_event() wakeup and
the code get stuck there.

For avoiding the problem, we call refcount_dec_and_test() and skips
the sync-wait if it already reaches to zero.

The patch does a slight code reshuffling to make sure to invoke other
disconnect calls before the sync-wait, too.

Fixes: 7206998f578d ("ALSA: hda: Fix potential deadlock at codec unbinding")
Reported-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Tested-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/YxtflWQnslMHVlU7@intel.com
Link: https://lore.kernel.org/r/20220910142550.28494-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>

diff --git a/sound/pci/hda/hda_bind.c b/sound/pci/hda/hda_bind.c
index cae9a975cbcc..1a868dd9dc4b 100644
--- a/sound/pci/hda/hda_bind.c
+++ b/sound/pci/hda/hda_bind.c
@@ -157,10 +157,10 @@ static int hda_codec_driver_remove(struct device *dev)
 		return codec->bus->core.ext_ops->hdev_detach(&codec->core);
 	}
 
-	refcount_dec(&codec->pcm_ref);
 	snd_hda_codec_disconnect_pcms(codec);
 	snd_hda_jack_tbl_disconnect(codec);
-	wait_event(codec->remove_sleep, !refcount_read(&codec->pcm_ref));
+	if (!refcount_dec_and_test(&codec->pcm_ref))
+		wait_event(codec->remove_sleep, !refcount_read(&codec->pcm_ref));
 	snd_power_sync_ref(codec->bus->card);
 
 	if (codec->patch_ops.free)

