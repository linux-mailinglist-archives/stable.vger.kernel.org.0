Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BDCBB5F29B8
	for <lists+stable@lfdr.de>; Mon,  3 Oct 2022 09:24:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230224AbiJCHYc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Oct 2022 03:24:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230171AbiJCHXc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Oct 2022 03:23:32 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CD5B3ED51;
        Mon,  3 Oct 2022 00:17:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 808F0B80E7F;
        Mon,  3 Oct 2022 07:17:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F059DC43147;
        Mon,  3 Oct 2022 07:17:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664781437;
        bh=0oBSQwek0f/Ils927xvIAnBi6N7atps5OofrV7L2/jw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XgGLsTzwzkNusdtSDgRxE2hji7ell4/b3efIzTQNKtIbLSVjkn2owgoT4lvsvDt2/
         EHmTnux4jVaZHizT6trXtvDOUvdj/qmfllIzy2TXKMdXPQGbGR66iZrnGKAdYAvzE1
         PBWbxQdefemok6WQAxnSSBLmxqnRWTn+h6AwtnYo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
        <ville.syrjala@linux.intel.com>, Takashi Iwai <tiwai@suse.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 02/83] ALSA: hda: Fix hang at HD-audio codec unbinding due to refcount saturation
Date:   Mon,  3 Oct 2022 09:10:27 +0200
Message-Id: <20221003070722.038362006@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221003070721.971297651@linuxfoundation.org>
References: <20221003070721.971297651@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit ead3d3c5b54f76da79c079e61bacb4279ec56965 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/hda_bind.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/pci/hda/hda_bind.c b/sound/pci/hda/hda_bind.c
index c572fb5886d5..7af251573595 100644
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
-- 
2.35.1



