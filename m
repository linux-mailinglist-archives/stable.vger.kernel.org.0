Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C32FF5AEC52
	for <lists+stable@lfdr.de>; Tue,  6 Sep 2022 16:28:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241575AbiIFOR0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Sep 2022 10:17:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241321AbiIFOQM (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Sep 2022 10:16:12 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AFE9B98;
        Tue,  6 Sep 2022 06:49:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 50A4AB8162F;
        Tue,  6 Sep 2022 13:48:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAC9DC433C1;
        Tue,  6 Sep 2022 13:48:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662472096;
        bh=K4dGkykxDeQfgG8iJRdoD0/3YR3v+GjHk/N6AhY71Gw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wWUBFgmqQNzix0ksB7VJbbUlRm6gjdLQYRmLVv31yXOpbIovdGWW94QKi85EefoTV
         ltxlgcvgm3zEjzh6LtoYzDIMf/Q4ozNZJ+fCebmmwfeHYq0S4GE5pdoifBbAwxKldF
         hmCWQcFLKbRGDMaZ1O9hMnp64rFvRa9ArWSB/izs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Abhishek Shah <abhishek.shah@columbia.edu>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.19 147/155] ALSA: seq: Fix data-race at module auto-loading
Date:   Tue,  6 Sep 2022 15:31:35 +0200
Message-Id: <20220906132835.634243627@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220906132829.417117002@linuxfoundation.org>
References: <20220906132829.417117002@linuxfoundation.org>
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

commit 3e7e04b747adea36f349715d9f0998eeebf15d72 upstream.

It's been reported that there is a possible data-race accessing to the
global card_requested[] array at ALSA sequencer core, which is used
for determining whether to call request_module() for the card or not.
This data race itself is almost harmless, as it might end up with one
extra request_module() call for the already loaded module at most.
But it's still better to fix.

This patch addresses the possible data race of card_requested[] and
client_requested[] arrays by replacing them with bitmask.
It's an atomic operation and can work without locks.

Reported-by: Abhishek Shah <abhishek.shah@columbia.edu>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/CAEHB24_ay6YzARpA1zgCsE7=H9CSJJzux618E=Ka4h0YdKn=qA@mail.gmail.com
Link: https://lore.kernel.org/r/20220823072717.1706-2-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/core/seq/seq_clientmgr.c |   12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

--- a/sound/core/seq/seq_clientmgr.c
+++ b/sound/core/seq/seq_clientmgr.c
@@ -121,13 +121,13 @@ struct snd_seq_client *snd_seq_client_us
 	spin_unlock_irqrestore(&clients_lock, flags);
 #ifdef CONFIG_MODULES
 	if (!in_interrupt()) {
-		static char client_requested[SNDRV_SEQ_GLOBAL_CLIENTS];
-		static char card_requested[SNDRV_CARDS];
+		static DECLARE_BITMAP(client_requested, SNDRV_SEQ_GLOBAL_CLIENTS);
+		static DECLARE_BITMAP(card_requested, SNDRV_CARDS);
+
 		if (clientid < SNDRV_SEQ_GLOBAL_CLIENTS) {
 			int idx;
 			
-			if (!client_requested[clientid]) {
-				client_requested[clientid] = 1;
+			if (!test_and_set_bit(clientid, client_requested)) {
 				for (idx = 0; idx < 15; idx++) {
 					if (seq_client_load[idx] < 0)
 						break;
@@ -142,10 +142,8 @@ struct snd_seq_client *snd_seq_client_us
 			int card = (clientid - SNDRV_SEQ_GLOBAL_CLIENTS) /
 				SNDRV_SEQ_CLIENTS_PER_CARD;
 			if (card < snd_ecards_limit) {
-				if (! card_requested[card]) {
-					card_requested[card] = 1;
+				if (!test_and_set_bit(card, card_requested))
 					snd_request_card(card);
-				}
 				snd_seq_device_load_drivers();
 			}
 		}


