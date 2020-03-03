Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0332C177EB1
	for <lists+stable@lfdr.de>; Tue,  3 Mar 2020 19:56:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731043AbgCCRqD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Mar 2020 12:46:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:52366 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731041AbgCCRqA (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Mar 2020 12:46:00 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 564CB20842;
        Tue,  3 Mar 2020 17:45:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583257559;
        bh=VqD6tVyfBbHhJji5Ia9DK3sC5AXzCUx+LUQ1GvO/2VQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o9PgyIB8JEtRAQ5nSih+Q031Zx/uJp1o5GwCVaGet0aVX8gfW7AorV3M1SfCb6HK8
         z80cXvsMckIjfgcnpN4hMfZxDKHNnR8CVvuTiP4wcn+LRSNfs8d60mZl7duG3bN64m
         1RWHBHm2TvLKLlKK/VN119Q8oKUayRjVVnUPKblg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jason Baron <jbaron@akamai.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.5 007/176] net: sched: correct flower port blocking
Date:   Tue,  3 Mar 2020 18:41:11 +0100
Message-Id: <20200303174305.408899758@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200303174304.593872177@linuxfoundation.org>
References: <20200303174304.593872177@linuxfoundation.org>
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
@@ -5,6 +5,7 @@
 #include <linux/types.h>
 #include <linux/in6.h>
 #include <linux/siphash.h>
+#include <linux/string.h>
 #include <uapi/linux/if_ether.h>
 
 struct sk_buff;
@@ -349,4 +350,12 @@ struct bpf_flow_dissector {
 	void			*data_end;
 };
 
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
@@ -305,6 +305,7 @@ static int fl_classify(struct sk_buff *s
 	struct cls_fl_filter *f;
 
 	list_for_each_entry_rcu(mask, &head->masks, list) {
+		flow_dissector_init_keys(&skb_key.control, &skb_key.basic);
 		fl_clear_masked_range(&skb_key, mask);
 
 		skb_flow_dissect_meta(skb, &mask->dissector, &skb_key);


