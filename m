Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC386187F18
	for <lists+stable@lfdr.de>; Tue, 17 Mar 2020 11:58:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727233AbgCQK61 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Mar 2020 06:58:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:36604 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726827AbgCQK60 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Mar 2020 06:58:26 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E43D020724;
        Tue, 17 Mar 2020 10:58:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584442706;
        bh=K/bdzkzeh1qRPK264I+1ky5PKNqHMQE9Nl4FVD1QJSc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RzXjNxYzsN/upmQbf6oqN17/aL3geCqC3Q3/KclOJ9Mi7yOPl7FyqF4kgQ5bI6efU
         /nci7nqUzEHfqtZVMxire5aiIPODuZRZ3JqpjZY+vLuxV0bdyKs/fyNiXgEJp7+rft
         hkHQY5Wf9g9J23AB+wKrkv5f2LteFyQ/CT3qDZ+c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vasily Averin <vvs@virtuozzo.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 4.19 53/89] netfilter: xt_recent: recent_seq_next should increase position index
Date:   Tue, 17 Mar 2020 11:55:02 +0100
Message-Id: <20200317103306.027529324@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200317103259.744774526@linuxfoundation.org>
References: <20200317103259.744774526@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vasily Averin <vvs@virtuozzo.com>

commit db25517a550926f609c63054b12ea9ad515e1a10 upstream.

If .next function does not change position index,
following .show function will repeat output related
to current position index.

Without the patch:
 # dd if=/proc/net/xt_recent/SSH # original file outpt
 src=127.0.0.4 ttl: 0 last_seen: 6275444819 oldest_pkt: 1 6275444819
 src=127.0.0.2 ttl: 0 last_seen: 6275438906 oldest_pkt: 1 6275438906
 src=127.0.0.3 ttl: 0 last_seen: 6275441953 oldest_pkt: 1 6275441953
 0+1 records in
 0+1 records out
 204 bytes copied, 6.1332e-05 s, 3.3 MB/s

Read after lseek into middle of last line (offset 140 in example below)
generates expected end of last line and then unexpected whole last line
once again

 # dd if=/proc/net/xt_recent/SSH bs=140 skip=1
 dd: /proc/net/xt_recent/SSH: cannot skip to specified offset
 127.0.0.3 ttl: 0 last_seen: 6275441953 oldest_pkt: 1 6275441953
 src=127.0.0.3 ttl: 0 last_seen: 6275441953 oldest_pkt: 1 6275441953
 0+1 records in
 0+1 records out
 132 bytes copied, 6.2487e-05 s, 2.1 MB/s

Cc: stable@vger.kernel.org
Fixes: 1f4aace60b0e ("fs/seq_file.c: simplify seq_file iteration code ...")
Link: https://bugzilla.kernel.org/show_bug.cgi?id=206283
Signed-off-by: Vasily Averin <vvs@virtuozzo.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/netfilter/xt_recent.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/netfilter/xt_recent.c
+++ b/net/netfilter/xt_recent.c
@@ -497,12 +497,12 @@ static void *recent_seq_next(struct seq_
 	const struct recent_entry *e = v;
 	const struct list_head *head = e->list.next;
 
+	(*pos)++;
 	while (head == &t->iphash[st->bucket]) {
 		if (++st->bucket >= ip_list_hash_size)
 			return NULL;
 		head = t->iphash[st->bucket].next;
 	}
-	(*pos)++;
 	return list_entry(head, struct recent_entry, list);
 }
 


