Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D4C3635894
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 11:01:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237005AbiKWKBJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 05:01:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237015AbiKWKAc (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 05:00:32 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EE786EB68
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:52:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2202961B96
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:52:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01B62C433D6;
        Wed, 23 Nov 2022 09:52:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669197178;
        bh=Qts2eUS7impzPN8SqLPQq4uQlEHeRqTDJWcTql6E7Qs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TpVLy2zMCzJ1+OIyExs5U+XD+Sh3F2nmqdBrGt+p5XvaO7XPan6HQj38mcdriNlvD
         nFxJwALMO/3IhTeGlCq1SmYTeKrgMCqYayndNqv51qI49g4KBa/ZMUAO9QNcapFF1W
         KPi7+5iCzFiGaoVl9W7CUDOas6tN0mpjXrYajQjc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        syzbot+9abda841d636d86c41da@syzkaller.appspotmail.com,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.0 221/314] ALSA: usb-audio: Drop snd_BUG_ON() from snd_usbmidi_output_open()
Date:   Wed, 23 Nov 2022 09:51:06 +0100
Message-Id: <20221123084635.558923451@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084625.457073469@linuxfoundation.org>
References: <20221123084625.457073469@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

commit ad72c3c3f6eb81d2cb189ec71e888316adada5df upstream.

snd_usbmidi_output_open() has a check of the NULL port with
snd_BUG_ON().  snd_BUG_ON() was used as this shouldn't have happened,
but in reality, the NULL port may be seen when the device gives an
invalid endpoint setup at the descriptor, hence the driver skips the
allocation.  That is, the check itself is valid and snd_BUG_ON()
should be dropped from there.  Otherwise it's confusing as if it were
a real bug, as recently syzbot stumbled on it.

Reported-by: syzbot+9abda841d636d86c41da@syzkaller.appspotmail.com
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/syzbot+9abda841d636d86c41da@syzkaller.appspotmail.com
Link: https://lore.kernel.org/r/20221112141223.6144-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/midi.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/sound/usb/midi.c
+++ b/sound/usb/midi.c
@@ -1133,10 +1133,8 @@ static int snd_usbmidi_output_open(struc
 					port = &umidi->endpoints[i].out->ports[j];
 					break;
 				}
-	if (!port) {
-		snd_BUG();
+	if (!port)
 		return -ENXIO;
-	}
 
 	substream->runtime->private_data = port;
 	port->state = STATE_UNKNOWN;


