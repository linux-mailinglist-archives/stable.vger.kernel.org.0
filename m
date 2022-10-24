Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5B3560A2C9
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 13:47:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231487AbiJXLr6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 07:47:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231650AbiJXLqy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 07:46:54 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1966617589;
        Mon, 24 Oct 2022 04:42:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id DA0EACE1320;
        Mon, 24 Oct 2022 11:40:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59B2EC433D6;
        Mon, 24 Oct 2022 11:40:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666611604;
        bh=xAr3HtSz1TJSquIEdH3BGLK5XHEZT5yJ3V/u+aRLDLo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cNC3DlgLTIawPyP/XKzq7Wcw8f5KvqkAP2A2c4DFRAQcKvIpb0LoyeLi2Wj6OTTeV
         yKLaDdJweg6GgY3WxnMTLFepvLppgVpT0Pv6X6ZdtisGSOtoF4wCxFeT4rfsY8mrIL
         WEu4FYCkRF4fQFb1wfCnZuvCVEWlzd/4PDzAYbjs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 4.9 041/159] ALSA: oss: Fix potential deadlock at unregistration
Date:   Mon, 24 Oct 2022 13:29:55 +0200
Message-Id: <20221024112950.885292336@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024112949.358278806@linuxfoundation.org>
References: <20221024112949.358278806@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

commit 97d917879d7f92df09c3f21fd54609a8bcd654b2 upstream.

We took sound_oss_mutex around the calls of unregister_sound_special()
at unregistering OSS devices.  This may, however, lead to a deadlock,
because we manage the card release via the card's device object, and
the release may happen at unregister_sound_special() call -- which
will take sound_oss_mutex again in turn.

Although the deadlock might be fixed by relaxing the rawmidi mutex in
the previous commit, it's safer to move unregister_sound_special()
calls themselves out of the sound_oss_mutex, too.  The call is
race-safe as the function has a spinlock protection by itself.

Link: https://lore.kernel.org/r/CAB7eexJP7w1B0mVgDF0dQ+gWor7UdkiwPczmL7pn91xx8xpzOA@mail.gmail.com
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20221011070147.7611-2-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/core/sound_oss.c |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

--- a/sound/core/sound_oss.c
+++ b/sound/core/sound_oss.c
@@ -179,7 +179,6 @@ int snd_unregister_oss_device(int type,
 		mutex_unlock(&sound_oss_mutex);
 		return -ENOENT;
 	}
-	unregister_sound_special(minor);
 	switch (SNDRV_MINOR_OSS_DEVICE(minor)) {
 	case SNDRV_MINOR_OSS_PCM:
 		track2 = SNDRV_MINOR_OSS(cidx, SNDRV_MINOR_OSS_AUDIO);
@@ -191,12 +190,18 @@ int snd_unregister_oss_device(int type,
 		track2 = SNDRV_MINOR_OSS(cidx, SNDRV_MINOR_OSS_DMMIDI1);
 		break;
 	}
-	if (track2 >= 0) {
-		unregister_sound_special(track2);
+	if (track2 >= 0)
 		snd_oss_minors[track2] = NULL;
-	}
 	snd_oss_minors[minor] = NULL;
 	mutex_unlock(&sound_oss_mutex);
+
+	/* call unregister_sound_special() outside sound_oss_mutex;
+	 * otherwise may deadlock, as it can trigger the release of a card
+	 */
+	unregister_sound_special(minor);
+	if (track2 >= 0)
+		unregister_sound_special(track2);
+
 	kfree(mptr);
 	return 0;
 }


