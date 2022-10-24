Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 190AC60AD88
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 16:26:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237008AbiJXO0S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 10:26:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237299AbiJXOZO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 10:25:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF18C4F1BE;
        Mon, 24 Oct 2022 06:00:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 211236128E;
        Mon, 24 Oct 2022 12:34:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 336BBC433C1;
        Mon, 24 Oct 2022 12:34:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666614864;
        bh=98st+zJYV1mt2StBL3pi+a2UWeh+NUxSEpmbxmiw7+U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vtSVRB3YJ8VrzGXy9aqtIvBMOK9D4FkU6Wn4bGfDLfeWN1laSZHktAiRv5z0kMQ+p
         uMndo88/vqMM+M5z88gh55VXUgF1/08DOa5JwBvI+Brofcbh4/NROJkfllwHzS9X/c
         Hbc6a/fwP2cL8VbUd26H7EFt4WCLdXXJvaxm0dAc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Sabri N. Ferreiro" <snferreiro1@gmail.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.15 005/530] ALSA: usb-audio: Fix NULL dererence at error path
Date:   Mon, 24 Oct 2022 13:25:49 +0200
Message-Id: <20221024113045.229074101@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113044.976326639@linuxfoundation.org>
References: <20221024113044.976326639@linuxfoundation.org>
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
@@ -85,12 +85,13 @@ static inline unsigned get_usb_high_spee
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


