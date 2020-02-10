Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BC58A1577A0
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 14:02:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728383AbgBJNBX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 08:01:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:41670 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729819AbgBJMkw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:40:52 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BE2A424649;
        Mon, 10 Feb 2020 12:40:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338451;
        bh=wfhldRfpw6pM2pN4pyuGtEyqB7dfoNUAfga4gO1dHTM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=L72Sm8FNUgyJKCA0heVQRgctvnm9fZTz1Yx4LJT+vJtsM9wQzExjlMZc8Vgz6YwdD
         ZsyaBTdm1/85875J6nBaNnz7H7T5ipDw1zu/4IhZ6+HFVlM0lDIs4VFsDCPLdgPOXx
         nt1yLmCZdyyseWwcvMw1UC2bG+w31SRGiBy5s+V4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Yoshiki Komachi <komachi.yoshiki@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Petar Penkov <ppenkov@google.com>,
        John Fastabend <john.fastabend@gmail.com>
Subject: [PATCH 5.5 162/367] flow_dissector: Fix to use new variables for port ranges in bpf hook
Date:   Mon, 10 Feb 2020 04:31:15 -0800
Message-Id: <20200210122439.777788779@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210122423.695146547@linuxfoundation.org>
References: <20200210122423.695146547@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yoshiki Komachi <komachi.yoshiki@gmail.com>

commit 59fb9b62fb6c929a756563152a89f39b07cf8893 upstream.

This patch applies new flag (FLOW_DISSECTOR_KEY_PORTS_RANGE) and
field (tp_range) to BPF flow dissector to generate appropriate flow
keys when classified by specified port ranges.

Fixes: 8ffb055beae5 ("cls_flower: Fix the behavior using port ranges with hw-offload")
Signed-off-by: Yoshiki Komachi <komachi.yoshiki@gmail.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Petar Penkov <ppenkov@google.com>
Acked-by: John Fastabend <john.fastabend@gmail.com>
Link: https://lore.kernel.org/bpf/20200117070533.402240-2-komachi.yoshiki@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/core/flow_dissector.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

--- a/net/core/flow_dissector.c
+++ b/net/core/flow_dissector.c
@@ -834,10 +834,10 @@ static void __skb_flow_bpf_to_target(con
 				     struct flow_dissector *flow_dissector,
 				     void *target_container)
 {
+	struct flow_dissector_key_ports *key_ports = NULL;
 	struct flow_dissector_key_control *key_control;
 	struct flow_dissector_key_basic *key_basic;
 	struct flow_dissector_key_addrs *key_addrs;
-	struct flow_dissector_key_ports *key_ports;
 	struct flow_dissector_key_tags *key_tags;
 
 	key_control = skb_flow_dissector_target(flow_dissector,
@@ -876,10 +876,17 @@ static void __skb_flow_bpf_to_target(con
 		key_control->addr_type = FLOW_DISSECTOR_KEY_IPV6_ADDRS;
 	}
 
-	if (dissector_uses_key(flow_dissector, FLOW_DISSECTOR_KEY_PORTS)) {
+	if (dissector_uses_key(flow_dissector, FLOW_DISSECTOR_KEY_PORTS))
 		key_ports = skb_flow_dissector_target(flow_dissector,
 						      FLOW_DISSECTOR_KEY_PORTS,
 						      target_container);
+	else if (dissector_uses_key(flow_dissector,
+				    FLOW_DISSECTOR_KEY_PORTS_RANGE))
+		key_ports = skb_flow_dissector_target(flow_dissector,
+						      FLOW_DISSECTOR_KEY_PORTS_RANGE,
+						      target_container);
+
+	if (key_ports) {
 		key_ports->src = flow_keys->sport;
 		key_ports->dst = flow_keys->dport;
 	}


