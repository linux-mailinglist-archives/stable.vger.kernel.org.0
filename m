Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2DBB615AAD
	for <lists+stable@lfdr.de>; Wed,  2 Nov 2022 04:38:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229650AbiKBDiq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 23:38:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230155AbiKBDin (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 23:38:43 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C03FFCF
        for <stable@vger.kernel.org>; Tue,  1 Nov 2022 20:38:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E2978B8205C
        for <stable@vger.kernel.org>; Wed,  2 Nov 2022 03:38:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C054BC433D6;
        Wed,  2 Nov 2022 03:38:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667360315;
        bh=zBfkaFvI5JWSbghU23CyT0em6cHrhP1RFQ2l0rr1BXw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a4VX09R6UOXdk3wwFALGt8feUR2SdKBHSuj1zQjNVQwGuHZaAxMmPaJYmzOc+mDMr
         2yDTOD0yQbEElB3VIsPseLJUjl4PvegEuHuNu7RFgY4K8xuVmFV++t46gFcleDq+J5
         zZVQv7RKl6v4LLVZwGJLIC4PxtmmrEcxfSuLqW7A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 4.14 17/60] ALSA: Use del_timer_sync() before freeing timer
Date:   Wed,  2 Nov 2022 03:34:38 +0100
Message-Id: <20221102022051.637549748@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022051.081761052@linuxfoundation.org>
References: <20221102022051.081761052@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Steven Rostedt (Google) <rostedt@goodmis.org>

commit f0a868788fcbf63cdab51f5adcf73b271ede8164 upstream.

The current code for freeing the emux timer is extremely dangerous:

  CPU0				CPU1
  ----				----
snd_emux_timer_callback()
			    snd_emux_free()
			      spin_lock(&emu->voice_lock)
			      del_timer(&emu->tlist); <-- returns immediately
			      spin_unlock(&emu->voice_lock);
			      [..]
			      kfree(emu);

  spin_lock(&emu->voice_lock);

 [BOOM!]

Instead just use del_timer_sync() which will wait for the timer to finish
before continuing. No need to check if the timer is active or not when
doing so.

This doesn't fix the race of a possible re-arming of the timer, but at
least it won't use the data that has just been freed.

[ Fixed unused variable warning by tiwai ]

Cc: stable@vger.kernel.org
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Link: https://lore.kernel.org/r/20221026231236.6834b551@gandalf.local.home
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/synth/emux/emux.c |    7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

--- a/sound/synth/emux/emux.c
+++ b/sound/synth/emux/emux.c
@@ -138,15 +138,10 @@ EXPORT_SYMBOL(snd_emux_register);
  */
 int snd_emux_free(struct snd_emux *emu)
 {
-	unsigned long flags;
-
 	if (! emu)
 		return -EINVAL;
 
-	spin_lock_irqsave(&emu->voice_lock, flags);
-	if (emu->timer_active)
-		del_timer(&emu->tlist);
-	spin_unlock_irqrestore(&emu->voice_lock, flags);
+	del_timer_sync(&emu->tlist);
 
 	snd_emux_proc_free(emu);
 	snd_emux_delete_virmidi(emu);


