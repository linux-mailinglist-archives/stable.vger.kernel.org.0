Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D8D1178079
	for <lists+stable@lfdr.de>; Tue,  3 Mar 2020 20:00:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733011AbgCCR5H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Mar 2020 12:57:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:39472 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733002AbgCCR5D (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Mar 2020 12:57:03 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BF39420656;
        Tue,  3 Mar 2020 17:57:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583258223;
        bh=eroNwEbXR2gs16J1JOIuR9JCnEkWWNCI256UXJQXHsI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ta+EQeID1Ea04OZ0GUuQx7SNHEn1vo6eXsfhwVtTEL+YY9dbQhiErjfUUb1kYyVu7
         fm2QVQGsNhVQYiFMktbVuFcezR5oPZXRuyZs+7W3YgglwAqYWeH6GyL0XeFlJKJkt8
         7JkJA7YI5oYP7GalT46vqpvTmISdDdB+rUhbG0w4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Florian Westphal <fw@strlen.de>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        syzbot+adf6c6c2be1c3a718121@syzkaller.appspotmail.com
Subject: [PATCH 5.4 091/152] netfilter: xt_hashlimit: reduce hashlimit_mutex scope for htable_put()
Date:   Tue,  3 Mar 2020 18:43:09 +0100
Message-Id: <20200303174312.916450565@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200303174302.523080016@linuxfoundation.org>
References: <20200303174302.523080016@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Cong Wang <xiyou.wangcong@gmail.com>

commit c4a3922d2d20c710f827d3a115ee338e8d0467df upstream.

It is unnecessary to hold hashlimit_mutex for htable_destroy()
as it is already removed from the global hashtable and its
refcount is already zero.

Also, switch hinfo->use to refcount_t so that we don't have
to hold the mutex until it reaches zero in htable_put().

Reported-and-tested-by: syzbot+adf6c6c2be1c3a718121@syzkaller.appspotmail.com
Acked-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/netfilter/xt_hashlimit.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/net/netfilter/xt_hashlimit.c
+++ b/net/netfilter/xt_hashlimit.c
@@ -36,6 +36,7 @@
 #include <linux/netfilter_ipv6/ip6_tables.h>
 #include <linux/mutex.h>
 #include <linux/kernel.h>
+#include <linux/refcount.h>
 #include <uapi/linux/netfilter/xt_hashlimit.h>
 
 #define XT_HASHLIMIT_ALL (XT_HASHLIMIT_HASH_DIP | XT_HASHLIMIT_HASH_DPT | \
@@ -114,7 +115,7 @@ struct dsthash_ent {
 
 struct xt_hashlimit_htable {
 	struct hlist_node node;		/* global list of all htables */
-	int use;
+	refcount_t use;
 	u_int8_t family;
 	bool rnd_initialized;
 
@@ -315,7 +316,7 @@ static int htable_create(struct net *net
 	for (i = 0; i < hinfo->cfg.size; i++)
 		INIT_HLIST_HEAD(&hinfo->hash[i]);
 
-	hinfo->use = 1;
+	refcount_set(&hinfo->use, 1);
 	hinfo->count = 0;
 	hinfo->family = family;
 	hinfo->rnd_initialized = false;
@@ -434,7 +435,7 @@ static struct xt_hashlimit_htable *htabl
 	hlist_for_each_entry(hinfo, &hashlimit_net->htables, node) {
 		if (!strcmp(name, hinfo->name) &&
 		    hinfo->family == family) {
-			hinfo->use++;
+			refcount_inc(&hinfo->use);
 			return hinfo;
 		}
 	}
@@ -443,12 +444,11 @@ static struct xt_hashlimit_htable *htabl
 
 static void htable_put(struct xt_hashlimit_htable *hinfo)
 {
-	mutex_lock(&hashlimit_mutex);
-	if (--hinfo->use == 0) {
+	if (refcount_dec_and_mutex_lock(&hinfo->use, &hashlimit_mutex)) {
 		hlist_del(&hinfo->node);
+		mutex_unlock(&hashlimit_mutex);
 		htable_destroy(hinfo);
 	}
-	mutex_unlock(&hashlimit_mutex);
 }
 
 /* The algorithm used is the Simple Token Bucket Filter (TBF)


