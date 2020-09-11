Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E4AD266201
	for <lists+stable@lfdr.de>; Fri, 11 Sep 2020 17:21:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725918AbgIKPVW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Sep 2020 11:21:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:53922 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726464AbgIKPTJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 11 Sep 2020 11:19:09 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8038F22211;
        Fri, 11 Sep 2020 13:00:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599829218;
        bh=RsCwXletKW4lIzX+X2x9ZKwExmHSFoe5t2j69j9uCbo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SXwBcstQ7Rx7Jhg/rAZU+A49Lo5J+dMRufLKxyZw9tiGoUWVHUorfFWgWxVFw+GB6
         Nf+i7yzFmmp7i6/ydSaE1RQiu08g7ecYwTV30Vc6IOwjTB+z69hhX+ddMICKvXETYe
         pF+RD3UAzLneb5zSU+UiJ6MkYkG1O8kfIGHZ+K2s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Stephen Smalley <stephen.smalley.work@gmail.com>,
        Paul Moore <paul@paul-moore.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 3/8] netlabel: fix problems with mapping removal
Date:   Fri, 11 Sep 2020 14:54:41 +0200
Message-Id: <20200911125420.748103183@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200911125420.580564179@linuxfoundation.org>
References: <20200911125420.580564179@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paul Moore <paul@paul-moore.com>

[ Upstream commit d3b990b7f327e2afa98006e7666fb8ada8ed8683 ]

This patch fixes two main problems seen when removing NetLabel
mappings: memory leaks and potentially extra audit noise.

The memory leaks are caused by not properly free'ing the mapping's
address selector struct when free'ing the entire entry as well as
not properly cleaning up a temporary mapping entry when adding new
address selectors to an existing entry.  This patch fixes both these
problems such that kmemleak reports no NetLabel associated leaks
after running the SELinux test suite.

The potentially extra audit noise was caused by the auditing code in
netlbl_domhsh_remove_entry() being called regardless of the entry's
validity.  If another thread had already marked the entry as invalid,
but not removed/free'd it from the list of mappings, then it was
possible that an additional mapping removal audit record would be
generated.  This patch fixes this by returning early from the removal
function when the entry was previously marked invalid.  This change
also had the side benefit of improving the code by decreasing the
indentation level of large chunk of code by one (accounting for most
of the diffstat).

Fixes: 63c416887437 ("netlabel: Add network address selectors to the NetLabel/LSM domain mapping")
Reported-by: Stephen Smalley <stephen.smalley.work@gmail.com>
Signed-off-by: Paul Moore <paul@paul-moore.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netlabel/netlabel_domainhash.c |   59 ++++++++++++++++++-------------------
 1 file changed, 30 insertions(+), 29 deletions(-)

--- a/net/netlabel/netlabel_domainhash.c
+++ b/net/netlabel/netlabel_domainhash.c
@@ -85,6 +85,7 @@ static void netlbl_domhsh_free_entry(str
 			kfree(netlbl_domhsh_addr6_entry(iter6));
 		}
 #endif /* IPv6 */
+		kfree(ptr->def.addrsel);
 	}
 	kfree(ptr->domain);
 	kfree(ptr);
@@ -536,6 +537,8 @@ int netlbl_domhsh_add(struct netlbl_dom_
 				goto add_return;
 		}
 #endif /* IPv6 */
+		/* cleanup the new entry since we've moved everything over */
+		netlbl_domhsh_free_entry(&entry->rcu);
 	} else
 		ret_val = -EINVAL;
 
@@ -579,6 +582,12 @@ int netlbl_domhsh_remove_entry(struct ne
 {
 	int ret_val = 0;
 	struct audit_buffer *audit_buf;
+	struct netlbl_af4list *iter4;
+	struct netlbl_domaddr4_map *map4;
+#if IS_ENABLED(CONFIG_IPV6)
+	struct netlbl_af6list *iter6;
+	struct netlbl_domaddr6_map *map6;
+#endif /* IPv6 */
 
 	if (entry == NULL)
 		return -ENOENT;
@@ -596,6 +605,9 @@ int netlbl_domhsh_remove_entry(struct ne
 		ret_val = -ENOENT;
 	spin_unlock(&netlbl_domhsh_lock);
 
+	if (ret_val)
+		return ret_val;
+
 	audit_buf = netlbl_audit_start_common(AUDIT_MAC_MAP_DEL, audit_info);
 	if (audit_buf != NULL) {
 		audit_log_format(audit_buf,
@@ -605,40 +617,29 @@ int netlbl_domhsh_remove_entry(struct ne
 		audit_log_end(audit_buf);
 	}
 
-	if (ret_val == 0) {
-		struct netlbl_af4list *iter4;
-		struct netlbl_domaddr4_map *map4;
-#if IS_ENABLED(CONFIG_IPV6)
-		struct netlbl_af6list *iter6;
-		struct netlbl_domaddr6_map *map6;
-#endif /* IPv6 */
-
-		switch (entry->def.type) {
-		case NETLBL_NLTYPE_ADDRSELECT:
-			netlbl_af4list_foreach_rcu(iter4,
-					     &entry->def.addrsel->list4) {
-				map4 = netlbl_domhsh_addr4_entry(iter4);
-				cipso_v4_doi_putdef(map4->def.cipso);
-			}
+	switch (entry->def.type) {
+	case NETLBL_NLTYPE_ADDRSELECT:
+		netlbl_af4list_foreach_rcu(iter4, &entry->def.addrsel->list4) {
+			map4 = netlbl_domhsh_addr4_entry(iter4);
+			cipso_v4_doi_putdef(map4->def.cipso);
+		}
 #if IS_ENABLED(CONFIG_IPV6)
-			netlbl_af6list_foreach_rcu(iter6,
-					     &entry->def.addrsel->list6) {
-				map6 = netlbl_domhsh_addr6_entry(iter6);
-				calipso_doi_putdef(map6->def.calipso);
-			}
+		netlbl_af6list_foreach_rcu(iter6, &entry->def.addrsel->list6) {
+			map6 = netlbl_domhsh_addr6_entry(iter6);
+			calipso_doi_putdef(map6->def.calipso);
+		}
 #endif /* IPv6 */
-			break;
-		case NETLBL_NLTYPE_CIPSOV4:
-			cipso_v4_doi_putdef(entry->def.cipso);
-			break;
+		break;
+	case NETLBL_NLTYPE_CIPSOV4:
+		cipso_v4_doi_putdef(entry->def.cipso);
+		break;
 #if IS_ENABLED(CONFIG_IPV6)
-		case NETLBL_NLTYPE_CALIPSO:
-			calipso_doi_putdef(entry->def.calipso);
-			break;
+	case NETLBL_NLTYPE_CALIPSO:
+		calipso_doi_putdef(entry->def.calipso);
+		break;
 #endif /* IPv6 */
-		}
-		call_rcu(&entry->rcu, netlbl_domhsh_free_entry);
 	}
+	call_rcu(&entry->rcu, netlbl_domhsh_free_entry);
 
 	return ret_val;
 }


