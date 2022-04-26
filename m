Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6428650F4AD
	for <lists+stable@lfdr.de>; Tue, 26 Apr 2022 10:37:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345112AbiDZIgZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Apr 2022 04:36:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345404AbiDZIee (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Apr 2022 04:34:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4693975639;
        Tue, 26 Apr 2022 01:27:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3C9876183D;
        Tue, 26 Apr 2022 08:27:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49C24C385A0;
        Tue, 26 Apr 2022 08:27:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650961633;
        bh=VnNt+lQjQuyBewEAaSPyCFBNdDp09ubrmGiGR23S988=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=e8JfsNR5yNbjZnxZ6J3tQ1E4XVHtTdN1Nql2NW7jRcakuvRmoVsOk4x1+NL5AfLow
         gzPRgKlaGNcOi9tfUtN+XzghTUA9FpcBWJmWpVTFtiY0frpq1m6eUrJbwwAx9guW0+
         fS3QLCPS64p7+kF5ayGYlUft1FjF/aWUu2kenBGE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+70e777a39907d6d5fd0a@syzkaller.appspotmail.com,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 4.19 07/53] ALSA: usb-audio: Clear MIDI port active flag after draining
Date:   Tue, 26 Apr 2022 10:20:47 +0200
Message-Id: <20220426081735.871761625@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220426081735.651926456@linuxfoundation.org>
References: <20220426081735.651926456@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

commit 0665886ad1392e6b5bae85d7a6ccbed48dca1522 upstream.

When a rawmidi output stream is closed, it calls the drain at first,
then does trigger-off only when the drain returns -ERESTARTSYS as a
fallback.  It implies that each driver should turn off the stream
properly after the drain.  Meanwhile, USB-audio MIDI interface didn't
change the port->active flag after the drain.  This may leave the
output work picking up the port that is closed right now, which
eventually leads to a use-after-free for the already released rawmidi
object.

This patch fixes the bug by properly clearing the port->active flag
after the output drain.

Reported-by: syzbot+70e777a39907d6d5fd0a@syzkaller.appspotmail.com
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/00000000000011555605dceaff03@google.com
Link: https://lore.kernel.org/r/20220420130247.22062-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/midi.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/usb/midi.c
+++ b/sound/usb/midi.c
@@ -1211,6 +1211,7 @@ static void snd_usbmidi_output_drain(str
 		} while (drain_urbs && timeout);
 		finish_wait(&ep->drain_wait, &wait);
 	}
+	port->active = 0;
 	spin_unlock_irq(&ep->buffer_lock);
 }
 


