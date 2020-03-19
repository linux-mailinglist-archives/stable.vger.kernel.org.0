Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 58EC418B41E
	for <lists+stable@lfdr.de>; Thu, 19 Mar 2020 14:07:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727770AbgCSNGy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Mar 2020 09:06:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:50330 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727783AbgCSNGx (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Mar 2020 09:06:53 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D3D9B20776;
        Thu, 19 Mar 2020 13:06:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584623213;
        bh=gyq2qv5W8EFBR/5uvjB7BlKDFoFR5pmtfN9IX40b4pU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1LIV9EWd91X1cEYe4NvA9RRpu+Mmfv8fusgfxL7zBsOVq+kdzMR0Z0PLf/GloF81A
         fc0AO40NAYAVw5qUVa/2I+T+DVskgQnURHNeeZddU0tgv4oPtbGhx+zsaahSjqbQSc
         LAumKi2dEQh8Ic/MexkW+B9pmXzsfmHNQZN706sM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sven Eckelmann <sven@narfation.org>,
        Marek Lindner <mareklindner@neomailbox.ch>,
        Antonio Quartulli <a@unstable.cc>
Subject: [PATCH 4.4 46/93] batman-adv: Drop reference to netdevice on last reference
Date:   Thu, 19 Mar 2020 13:59:50 +0100
Message-Id: <20200319123939.625583196@linuxfoundation.org>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <20200319123924.795019515@linuxfoundation.org>
References: <20200319123924.795019515@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sven Eckelmann <sven@narfation.org>

commit 140ed8e87ca8f4875c2b146cdb2cdbf0c9ac6080 upstream.

The references to the network device should be dropped inside the release
function for batadv_hard_iface similar to what is done with the batman-adv
internal datastructures.

Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Marek Lindner <mareklindner@neomailbox.ch>
Signed-off-by: Antonio Quartulli <a@unstable.cc>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/batman-adv/hard-interface.c |   13 ++++++++-----
 net/batman-adv/hard-interface.h |    6 +++---
 2 files changed, 11 insertions(+), 8 deletions(-)

--- a/net/batman-adv/hard-interface.c
+++ b/net/batman-adv/hard-interface.c
@@ -45,13 +45,16 @@
 #include "sysfs.h"
 #include "translation-table.h"
 
-void batadv_hardif_free_rcu(struct rcu_head *rcu)
+/**
+ * batadv_hardif_release - release hard interface from lists and queue for
+ *  free after rcu grace period
+ * @hard_iface: the hard interface to free
+ */
+void batadv_hardif_release(struct batadv_hard_iface *hard_iface)
 {
-	struct batadv_hard_iface *hard_iface;
-
-	hard_iface = container_of(rcu, struct batadv_hard_iface, rcu);
 	dev_put(hard_iface->net_dev);
-	kfree(hard_iface);
+
+	kfree_rcu(hard_iface, rcu);
 }
 
 struct batadv_hard_iface *
--- a/net/batman-adv/hard-interface.h
+++ b/net/batman-adv/hard-interface.h
@@ -61,18 +61,18 @@ void batadv_hardif_disable_interface(str
 void batadv_hardif_remove_interfaces(void);
 int batadv_hardif_min_mtu(struct net_device *soft_iface);
 void batadv_update_min_mtu(struct net_device *soft_iface);
-void batadv_hardif_free_rcu(struct rcu_head *rcu);
+void batadv_hardif_release(struct batadv_hard_iface *hard_iface);
 
 /**
  * batadv_hardif_free_ref - decrement the hard interface refcounter and
- *  possibly free it
+ *  possibly release it
  * @hard_iface: the hard interface to free
  */
 static inline void
 batadv_hardif_free_ref(struct batadv_hard_iface *hard_iface)
 {
 	if (atomic_dec_and_test(&hard_iface->refcount))
-		call_rcu(&hard_iface->rcu, batadv_hardif_free_rcu);
+		batadv_hardif_release(hard_iface);
 }
 
 static inline struct batadv_hard_iface *


