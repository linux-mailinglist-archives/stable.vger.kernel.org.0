Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 080405EA3C6
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 13:32:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235737AbiIZLct (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 07:32:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235547AbiIZLcC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 07:32:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B01D66CD08;
        Mon, 26 Sep 2022 03:42:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E15B2604F5;
        Mon, 26 Sep 2022 10:42:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6098C433D6;
        Mon, 26 Sep 2022 10:42:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664188961;
        bh=iJBO1ATwtmoS0joPIeWvUPq+w4pRFuon95cJw9vbeCc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vplQ2Bp2WPLzR7nlIf5u6xosjcEO/DtcURorY4WI/2RoQkN6iZCSdg/N8vflDdzeh
         sP762JTwpN92MflB+jasNypMspL9cIvG3sjHj7gGV9m4mgkhwMD52QcMEInRXOWZjQ
         jsqoBHIdtXOZCZTSZ1X4Lk60PqEl+sFC12xOOy2c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
        <ville.syrjala@linux.intel.com>, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.19 028/207] ALSA: hda: Fix hang at HD-audio codec unbinding due to refcount saturation
Date:   Mon, 26 Sep 2022 12:10:17 +0200
Message-Id: <20220926100807.747921742@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100806.522017616@linuxfoundation.org>
References: <20220926100806.522017616@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

commit ead3d3c5b54f76da79c079e61bacb4279ec56965 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/hda_bind.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/sound/pci/hda/hda_bind.c
+++ b/sound/pci/hda/hda_bind.c
@@ -157,10 +157,10 @@ static int hda_codec_driver_remove(struc
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


