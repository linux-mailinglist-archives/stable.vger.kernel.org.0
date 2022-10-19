Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE1B3603BCF
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 10:39:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230224AbiJSIjt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 04:39:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229971AbiJSIjD (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 04:39:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A62787F0B1;
        Wed, 19 Oct 2022 01:38:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D481E617DF;
        Wed, 19 Oct 2022 08:38:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0186C433D7;
        Wed, 19 Oct 2022 08:38:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666168713;
        bh=nqOrFT/Y66TGULVPHHQkkVqwTkFRjIX6uhUPep+lG1U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=elwc1a/Qav0Bmc5YpjsPcpseSSsUR6H7omx5rMuLpRarq1jvseELMvXyJNJjVWVz/
         qkggq1G2jSWkzGWLmgmB4gq+x3g5p0moDNQOKFYt03HgwVx8eYY5T8G6kYI4O7RN8s
         Si0ei6z1E8ycp0o3R8W4iTXgazL3gnIzd9jRK+YM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Sabri N. Ferreiro" <snferreiro1@gmail.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.0 004/862] ALSA: usb-audio: Fix NULL dererence at error path
Date:   Wed, 19 Oct 2022 10:21:31 +0200
Message-Id: <20221019083250.187859993@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
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
@@ -93,12 +93,13 @@ static inline unsigned get_usb_high_spee
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


