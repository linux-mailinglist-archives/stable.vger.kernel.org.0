Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA7ED608C83
	for <lists+stable@lfdr.de>; Sat, 22 Oct 2022 13:22:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230270AbiJVLWF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Oct 2022 07:22:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230286AbiJVLVo (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Oct 2022 07:21:44 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94245238244;
        Sat, 22 Oct 2022 03:50:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id F1198CE2CA3;
        Sat, 22 Oct 2022 07:50:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10EE1C433D6;
        Sat, 22 Oct 2022 07:50:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666425023;
        bh=mVlXKDyloWHczG4w8BODEuzPi+MoNX5tHp/3T8IM120=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sh0bSzyHHMKUv5eCZ6JbbRarLP+IbqlW73NGf8cvWSG4pY2XyhCZgPEt5x32l8xuq
         +1zajEQn9VOqCiPXRDpyRTwo9LhLR+ijuNIWp952EVwiGhgbgFDRx/GEpO7Uh3dCM/
         NzBQyirJoVLHkwe/pZ1m2IbFdoEQsHMA8R7MjI24=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 333/717] ALSA: usb-audio: Properly refcounting clock rate
Date:   Sat, 22 Oct 2022 09:23:32 +0200
Message-Id: <20221022072509.781401249@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221022072415.034382448@linuxfoundation.org>
References: <20221022072415.034382448@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 9a737e7f8b371e97eb649904276407cee2c9cf30 ]

We fixed the bug introduced by the patch for managing the shared
clocks at the commit 809f44a0cc5a ("ALSA: usb-audio: Clear fixed clock
rate at closing EP"), but it was merely a workaround.  By this change,
the clock reference rate is cleared at each EP close, hence the still
remaining EP may need a re-setup of rate unnecessarily.

This patch introduces the proper refcounting for the clock reference
object so that the clock setup is done only when needed.

Fixes: 809f44a0cc5a ("ALSA: usb-audio: Clear fixed clock rate at closing EP")
Fixes: c11117b634f4 ("ALSA: usb-audio: Refcount multiple accesses on the single clock")
Link: https://lore.kernel.org/r/20220920181126.4912-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/endpoint.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

--- a/sound/usb/endpoint.c
+++ b/sound/usb/endpoint.c
@@ -39,6 +39,7 @@ struct snd_usb_iface_ref {
 struct snd_usb_clock_ref {
 	unsigned char clock;
 	atomic_t locked;
+	int opened;
 	int rate;
 	struct list_head list;
 };
@@ -802,6 +803,7 @@ snd_usb_endpoint_open(struct snd_usb_aud
 				ep = NULL;
 				goto unlock;
 			}
+			ep->clock_ref->opened++;
 		}
 
 		ep->cur_audiofmt = fp;
@@ -925,8 +927,10 @@ void snd_usb_endpoint_close(struct snd_u
 		endpoint_set_interface(chip, ep, false);
 
 	if (!--ep->opened) {
-		if (ep->clock_ref && !atomic_read(&ep->clock_ref->locked))
-			ep->clock_ref->rate = 0;
+		if (ep->clock_ref) {
+			if (!--ep->clock_ref->opened)
+				ep->clock_ref->rate = 0;
+		}
 		ep->iface = 0;
 		ep->altsetting = 0;
 		ep->cur_audiofmt = NULL;
@@ -1633,8 +1637,7 @@ void snd_usb_endpoint_stop(struct snd_us
 			WRITE_ONCE(ep->sync_source->sync_sink, NULL);
 		stop_urbs(ep, false, keep_pending);
 		if (ep->clock_ref)
-			if (!atomic_dec_return(&ep->clock_ref->locked))
-				ep->clock_ref->rate = 0;
+			atomic_dec(&ep->clock_ref->locked);
 	}
 }
 


