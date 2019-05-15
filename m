Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C4DB11F3E9
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 14:20:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727777AbfEOLBw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 07:01:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:58948 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727788AbfEOLBv (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 07:01:51 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2A80120881;
        Wed, 15 May 2019 11:01:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557918110;
        bh=xTz0TplUvCuk3TISQVkGrsJzMSmpwDhzVRj928ZBAqQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sYPsik61KypDYCJaCzUtzCp3AXgMEsLN+cM4ITk1n2+0WJdLEIjOPKL5Nx5B71sKs
         CbOYgRr5hwx3x7XnhyfxWTg+5Lxcp/92laqZD/np0Eb53DUtKXk9JjFwjIbxtpuXmh
         gi981b8Y26nHDgTN0rFvYoA0XBXnHomjEgplSbMc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, NeilBrown <neilb@suse.com>,
        "J. Bruce Fields" <bfields@redhat.com>, stable@kernel.org
Subject: [PATCH 4.4 010/266] sunrpc: dont mark uninitialised items as VALID.
Date:   Wed, 15 May 2019 12:51:57 +0200
Message-Id: <20190515090723.000470835@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190515090722.696531131@linuxfoundation.org>
References: <20190515090722.696531131@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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

Cc: stable@kernel.org # 2.6.35
Fixes: 4ecd55ea0742 ("sunrpc: fix cache_head leak due to queued request")
Signed-off-by: NeilBrown <neilb@suse.com>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/sunrpc/cache.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/net/sunrpc/cache.c
+++ b/net/sunrpc/cache.c
@@ -54,6 +54,7 @@ static void cache_init(struct cache_head
 	h->last_refresh = now;
 }
 
+static inline int cache_is_valid(struct cache_head *h);
 static void cache_fresh_locked(struct cache_head *head, time_t expiry,
 				struct cache_detail *detail);
 static void cache_fresh_unlocked(struct cache_head *head,
@@ -100,6 +101,8 @@ struct cache_head *sunrpc_cache_lookup(s
 			if (cache_is_expired(detail, tmp)) {
 				hlist_del_init(&tmp->cache_list);
 				detail->entries --;
+				if (cache_is_valid(tmp) == -EAGAIN)
+					set_bit(CACHE_NEGATIVE, &tmp->flags);
 				cache_fresh_locked(tmp, 0, detail);
 				freeme = tmp;
 				break;


