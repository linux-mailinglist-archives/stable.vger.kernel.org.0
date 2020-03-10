Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 99C9817F811
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 13:44:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727816AbgCJMou (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 08:44:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:47216 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727510AbgCJMou (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Mar 2020 08:44:50 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4AB052469C;
        Tue, 10 Mar 2020 12:44:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583844289;
        bh=6f4CC+7DtzfHuMV7HiHoLiTh2Xkc0Zf5JXFBByFdpKs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SzhdjOwj5rMdmaO1rGZ0SiQmnBlPACSIYM9IOxCs4rg0aqIDbVyK5uN8S2fMvFno7
         VGAhu/CIlLOJBrRZfYl88BJs9KMozhhBr/61Qz50LwLjZjWk9798fvS76N+bU45Tur
         qq761qnJtuyI+cYG5i6JFFV6WTLJPYlC+58b8Uh8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jason Baron <jbaron@akamai.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.9 27/88] net: sched: correct flower port blocking
Date:   Tue, 10 Mar 2020 13:38:35 +0100
Message-Id: <20200310123612.459015874@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200310123606.543939933@linuxfoundation.org>
References: <20200310123606.543939933@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jason Baron <jbaron@akamai.com>

[ Upstream commit 8a9093c79863b58cc2f9874d7ae788f0d622a596 ]

tc flower rules that are based on src or dst port blocking are sometimes
ineffective due to uninitialized stack data. __skb_flow_dissect() extracts
ports from the skb for tc flower to match against. However, the port
dissection is not done when when the FLOW_DIS_IS_FRAGMENT bit is set in
key_control->flags. All callers of __skb_flow_dissect(), zero-out the
key_control field except for fl_classify() as used by the flower
classifier. Thus, the FLOW_DIS_IS_FRAGMENT may be set on entry to
__skb_flow_dissect(), since key_control is allocated on the stack
and may not be initialized.

Since key_basic and key_control are present for all flow keys, let's
make sure they are initialized.

Fixes: 62230715fd24 ("flow_dissector: do not dissect l4 ports for fragments")
Co-developed-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Acked-by: Cong Wang <xiyou.wangcong@gmail.com>
Signed-off-by: Jason Baron <jbaron@akamai.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/flow_dissector.h |    9 +++++++++
 net/sched/cls_flower.c       |    1 +
 2 files changed, 10 insertions(+)

--- a/include/net/flow_dissector.h
+++ b/include/net/flow_dissector.h
@@ -4,6 +4,7 @@
 #include <linux/types.h>
 #include <linux/in6.h>
 #include <linux/siphash.h>
+#include <linux/string.h>
 #include <uapi/linux/if_ether.h>
 
 /**
@@ -204,4 +205,12 @@ static inline void *skb_flow_dissector_t
 	return ((char *)target_container) + flow_dissector->offset[key_id];
 }
 
+static inline void
+flow_dissector_init_keys(struct flow_dissector_key_control *key_control,
+			 struct flow_dissector_key_basic *key_basic)
+{
+	memset(key_control, 0, sizeof(*key_control));
+	memset(key_basic, 0, sizeof(*key_basic));
+}
+
 #endif
--- a/net/sched/cls_flower.c
+++ b/net/sched/cls_flower.c
@@ -141,6 +141,7 @@ static int fl_classify(struct sk_buff *s
 	if (!atomic_read(&head->ht.nelems))
 		return -1;
 
+	flow_dissector_init_keys(&skb_key.control, &skb_key.basic);
 	fl_clear_masked_range(&skb_key, &head->mask);
 
 	info = skb_tunnel_info(skb);


