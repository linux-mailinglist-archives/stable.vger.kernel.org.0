Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 204B960A2D3
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 13:48:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231560AbiJXLsU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 07:48:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231558AbiJXLrc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 07:47:32 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 577067647F;
        Mon, 24 Oct 2022 04:42:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id AE05BCE1333;
        Mon, 24 Oct 2022 11:40:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1B71C433C1;
        Mon, 24 Oct 2022 11:40:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666611610;
        bh=qQlgW8kTrMb8YUt5Euhjz1KQWPFftvE0dgmxeMxKkyY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=liEUVottFODe2HBmt/BpzlAIQ1vx8HFp0Lc1K7JlN4EJjHAf44JIJ7UBEinkhITlG
         WPfOzjc8nEqwxDnwUjznmi+4HX5dKysWzFcKLsYB4NrNHNgMhRF30JT7dHVNCaAXzh
         RYHVuobnEI5nPpQyz5kAEcxTsJjtLZVHtGWzAiKI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 4.9 043/159] ALSA: usb-audio: Fix potential memory leaks
Date:   Mon, 24 Oct 2022 13:29:57 +0200
Message-Id: <20221024112950.959546360@linuxfoundation.org>
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

commit 6382da0828995af87aa8b8bef28cc61aceb4aff3 upstream.

When the driver hits -ENOMEM at allocating a URB or a buffer, it
aborts and goes to the error path that releases the all previously
allocated resources.  However, when -ENOMEM hits at the middle of the
sync EP URB allocation loop, the partially allocated URBs might be
left without released, because ep->nurbs is still zero at that point.

Fix it by setting ep->nurbs at first, so that the error handler loops
over the full URB list.

Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20220930100151.19461-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/endpoint.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/sound/usb/endpoint.c
+++ b/sound/usb/endpoint.c
@@ -804,6 +804,7 @@ static int sync_ep_set_params(struct snd
 	if (!ep->syncbuf)
 		return -ENOMEM;
 
+	ep->nurbs = SYNC_URBS;
 	for (i = 0; i < SYNC_URBS; i++) {
 		struct snd_urb_ctx *u = &ep->urb[i];
 		u->index = i;
@@ -823,8 +824,6 @@ static int sync_ep_set_params(struct snd
 		u->urb->complete = snd_complete_urb;
 	}
 
-	ep->nurbs = SYNC_URBS;
-
 	return 0;
 
 out_of_memory:


