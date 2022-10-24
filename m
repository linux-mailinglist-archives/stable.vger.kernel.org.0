Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D76460A57E
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 14:25:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233487AbiJXMYz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 08:24:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233836AbiJXMYZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 08:24:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C79842D4E;
        Mon, 24 Oct 2022 05:00:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B13B2612BE;
        Mon, 24 Oct 2022 11:47:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5EF2C433C1;
        Mon, 24 Oct 2022 11:47:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666612054;
        bh=KJ2cmYkVYWZemHCOGauIePDWAFHhV8/OUEmdQkb57Tg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wcIvQc3KZbUVP1t7qSepJvV+67QLsEvUdAgf54bjboFn/wI1bL+jbhRlib0GdQKlU
         rH/LEva47UNFNVpWroEIOqch2o4d/pQnrkGa1SDEETY0WwrRguxP8PVXk8e5o63zdJ
         W0FoKMOQMTHsYyMrDSju6DVW6XPeVLACHkXqmxUc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 4.14 052/210] ALSA: usb-audio: Fix potential memory leaks
Date:   Mon, 24 Oct 2022 13:29:29 +0200
Message-Id: <20221024112958.689353440@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024112956.797777597@linuxfoundation.org>
References: <20221024112956.797777597@linuxfoundation.org>
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
@@ -818,6 +818,7 @@ static int sync_ep_set_params(struct snd
 	if (!ep->syncbuf)
 		return -ENOMEM;
 
+	ep->nurbs = SYNC_URBS;
 	for (i = 0; i < SYNC_URBS; i++) {
 		struct snd_urb_ctx *u = &ep->urb[i];
 		u->index = i;
@@ -837,8 +838,6 @@ static int sync_ep_set_params(struct snd
 		u->urb->complete = snd_complete_urb;
 	}
 
-	ep->nurbs = SYNC_URBS;
-
 	return 0;
 
 out_of_memory:


