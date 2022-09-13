Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EEF5E5B745B
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 17:25:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235873AbiIMPVM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 11:21:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235872AbiIMPTl (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 11:19:41 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E1647B1DD;
        Tue, 13 Sep 2022 07:36:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 85CB3B80FC6;
        Tue, 13 Sep 2022 14:34:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5008C433D7;
        Tue, 13 Sep 2022 14:34:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663079678;
        bh=2jMSUEghuLlu/1D6x2idR7tJj/F/ZgljozPqFgP5Eq4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=07uMPzxVzf9Niifmcz3gbCqG9jII2KIlDMGTNxjllX/uTRr4PZPJVC+xS11Bdl5do
         4jL7mCxL22fCXzsXgVL0b/lZiQRGfOb3lAZGScaiOAt/rtZ5vNc1YlomxELyk76BbR
         tsLdqqK8yUGfGqMH1oQKWi1pcPeXZRzDGRJ8I5lI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Abhishek Shah <abhishek.shah@columbia.edu>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 4.14 33/61] ALSA: seq: Fix data-race at module auto-loading
Date:   Tue, 13 Sep 2022 16:07:35 +0200
Message-Id: <20220913140348.146108554@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220913140346.422813036@linuxfoundation.org>
References: <20220913140346.422813036@linuxfoundation.org>
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
@@ -136,13 +136,13 @@ struct snd_seq_client *snd_seq_client_us
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
@@ -157,10 +157,8 @@ struct snd_seq_client *snd_seq_client_us
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


