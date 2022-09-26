Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B2C85EA2C4
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 13:14:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235577AbiIZLOX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 07:14:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237427AbiIZLNT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 07:13:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 271BB61B2C;
        Mon, 26 Sep 2022 03:35:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 24724B8074E;
        Mon, 26 Sep 2022 10:34:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D22FC433D6;
        Mon, 26 Sep 2022 10:34:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664188487;
        bh=ekEYV8am7I3UA39OEA5d3IcLfPZlN6rAm5VHcwf7ZNQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uvJ/90kILR1bw2V2pYQ5/9PoIBUpLc7fs1rfzjfY9yYpWuFsKR6PZhhE+c+YZsW3Q
         lcU/+nfcLBI9LkOJAOYmCqbA+gEe9SBfAGfwy8SiR8Nm9I54y7U+Geyv2DK+5WX6zL
         FnKt35kt1yp+hf9vgu6v5tXFL3dQHKcEY+mZyw+Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rondreis <linhaoguo86@gmail.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.15 024/148] ALSA: core: Fix double-free at snd_card_new()
Date:   Mon, 26 Sep 2022 12:10:58 +0200
Message-Id: <20220926100756.979684103@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100756.074519146@linuxfoundation.org>
References: <20220926100756.074519146@linuxfoundation.org>
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


