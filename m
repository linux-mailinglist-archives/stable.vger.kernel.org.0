Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2BFF635549
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 10:18:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237377AbiKWJRZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 04:17:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237431AbiKWJQ4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 04:16:56 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49BBA107E50
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:16:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DD09961B4C
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:16:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBB28C433D6;
        Wed, 23 Nov 2022 09:16:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669194987;
        bh=0EYjDFr7xoTV+UFs7GGOGr0QDiqFY7bNb4GAVBRtLdE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Qh3QyIID3GORr5H6WTooJv20eBRXsJ8XJ0dZc5yLfRnSZ/wMx2WQNKgpo66vqiNIu
         xTuOfpRI7AbBWzO+kFqefi3sziVXAmWMxFvtaUa5oIJQRYDetTP3nwE6BdxEVOVvUw
         ZS7iqIqfyycbOju8CRqydcDz0mgoke79/lct7S90=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        syzbot+9abda841d636d86c41da@syzkaller.appspotmail.com,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.4 115/156] ALSA: usb-audio: Drop snd_BUG_ON() from snd_usbmidi_output_open()
Date:   Wed, 23 Nov 2022 09:51:12 +0100
Message-Id: <20221123084602.105325784@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084557.816085212@linuxfoundation.org>
References: <20221123084557.816085212@linuxfoundation.org>
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
@@ -1149,10 +1149,8 @@ static int snd_usbmidi_output_open(struc
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


