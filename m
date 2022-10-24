Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01B0760A7FA
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 15:00:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234882AbiJXNAe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 09:00:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235011AbiJXM7I (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 08:59:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5515B9A9D0;
        Mon, 24 Oct 2022 05:18:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3476461336;
        Mon, 24 Oct 2022 12:16:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A850C433C1;
        Mon, 24 Oct 2022 12:16:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666613794;
        bh=Lo+CknCpFzfV4+jmHuHa+7rRUKqZ5GoheRpToAyZR2Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QBs+AQLe2eSR3JQ7gUySDUeUqrhQb7LiKoeOBl1x/Uvh7PV6OmFuAw7eVkfaYbxam
         KS7ks/uk/AC+oKMgr2vRyZVX11PZmw115opUQYUvm3sdS35bLxQV0JOAIADaO9JZNW
         zUqPGADv+9neSWp+uhq1zGlXn0b0HhCa1PaslT9s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Sabri N. Ferreiro" <snferreiro1@gmail.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.10 004/390] ALSA: usb-audio: Fix NULL dererence at error path
Date:   Mon, 24 Oct 2022 13:26:41 +0200
Message-Id: <20221024113022.716441526@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113022.510008560@linuxfoundation.org>
References: <20221024113022.510008560@linuxfoundation.org>
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

commit 568be8aaf8a535f79c4db76cabe17b035aa2584d upstream.

At an error path to release URB buffers and contexts, the driver might
hit a NULL dererence for u->urb pointer, when u->buffer_size has been
already set but the actual URB allocation failed.

Fix it by adding the NULL check of urb.  Also, make sure that
buffer_size is cleared after the error path or the close.

Cc: <stable@vger.kernel.org>
Reported-by: Sabri N. Ferreiro <snferreiro1@gmail.com>
Link: https://lore.kernel.org/r/CAKG+3NRjTey+fFfUEGwuxL-pi_=T4cUskYG9OzpzHytF+tzYng@mail.gmail.com
Link: https://lore.kernel.org/r/20220930100129.19445-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/endpoint.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/sound/usb/endpoint.c
+++ b/sound/usb/endpoint.c
@@ -73,12 +73,13 @@ static inline unsigned get_usb_high_spee
  */
 static void release_urb_ctx(struct snd_urb_ctx *u)
 {
-	if (u->buffer_size)
+	if (u->urb && u->buffer_size)
 		usb_free_coherent(u->ep->chip->dev, u->buffer_size,
 				  u->urb->transfer_buffer,
 				  u->urb->transfer_dma);
 	usb_free_urb(u->urb);
 	u->urb = NULL;
+	u->buffer_size = 0;
 }
 
 static const char *usb_error_string(int err)


