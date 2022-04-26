Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9922550F659
	for <lists+stable@lfdr.de>; Tue, 26 Apr 2022 10:55:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345767AbiDZIrc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Apr 2022 04:47:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346899AbiDZIp3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Apr 2022 04:45:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F93611C3D;
        Tue, 26 Apr 2022 01:36:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2C85E617E7;
        Tue, 26 Apr 2022 08:36:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27257C385AC;
        Tue, 26 Apr 2022 08:36:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650962186;
        bh=NVsQUUF/tJdoP9yIQoTGPFAQXLh4WYEGBYuFJEQX1SE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OrL9imO4aqcB3y8aNIZSDL4nxv4eP61jJusEIl6osKeQ1uuLBDK3tBt8LVYviTCK+
         0ePvMCmRJDinbAXnsiDHusjc5EN51tVREqjR5FHq7Yxgf0XXy7UQExsOb8EDAKd903
         MqvmpzSztLWCRdYbXD8Dpy2A91D2MYEmr5dhwjz8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+70e777a39907d6d5fd0a@syzkaller.appspotmail.com,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.15 015/124] ALSA: usb-audio: Clear MIDI port active flag after draining
Date:   Tue, 26 Apr 2022 10:20:16 +0200
Message-Id: <20220426081747.734351104@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220426081747.286685339@linuxfoundation.org>
References: <20220426081747.286685339@linuxfoundation.org>
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
@@ -1194,6 +1194,7 @@ static void snd_usbmidi_output_drain(str
 		} while (drain_urbs && timeout);
 		finish_wait(&ep->drain_wait, &wait);
 	}
+	port->active = 0;
 	spin_unlock_irq(&ep->buffer_lock);
 }
 


