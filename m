Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 350FB5EA584
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 14:06:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239151AbiIZMGf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 08:06:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238793AbiIZMDJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 08:03:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0816A7D1F9;
        Mon, 26 Sep 2022 03:53:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C193F60769;
        Mon, 26 Sep 2022 10:42:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBEE2C433C1;
        Mon, 26 Sep 2022 10:42:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664188955;
        bh=ekEYV8am7I3UA39OEA5d3IcLfPZlN6rAm5VHcwf7ZNQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BUhFF6zjLocop8E8hgXl6xf7chthZsoTOgfo5hAgDa5cSrCsMu7hMStxdqMRMEKCI
         J6K080h/tICIG770m8FJ7EWCMImjnju+7G5rzjcfywkklcHxEArBXX+ay7ETzfkXMO
         h9lxtELdvNYWGu9m9lpCjoncooY8qnXLdsY6XD+A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rondreis <linhaoguo86@gmail.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.19 026/207] ALSA: core: Fix double-free at snd_card_new()
Date:   Mon, 26 Sep 2022 12:10:15 +0200
Message-Id: <20220926100807.648115115@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100806.522017616@linuxfoundation.org>
References: <20220926100806.522017616@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

commit c3afa2a402d1ecefa59f88d55d9e765f52f75bd9 upstream.

During the code change to add the support for devres-managed card
instance, we put an explicit kfree(card) call at the error path in
snd_card_new().  This is needed for the early error path before the
card is initialized with the device, but is rather superfluous and
causes a double-free at the error path after the card instance is
initialized, as the destructor of the card object already contains a
kfree() call.

This patch fixes the double-free situation by removing the superfluous
kfree().  Meanwhile we need to call kfree() explicitly for the early
error path, so it's added there instead.

Fixes: e8ad415b7a55 ("ALSA: core: Add managed card creation")
Reported-by: Rondreis <linhaoguo86@gmail.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/CAB7eexL1zBnB636hwS27d-LdPYZ_R1-5fJS_h=ZbCWYU=UPWJg@mail.gmail.com
Link: https://lore.kernel.org/r/20220919123516.28222-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/core/init.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/sound/core/init.c
+++ b/sound/core/init.c
@@ -178,10 +178,8 @@ int snd_card_new(struct device *parent,
 		return -ENOMEM;
 
 	err = snd_card_init(card, parent, idx, xid, module, extra_size);
-	if (err < 0) {
-		kfree(card);
-		return err;
-	}
+	if (err < 0)
+		return err; /* card is freed by error handler */
 
 	*card_ret = card;
 	return 0;
@@ -231,7 +229,7 @@ int snd_devm_card_new(struct device *par
 	card->managed = true;
 	err = snd_card_init(card, parent, idx, xid, module, extra_size);
 	if (err < 0) {
-		devres_free(card);
+		devres_free(card); /* in managed mode, we need to free manually */
 		return err;
 	}
 
@@ -293,6 +291,8 @@ static int snd_card_init(struct snd_card
 		mutex_unlock(&snd_card_mutex);
 		dev_err(parent, "cannot find the slot for index %d (range 0-%i), error: %d\n",
 			 idx, snd_ecards_limit - 1, err);
+		if (!card->managed)
+			kfree(card); /* manually free here, as no destructor called */
 		return err;
 	}
 	set_bit(idx, snd_cards_lock);		/* lock it */


