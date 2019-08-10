Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A4A4D88D7D
	for <lists+stable@lfdr.de>; Sat, 10 Aug 2019 22:47:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727090AbfHJUqZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Aug 2019 16:46:25 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55340 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726457AbfHJUoH (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 10 Aug 2019 16:44:07 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1hwYDb-00053a-W5; Sat, 10 Aug 2019 21:44:04 +0100
Received: from ben by deadeye with local (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1hwYDL-0003dJ-5n; Sat, 10 Aug 2019 21:43:47 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "J. Bruce Fields" <bfields@redhat.com>,
        "NeilBrown" <neilb@suse.com>
Date:   Sat, 10 Aug 2019 21:40:07 +0100
Message-ID: <lsq.1565469607.504505883@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 073/157] sunrpc: don't mark uninitialised items as VALID.
In-Reply-To: <lsq.1565469607.188083258@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.72-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: NeilBrown <neilb@suse.com>

commit d58431eacb226222430940134d97bfd72f292fcd upstream.

A recent commit added a call to cache_fresh_locked()
when an expired item was found.
The call sets the CACHE_VALID flag, so it is important
that the item actually is valid.
There are two ways it could be valid:
1/ If ->update has been called to fill in relevant content
2/ if CACHE_NEGATIVE is set, to say that content doesn't exist.

An expired item that is waiting for an update will be neither.
Setting CACHE_VALID will mean that a subsequent call to cache_put()
will be likely to dereference uninitialised pointers.

So we must make sure the item is valid, and we already have code to do
that in try_to_negate_entry().  This takes the hash lock and so cannot
be used directly, so take out the two lines that we need and use them.

Now cache_fresh_locked() is certain to be called only on
a valid item.

Fixes: 4ecd55ea0742 ("sunrpc: fix cache_head leak due to queued request")
Signed-off-by: NeilBrown <neilb@suse.com>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
[bwh: Backported to 3.16: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/sunrpc/cache.c | 3 +++
 1 file changed, 3 insertions(+)

--- a/net/sunrpc/cache.c
+++ b/net/sunrpc/cache.c
@@ -50,6 +50,7 @@ static void cache_init(struct cache_head
 	h->last_refresh = now;
 }
 
+static inline int cache_is_valid(struct cache_head *h);
 static void cache_fresh_locked(struct cache_head *head, time_t expiry);
 static void cache_fresh_unlocked(struct cache_head *head,
 				struct cache_detail *detail);
@@ -98,6 +99,8 @@ struct cache_head *sunrpc_cache_lookup(s
 				*hp = tmp->next;
 				tmp->next = NULL;
 				detail->entries --;
+				if (cache_is_valid(tmp) == -EAGAIN)
+					set_bit(CACHE_NEGATIVE, &tmp->flags);
 				cache_fresh_locked(tmp, 0);
 				freeme = tmp;
 				break;

