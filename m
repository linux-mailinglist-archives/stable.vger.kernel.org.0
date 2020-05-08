Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6365B1CABF9
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 14:48:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729097AbgEHMsp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 08:48:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:53014 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729323AbgEHMso (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:48:44 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F1C6F21473;
        Fri,  8 May 2020 12:48:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588942123;
        bh=lAVFeiT4Fm2Frsb6vpfZaCVrJ1rCwK6Np5lnGwFM0fA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RlQzmTCV3UbInyN6mX7rDdnRlvhYQKPEVBGB9YHRiBOlggEyH0c0zlfIQNaFmmsDJ
         M9YAS3IDTR8DNfR8SACVzGybk/rpaNBPcgSzreguVLOjIPO4IlW8P/lwnCQyPp6PzU
         Tn+p0FGMAsCIPaS7SUkWT8519iz/8uUBaNGfyKKs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Toshiaki Makita <makita.toshiaki@lab.ntt.co.jp>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.4 305/312] bridge: Fix problems around fdb entries pointing to the bridge device
Date:   Fri,  8 May 2020 14:34:56 +0200
Message-Id: <20200508123145.927040915@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200508123124.574959822@linuxfoundation.org>
References: <20200508123124.574959822@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Toshiaki Makita <makita.toshiaki@lab.ntt.co.jp>

commit 7bb90c3715a496c650b2e879225030f9dd9cfafb upstream.

Adding fdb entries pointing to the bridge device uses fdb_insert(),
which lacks various checks and does not respect added_by_user flag.

As a result, some inconsistent behavior can happen:
* Adding temporary entries succeeds but results in permanent entries.
* Same goes for "dynamic" and "use".
* Changing mac address of the bridge device causes deletion of
  user-added entries.
* Replacing existing entries looks successful from userspace but actually
  not, regardless of NLM_F_EXCL flag.

Use the same logic as other entries and fix them.

Fixes: 3741873b4f73 ("bridge: allow adding of fdb entries pointing to the bridge device")
Signed-off-by: Toshiaki Makita <makita.toshiaki@lab.ntt.co.jp>
Acked-by: Roopa Prabhu <roopa@cumulusnetworks.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/bridge/br_fdb.c |   52 +++++++++++++++++++++++++++-------------------------
 1 file changed, 27 insertions(+), 25 deletions(-)

--- a/net/bridge/br_fdb.c
+++ b/net/bridge/br_fdb.c
@@ -266,7 +266,7 @@ void br_fdb_change_mac_address(struct ne
 
 	/* If old entry was unassociated with any port, then delete it. */
 	f = __br_fdb_get(br, br->dev->dev_addr, 0);
-	if (f && f->is_local && !f->dst)
+	if (f && f->is_local && !f->dst && !f->added_by_user)
 		fdb_delete_local(br, NULL, f);
 
 	fdb_insert(br, NULL, newaddr, 0);
@@ -281,7 +281,7 @@ void br_fdb_change_mac_address(struct ne
 		if (!br_vlan_should_use(v))
 			continue;
 		f = __br_fdb_get(br, br->dev->dev_addr, v->vid);
-		if (f && f->is_local && !f->dst)
+		if (f && f->is_local && !f->dst && !f->added_by_user)
 			fdb_delete_local(br, NULL, f);
 		fdb_insert(br, NULL, newaddr, v->vid);
 	}
@@ -758,20 +758,25 @@ out:
 }
 
 /* Update (create or replace) forwarding database entry */
