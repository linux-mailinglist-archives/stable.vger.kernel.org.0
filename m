Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF3F663544D
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 10:05:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236997AbiKWJCs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 04:02:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236987AbiKWJCk (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 04:02:40 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3932128718
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:02:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CAA61B81EEC
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:02:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D243C433C1;
        Wed, 23 Nov 2022 09:02:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669194156;
        bh=v+rcOIAi86dmxDnAA+LxYWuevQXRR4pMmZ2C1W5rqxY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vQiZm0alQQthhJBB6Mx6Ob2xYynMGO/svB/SmrYXyCxVP0+3cyymZtddTgGhXhtEG
         ZZi5xst1Vpq3EpS/NUl42qediVkdUijc3idK6kJ+pIJs33x1QXpRzAVNs++WFFsgmD
         qe8lQy+l+K2wKKCPgkEe0sxx2vGj0pLMPt7EF8e8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        syzbot+9abda841d636d86c41da@syzkaller.appspotmail.com,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 4.14 57/88] ALSA: usb-audio: Drop snd_BUG_ON() from snd_usbmidi_output_open()
Date:   Wed, 23 Nov 2022 09:50:54 +0100
Message-Id: <20221123084550.534375203@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084548.535439312@linuxfoundation.org>
References: <20221123084548.535439312@linuxfoundation.org>
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
@@ -1148,10 +1148,8 @@ static int snd_usbmidi_output_open(struc
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


