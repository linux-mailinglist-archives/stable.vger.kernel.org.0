Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3FC3459A0CC
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 18:34:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350195AbiHSPrD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 11:47:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350135AbiHSPqe (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 11:46:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2201429803;
        Fri, 19 Aug 2022 08:46:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9D00D615E9;
        Fri, 19 Aug 2022 15:46:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5D88C433C1;
        Fri, 19 Aug 2022 15:46:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660923987;
        bh=bIhvwJ0cO3l3RJdTOuGmzssh9wbYGfWA10vvMIuUm+o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SBa9GDrV8qhqaHFIcXu1R4CTDAyAf7rResmY0T5Jvn7NbwwMy84Q3T3BZyE9UazpM
         cKMQh8KLitI6V5DdM2eI5EdKZjni1DvtCNhEXzaWq7g8eVJlKr4kdyKTNbGO8I+SzR
         GgpSfnEJT1vf07CQEek1oqASv1q8rtbZSbzyPDoQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zheyu Ma <zheyuma97@gmail.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.10 005/545] ALSA: bcd2000: Fix a UAF bug on the error path of probing
Date:   Fri, 19 Aug 2022 17:36:15 +0200
Message-Id: <20220819153829.408974468@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220819153829.135562864@linuxfoundation.org>
References: <20220819153829.135562864@linuxfoundation.org>
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
@@ -348,7 +348,8 @@ static int bcd2000_init_midi(struct bcd2
 static void bcd2000_free_usb_related_resources(struct bcd2000 *bcd2k,
 						struct usb_interface *interface)
 {
-	/* usb_kill_urb not necessary, urb is aborted automatically */
+	usb_kill_urb(bcd2k->midi_out_urb);
+	usb_kill_urb(bcd2k->midi_in_urb);
 
 	usb_free_urb(bcd2k->midi_out_urb);
 	usb_free_urb(bcd2k->midi_in_urb);