-static int fdb_add_entry(struct net_bridge_port *source, const __u8 *addr,
-			 __u16 state, __u16 flags, __u16 vid)
+static int fdb_add_entry(struct net_bridge *br, struct net_bridge_port *source,
+			 const __u8 *addr, __u16 state, __u16 flags, __u16 vid)
 {
-	struct net_bridge *br = source->br;
 	struct hlist_head *head = &br->hash[br_mac_hash(addr, vid)];
 	struct net_bridge_fdb_entry *fdb;
 	bool modified = false;
 
 	/* If the port cannot learn allow only local and static entries */
-	if (!(state & NUD_PERMANENT) && !(state & NUD_NOARP) &&
+	if (source && !(state & NUD_PERMANENT) && !(state & NUD_NOARP) &&
 	    !(source->state == BR_STATE_LEARNING ||
 	      source->state == BR_STATE_FORWARDING))
 		return -EPERM;
 
+	if (!source && !(state & NUD_PERMANENT)) {
+		pr_info("bridge: RTM_NEWNEIGH %s without NUD_PERMANENT\n",
+			br->dev->name);
+		return -EINVAL;
+	}
+
 	fdb = fdb_find(head, addr, vid);
 	if (fdb == NULL) {
 		if (!(flags & NLM_F_CREATE))
@@ -826,22 +831,28 @@ static int fdb_add_entry(struct net_brid
 	return 0;
 }
 
-static int __br_fdb_add(struct ndmsg *ndm, struct net_bridge_port *p,
-	       const unsigned char *addr, u16 nlh_flags, u16 vid)
+static int __br_fdb_add(struct ndmsg *ndm, struct net_bridge *br,
+			struct net_bridge_port *p, const unsigned char *addr,
+			u16 nlh_flags, u16 vid)
 {
 	int err = 0;
 
 	if (ndm->ndm_flags & NTF_USE) {
+		if (!p) {
+			pr_info("bridge: RTM_NEWNEIGH %s with NTF_USE is not supported\n",
+				br->dev->name);
+			return -EINVAL;
+		}
 		local_bh_disable();
 		rcu_read_lock();
-		br_fdb_update(p->br, p, addr, vid, true);
+		br_fdb_update(br, p, addr, vid, true);
 		rcu_read_unlock();
 		local_bh_enable();
 	} else {
-		spin_lock_bh(&p->br->hash_lock);
-		err = fdb_add_entry(p, addr, ndm->ndm_state,
+		spin_lock_bh(&br->hash_lock);
+		err = fdb_add_entry(br, p, addr, ndm->ndm_state,
 				    nlh_flags, vid);
-		spin_unlock_bh(&p->br->hash_lock);
+		spin_unlock_bh(&br->hash_lock);
 	}
 
 	return err;
@@ -878,6 +889,7 @@ int br_fdb_add(struct ndmsg *ndm, struct
 				dev->name);
 			return -EINVAL;
 		}
+		br = p->br;
 		vg = nbp_vlan_group(p);
 	}
 
@@ -889,15 +901,9 @@ int br_fdb_add(struct ndmsg *ndm, struct
 		}
 
 		/* VID was specified, so use it. */
-		if (dev->priv_flags & IFF_EBRIDGE)
-			err = br_fdb_insert(br, NULL, addr, vid);
-		else
-			err = __br_fdb_add(ndm, p, addr, nlh_flags, vid);
+		err = __br_fdb_add(ndm, br, p, addr, nlh_flags, vid);
 	} else {
-		if (dev->priv_flags & IFF_EBRIDGE)
-			err = br_fdb_insert(br, NULL, addr, 0);
-		else
-			err = __br_fdb_add(ndm, p, addr, nlh_flags, 0);
+		err = __br_fdb_add(ndm, br, p, addr, nlh_flags, 0);
 		if (err || !vg || !vg->num_vlans)
 			goto out;
 
@@ -908,11 +914,7 @@ int br_fdb_add(struct ndmsg *ndm, struct
 		list_for_each_entry(v, &vg->vlan_list, vlist) {
 			if (!br_vlan_should_use(v))
 				continue;
-			if (dev->priv_flags & IFF_EBRIDGE)
-				err = br_fdb_insert(br, NULL, addr, v->vid);
-			else
-				err = __br_fdb_add(ndm, p, addr, nlh_flags,
-						   v->vid);
+			err = __br_fdb_add(ndm, br, p, addr, nlh_flags, v->vid);
 			if (err)
 				goto out;
 		}


