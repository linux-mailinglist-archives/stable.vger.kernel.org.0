Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EAC5B17FE98
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 14:36:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727422AbgCJMms (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 08:42:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:42910 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726852AbgCJMms (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Mar 2020 08:42:48 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C81A024691;
        Tue, 10 Mar 2020 12:42:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583844167;
        bh=cZrAmHjCe8NP1D5OxQgTIDbVoTdCtdq5vWJnyUDPexQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LavpQu43zPQA0xoNJxMEZ5lCpcBcN9vcBLUd/+wBOWy749RkiePPek4ba1e84Tyrq
         2Ex8e5VsBBmYjUMoo/AoVs1LSH7GXPzIkCcJYcQH2fW3uGfk4pxKabxkNEyaFMJfgt
         yTb0Mz9Phnx2tfHJ/yCUpfHbXsdT9bTsUPPBCS7U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jason Baron <jbaron@akamai.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.4 18/72] net: sched: correct flower port blocking
Date:   Tue, 10 Mar 2020 13:38:31 +0100
Message-Id: <20200310123606.030775417@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200310123601.053680753@linuxfoundation.org>
References: <20200310123601.053680753@linuxfoundation.org>
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
@@ -185,4 +186,12 @@ static inline bool flow_keys_have_l4(str
 
 u32 flow_hash_from_keys(struct flow_keys *keys);
 
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
@@ -127,6 +127,7 @@ static int fl_classify(struct sk_buff *s
 	struct fl_flow_key skb_key;
 	struct fl_flow_key skb_mkey;
 
+	flow_dissector_init_keys(&skb_key.control, &skb_key.basic);
 	fl_clear_masked_range(&skb_key, &head->mask);
 	skb_key.indev_ifindex = skb->skb_iif;
 	/* skb_flow_dissect() does not set n_proto in case an unknown protocol,


