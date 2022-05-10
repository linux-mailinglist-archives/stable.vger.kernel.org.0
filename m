Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F7DB5217E2
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 15:26:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243174AbiEJN3t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 09:29:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243287AbiEJN3M (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 09:29:12 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C777F4664D;
        Tue, 10 May 2022 06:21:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 5C4B9CE1EA8;
        Tue, 10 May 2022 13:21:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7568CC385A6;
        Tue, 10 May 2022 13:21:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652188861;
        bh=0w0xQr+Pu/llxYWRbwOnMuOVCGxAkws6yzESbdnf+gk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=of5ANiW1CWbqaIzBaJd1m0qdv8e39gX28djZO4uf3RpeMw1VtSWz8HYwjxv6RkjBD
         x55u5kvNH6ycZGucOvttL3xhzK4qjso6clohVP2YEMFCF0x5b/GQG4/zodLOKbEQQV
         eo/AUxNEEydaC7mn35XXSBc58ZwmnIy2C/7JtZzU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jakob Koschel <jakobkoschel@gmail.com>,
        Takashi Sakamoto <o-takashi@sakamocchi.jp>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 4.19 64/88] firewire: remove check of list iterator against head past the loop body
Date:   Tue, 10 May 2022 15:07:49 +0200
Message-Id: <20220510130735.599440441@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220510130733.735278074@linuxfoundation.org>
References: <20220510130733.735278074@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jakob Koschel <jakobkoschel@gmail.com>

commit 9423973869bd4632ffe669f950510c49296656e0 upstream.

When list_for_each_entry() completes the iteration over the whole list
without breaking the loop, the iterator value will be a bogus pointer
computed based on the head element.

While it is safe to use the pointer to determine if it was computed
based on the head element, either with list_entry_is_head() or
&pos->member == head, using the iterator variable after the loop should
be avoided.

In preparation to limit the scope of a list iterator to the list
traversal loop, use a dedicated pointer to point to the found element [1].

Link: https://lore.kernel.org/all/CAHk-=wgRr_D8CB-D9Kg-c=EHreAsk5SqXPwr9Y7k9sA6cWXJ6w@mail.gmail.com/ [1]
Cc: <stable@vger.kernel.org>
Signed-off-by: Jakob Koschel <jakobkoschel@gmail.com>
Signed-off-by: Takashi Sakamoto <o-takashi@sakamocchi.jp>
Link: https://lore.kernel.org/r/20220409041243.603210-3-o-takashi@sakamocchi.jp
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/firewire/core-transaction.c |   30 ++++++++++++++++--------------
 drivers/firewire/sbp2.c             |   13 +++++++------
 2 files changed, 23 insertions(+), 20 deletions(-)

--- a/drivers/firewire/core-transaction.c
+++ b/drivers/firewire/core-transaction.c
@@ -86,24 +86,25 @@ static int try_cancel_split_timeout(stru
 static int close_transaction(struct fw_transaction *transaction,
 			     struct fw_card *card, int rcode)
 {
-	struct fw_transaction *t;
+	struct fw_transaction *t = NULL, *iter;
 	unsigned long flags;
 
 	spin_lock_irqsave(&card->lock, flags);
-	list_for_each_entry(t, &card->transaction_list, link) {
-		if (t == transaction) {
-			if (!try_cancel_split_timeout(t)) {
+	list_for_each_entry(iter, &card->transaction_list, link) {
+		if (iter == transaction) {
+			if (!try_cancel_split_timeout(iter)) {
 				spin_unlock_irqrestore(&card->lock, flags);
 				goto timed_out;
 			}
-			list_del_init(&t->link);
-			card->tlabel_mask &= ~(1ULL << t->tlabel);
+			list_del_init(&iter->link);
+			card->tlabel_mask &= ~(1ULL << iter->tlabel);
+			t = iter;
 			break;
 		}
 	}
 	spin_unlock_irqrestore(&card->lock, flags);
 
-	if (&t->link != &card->transaction_list) {
+	if (t) {
 		t->callback(card, rcode, NULL, 0, t->callback_data);
 		return 0;
 	}
@@ -938,7 +939,7 @@ EXPORT_SYMBOL(fw_core_handle_request);
 
 void fw_core_handle_response(struct fw_card *card, struct fw_packet *p)
 {
-	struct fw_transaction *t;
+	struct fw_transaction *t = NULL, *iter;
 	unsigned long flags;
 	u32 *data;
 	size_t data_length;
@@ -950,20 +951,21 @@ void fw_core_handle_response(struct fw_c
 	rcode	= HEADER_GET_RCODE(p->header[1]);
 
 	spin_lock_irqsave(&card->lock, flags);
-	list_for_each_entry(t, &card->transaction_list, link) {
-		if (t->node_id == source && t->tlabel == tlabel) {
-			if (!try_cancel_split_timeout(t)) {
+	list_for_each_entry(iter, &card->transaction_list, link) {
+		if (iter->node_id == source && iter->tlabel == tlabel) {
+			if (!try_cancel_split_timeout(iter)) {
 				spin_unlock_irqrestore(&card->lock, flags);
 				goto timed_out;
 			}
-			list_del_init(&t->link);
-			card->tlabel_mask &= ~(1ULL << t->tlabel);
+			list_del_init(&iter->link);
+			card->tlabel_mask &= ~(1ULL << iter->tlabel);
+			t = iter;
 			break;
 		}
 	}
 	spin_unlock_irqrestore(&card->lock, flags);
 
-	if (&t->link == &card->transaction_list) {
+	if (!t) {
  timed_out:
 		fw_notice(card, "unsolicited response (source %x, tlabel %x)\n",
 			  source, tlabel);
--- a/drivers/firewire/sbp2.c
+++ b/drivers/firewire/sbp2.c
@@ -421,7 +421,7 @@ static void sbp2_status_write(struct fw_
 			      void *payload, size_t length, void *callback_data)
 {
 	struct sbp2_logical_unit *lu = callback_data;
-	struct sbp2_orb *orb;
+	struct sbp2_orb *orb = NULL, *iter;
 	struct sbp2_status status;
 	unsigned long flags;
 
@@ -446,17 +446,18 @@ static void sbp2_status_write(struct fw_
 
 	/* Lookup the orb corresponding to this status write. */
 	spin_lock_irqsave(&lu->tgt->lock, flags);
-	list_for_each_entry(orb, &lu->orb_list, link) {
+	list_for_each_entry(iter, &lu->orb_list, link) {
 		if (STATUS_GET_ORB_HIGH(status) == 0 &&
-		    STATUS_GET_ORB_LOW(status) == orb->request_bus) {
-			orb->rcode = RCODE_COMPLETE;
-			list_del(&orb->link);
+		    STATUS_GET_ORB_LOW(status) == iter->request_bus) {
+			iter->rcode = RCODE_COMPLETE;
+			list_del(&iter->link);
+			orb = iter;
 			break;
 		}
 	}
 	spin_unlock_irqrestore(&lu->tgt->lock, flags);
 
-	if (&orb->link != &lu->orb_list) {
+	if (orb) {
 		orb->callback(orb, &status);
 		kref_put(&orb->kref, free_orb); /* orb callback reference */
 	} else {


