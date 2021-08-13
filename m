Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F40FE3EB7DD
	for <lists+stable@lfdr.de>; Fri, 13 Aug 2021 17:24:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241365AbhHMPJp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Aug 2021 11:09:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:52218 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241223AbhHMPJc (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 13 Aug 2021 11:09:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6DF52610CC;
        Fri, 13 Aug 2021 15:09:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628867345;
        bh=EFJhGl4j17dSbDx5yR+3T/oEosXLQSue43tuVXBDXrU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l+zdLs41LWZ/TNwadC7dgp0yevp5sKrZkkYVYdU+EeNteyiKAaSxB8wdU1vpZe2l/
         7H71crrQOP/Unr36TCXofp+pv5GzBwPZS514DD7I+JroTHUeEXsr3J1wq7gPWUSt9j
         sNPudGpOkb4CYfFzRHFqycUD5vR9wbYBQd+WkXd8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>,
        folkert <folkert@vanheusden.com>
Subject: [PATCH 4.9 01/30] ALSA: seq: Fix racy deletion of subscriber
Date:   Fri, 13 Aug 2021 17:06:29 +0200
Message-Id: <20210813150522.497007732@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210813150522.445553924@linuxfoundation.org>
References: <20210813150522.445553924@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
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
@@ -532,10 +532,11 @@ static int check_and_subscribe_port(stru
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
@@ -543,7 +544,6 @@ static void delete_and_unsubscribe_port(
 
 	grp = is_src ? &port->c_src : &port->c_dest;
 	list = is_src ? &subs->src_list : &subs->dest_list;
-	down_write(&grp->list_mutex);
 	write_lock_irq(&grp->list_lock);
 	empty = list_empty(list);
 	if (!empty)
@@ -553,6 +553,18 @@ static void delete_and_unsubscribe_port(
 
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
 
@@ -608,27 +620,30 @@ int snd_seq_port_disconnect(struct snd_s
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


