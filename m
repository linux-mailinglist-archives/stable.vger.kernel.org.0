Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A4943E7EAE
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 19:34:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231465AbhHJRev (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 13:34:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:33340 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232123AbhHJReR (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Aug 2021 13:34:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 58BF96108C;
        Tue, 10 Aug 2021 17:33:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628616834;
        bh=FfXHP7cUmnlDTXqLMrTXsprmJ00OVsWAgbgMHCiyXAQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z2P41GFcBUIkpBXwTTmyhX9u0CLv6LCsJUN4WuYiIAZCNfe2RUaXFhYrvbf15dA5K
         Lm3opBZ61izMEAY6c6mNdY46kxSSZTYW/YKAh//P4ShiWkXzVN5eTjDydw8WGRwM8v
         nHiWCfco5VtAReJwrhUanxfajAnfMVisuvagFW5E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>,
        folkert <folkert@vanheusden.com>
Subject: [PATCH 5.4 02/85] ALSA: seq: Fix racy deletion of subscriber
Date:   Tue, 10 Aug 2021 19:29:35 +0200
Message-Id: <20210810172948.276659721@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210810172948.192298392@linuxfoundation.org>
References: <20210810172948.192298392@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

commit 97367c97226aab8b298ada954ce12659ee3ad2a4 upstream.

It turned out that the current implementation of the port subscription
is racy.  The subscription contains two linked lists, and we have to
add to or delete from both lists.  Since both connection and
disconnection procedures perform the same order for those two lists
(i.e. src list, then dest list), when a deletion happens during a
connection procedure, the src list may be deleted before the dest list
addition completes, and this may lead to a use-after-free or an Oops,
even though the access to both lists are protected via mutex.

The simple workaround for this race is to change the access order for
the disconnection, namely, dest list, then src list.  This assures
that the connection has been established when disconnecting, and also
the concurrent deletion can be avoided.

Reported-and-tested-by: folkert <folkert@vanheusden.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20210801182754.GP890690@belle.intranet.vanheusden.com
Link: https://lore.kernel.org/r/20210803114312.2536-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/core/seq/seq_ports.c |   39 +++++++++++++++++++++++++++------------
 1 file changed, 27 insertions(+), 12 deletions(-)

--- a/sound/core/seq/seq_ports.c
+++ b/sound/core/seq/seq_ports.c
@@ -514,10 +514,11 @@ static int check_and_subscribe_port(stru
 	return err;
 }
 
-static void delete_and_unsubscribe_port(struct snd_seq_client *client,
-					struct snd_seq_client_port *port,
-					struct snd_seq_subscribers *subs,
-					bool is_src, bool ack)
+/* called with grp->list_mutex held */
+static void __delete_and_unsubscribe_port(struct snd_seq_client *client,
+					  struct snd_seq_client_port *port,
+					  struct snd_seq_subscribers *subs,
+					  bool is_src, bool ack)
 {
 	struct snd_seq_port_subs_info *grp;
 	struct list_head *list;
@@ -525,7 +526,6 @@ static void delete_and_unsubscribe_port(
 
 	grp = is_src ? &port->c_src : &port->c_dest;
 	list = is_src ? &subs->src_list : &subs->dest_list;
-	down_write(&grp->list_mutex);
 	write_lock_irq(&grp->list_lock);
 	empty = list_empty(list);
 	if (!empty)
@@ -535,6 +535,18 @@ static void delete_and_unsubscribe_port(
 
 	if (!empty)
 		unsubscribe_port(client, port, grp, &subs->info, ack);
+}
+
+static void delete_and_unsubscribe_port(struct snd_seq_client *client,
+					struct snd_seq_client_port *port,
+					struct snd_seq_subscribers *subs,
+					bool is_src, bool ack)
+{
+	struct snd_seq_port_subs_info *grp;
+
+	grp = is_src ? &port->c_src : &port->c_dest;
+	down_write(&grp->list_mutex);
+	__delete_and_unsubscribe_port(client, port, subs, is_src, ack);
 	up_write(&grp->list_mutex);
 }
 
@@ -590,27 +602,30 @@ int snd_seq_port_disconnect(struct snd_s
 			    struct snd_seq_client_port *dest_port,
 			    struct snd_seq_port_subscribe *info)
 {
-	struct snd_seq_port_subs_info *src = &src_port->c_src;
+	struct snd_seq_port_subs_info *dest = &dest_port->c_dest;
 	struct snd_seq_subscribers *subs;
 	int err = -ENOENT;
 
-	down_write(&src->list_mutex);
+	/* always start from deleting the dest port for avoiding concurrent
+	 * deletions
+	 */
+	down_write(&dest->list_mutex);
 	/* look for the connection */
-	list_for_each_entry(subs, &src->list_head, src_list) {
+	list_for_each_entry(subs, &dest->list_head, dest_list) {
 		if (match_subs_info(info, &subs->info)) {
-			atomic_dec(&subs->ref_count); /* mark as not ready */
+			__delete_and_unsubscribe_port(dest_client, dest_port,
+						      subs, false,
+						      connector->number != dest_client->number);
 			err = 0;
 			break;
 		}
 	}
-	up_write(&src->list_mutex);
+	up_write(&dest->list_mutex);
 	if (err < 0)
 		return err;
 
 	delete_and_unsubscribe_port(src_client, src_port, subs, true,
 				    connector->number != src_client->number);
-	delete_and_unsubscribe_port(dest_client, dest_port, subs, false,
-				    connector->number != dest_client->number);
 	kfree(subs);
 	return 0;
 }


