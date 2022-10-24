Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF96660AAEB
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 15:42:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236037AbiJXNmS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 09:42:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236023AbiJXNh0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 09:37:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4F9C28E28;
        Mon, 24 Oct 2022 05:36:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7E8C161297;
        Mon, 24 Oct 2022 12:34:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92053C433C1;
        Mon, 24 Oct 2022 12:34:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666614861;
        bh=X2XpOUCM4nCnu2cwJmejV4EjwMZM2ILfoBkD10ig+7o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SHKtwvybqVKsyB2TeVtZ+vwHgMG6d1WBmoFfLkeOJBELI3W9mLLcNRPTifGEJgQwx
         BdVla/Hx+juElxysje1UXlTS34a0q5CERbwlJnrEI88GlpRNGJFi5INZqJJ7P3QX7N
         pWyEJ3eTRV70gEBBc/LoMeaEIWeXj1011g0XAvAI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.15 004/530] ALSA: usb-audio: Fix potential memory leaks
Date:   Mon, 24 Oct 2022 13:25:48 +0200
Message-Id: <20221024113045.180473538@linuxfoundation.org>
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
@@ -1223,6 +1223,7 @@ static int sync_ep_set_params(struct snd
 	if (!ep->syncbuf)
 		return -ENOMEM;
 
+	ep->nurbs = SYNC_URBS;
 	for (i = 0; i < SYNC_URBS; i++) {
 		struct snd_urb_ctx *u = &ep->urb[i];
 		u->index = i;
@@ -1242,8 +1243,6 @@ static int sync_ep_set_params(struct snd
 		u->urb->complete = snd_complete_urb;
 	}
 
-	ep->nurbs = SYNC_URBS;
-
 	return 0;
 
 out_of_memory:


