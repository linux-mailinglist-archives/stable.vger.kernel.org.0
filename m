Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1152A5B6F6A
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 16:14:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232633AbiIMOME (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 10:12:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232552AbiIMOLL (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 10:11:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 799502633;
        Tue, 13 Sep 2022 07:09:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6BC3F61497;
        Tue, 13 Sep 2022 14:09:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F0F4C433C1;
        Tue, 13 Sep 2022 14:09:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663078175;
        bh=2fO2o5P2ABmYj7iKbwad+LWXB2gbHMrqtiibWdsxiGs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D6qhxJuRUJAg2RK1ft51wP872pPnzKH0zirbIq/qxeEhLKCIdXs/JjE1jGR2w4Flz
         8vkiWeWg1u/vAsJvYI8V4EUD2k3q9qUaHDtLJOx181iXQmhe0ThJTjzw1IT2xlrKxo
         rfQ706St0+kK9RUMT74P0rChiSetyzZOqUBQbepI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.19 040/192] ALSA: usb-audio: Clear fixed clock rate at closing EP
Date:   Tue, 13 Sep 2022 16:02:26 +0200
Message-Id: <20220913140411.917247568@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220913140410.043243217@linuxfoundation.org>
References: <20220913140410.043243217@linuxfoundation.org>
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

From: Takashi Iwai <tiwai@suse.de>

commit 809f44a0cc5ad4b1209467a6287f8ac0eb49d393 upstream.

The recent commit c11117b634f4 ("ALSA: usb-audio: Refcount multiple
accesses on the single clock") tries to manage the clock rate shared
by several endpoints.  This was intended for avoiding the unmatched
rate by a different endpoint, but unfortunately, it introduced a
regression for PulseAudio and pipewire, too; those applications try to
probe the multiple possible rates (44.1k and 48kHz) and setting up the
normal rate fails but only the last rate is applied.

The cause is that the last sample rate is still left to the clock
reference even after closing the endpoint, and this value is still
used at the next open.  It happens only when applications set up via
PCM prepare but don't start/stop the stream; the rate is reset when
the stream is stopped, but it's not cleared at close.

This patch addresses the issue above, simply by clearing the rate set
in the clock reference at the last close of each endpoint.

Fixes: c11117b634f4 ("ALSA: usb-audio: Refcount multiple accesses on the single clock")
Reported-by: Jason A. Donenfeld <Jason@zx2c4.com>
Tested-by: Jason A. Donenfeld <Jason@zx2c4.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/all/YxXIWv8dYmg1tnXP@zx2c4.com/
Link: https://gitlab.freedesktop.org/pipewire/pipewire/-/issues/2620
Link: https://lore.kernel.org/r/20220907100421.6443-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/endpoint.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/sound/usb/endpoint.c
+++ b/sound/usb/endpoint.c
@@ -925,6 +925,8 @@ void snd_usb_endpoint_close(struct snd_u
 		endpoint_set_interface(chip, ep, false);
 
 	if (!--ep->opened) {
+		if (ep->clock_ref && !atomic_read(&ep->clock_ref->locked))
+			ep->clock_ref->rate = 0;
 		ep->iface = 0;
 		ep->altsetting = 0;
 		ep->cur_audiofmt = NULL;


