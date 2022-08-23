Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 229FA59D83E
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 12:03:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349666AbiHWJ1j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 05:27:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351110AbiHWJ0l (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 05:26:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A266910B0;
        Tue, 23 Aug 2022 01:37:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7507B6152E;
        Tue, 23 Aug 2022 08:36:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 822DEC433D6;
        Tue, 23 Aug 2022 08:36:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661243766;
        bh=XnKHTAqr4cw2+DZhxkmwjc8pnDzf654pxG/zleJA8kA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PeVzG1S4mV3C5B+k0tyJGMXAu8ohzQ20k8+lMWUs5PyLyyun9NDO7r3pC6Q+GMrvz
         f7G0jLI0gGVMZqBpzn4vnvXn0pdHXgYackmjoZunJvq1CYGZX2bZA16lYcTOQum2dr
         rnF8V4TYrt6NmTY3acs9+rOw4vNo2RRcKokOGjPQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zheyu Ma <zheyuma97@gmail.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 4.14 015/229] ALSA: bcd2000: Fix a UAF bug on the error path of probing
Date:   Tue, 23 Aug 2022 10:22:56 +0200
Message-Id: <20220823080053.954612763@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080053.202747790@linuxfoundation.org>
References: <20220823080053.202747790@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zheyu Ma <zheyuma97@gmail.com>

commit ffb2759df7efbc00187bfd9d1072434a13a54139 upstream.

When the driver fails in snd_card_register() at probe time, it will free
the 'bcd2k->midi_out_urb' before killing it, which may cause a UAF bug.

The following log can reveal it:

[   50.727020] BUG: KASAN: use-after-free in bcd2000_input_complete+0x1f1/0x2e0 [snd_bcd2000]
[   50.727623] Read of size 8 at addr ffff88810fab0e88 by task swapper/4/0
[   50.729530] Call Trace:
[   50.732899]  bcd2000_input_complete+0x1f1/0x2e0 [snd_bcd2000]

Fix this by adding usb_kill_urb() before usb_free_urb().

Fixes: b47a22290d58 ("ALSA: MIDI driver for Behringer BCD2000 USB device")
Signed-off-by: Zheyu Ma <zheyuma97@gmail.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20220715010515.2087925-1-zheyuma97@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/bcd2000/bcd2000.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/sound/usb/bcd2000/bcd2000.c
+++ b/sound/usb/bcd2000/bcd2000.c
@@ -357,7 +357,8 @@ static int bcd2000_init_midi(struct bcd2
 static void bcd2000_free_usb_related_resources(struct bcd2000 *bcd2k,
 						struct usb_interface *interface)
 {
-	/* usb_kill_urb not necessary, urb is aborted automatically */
+	usb_kill_urb(bcd2k->midi_out_urb);
+	usb_kill_urb(bcd2k->midi_in_urb);
 
 	usb_free_urb(bcd2k->midi_out_urb);
 	usb_free_urb(bcd2k->midi_in_urb);


