Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A3C96895A4
	for <lists+stable@lfdr.de>; Fri,  3 Feb 2023 11:24:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233441AbjBCKXL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Feb 2023 05:23:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233452AbjBCKXB (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Feb 2023 05:23:01 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A90749039A
        for <stable@vger.kernel.org>; Fri,  3 Feb 2023 02:22:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 57B3FB8287A
        for <stable@vger.kernel.org>; Fri,  3 Feb 2023 10:22:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 921B9C433EF;
        Fri,  3 Feb 2023 10:22:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675419758;
        bh=Ia+CmyL4tgPspavrsr98FCV3Q0uMEyNRjnGqumBjqSs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sBYJlDLMQWP2MXE45iHS08kjfyI+//hsDq8kOCas1zcZKYo6mTbLmNX2tlZlKXdsz
         3TSs+m13hPCaDtPJjohtuC7Elnm+mYJgsSe86SGSatl4M31K1kp4scnrOjBPdb9nP9
         mX6Gv4sCQ07VYi1g0UREx3QseLVUWyG4auDBRc/s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Daniel Borkmann <daniel@iogearbox.net>,
        Willem de Bruijn <willemb@google.com>,
        Yan Zhai <yan@cloudflare.com>, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 26/28] net: fix NULL pointer in skb_segment_list
Date:   Fri,  3 Feb 2023 11:13:14 +0100
Message-Id: <20230203101011.064311051@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230203101009.946745030@linuxfoundation.org>
References: <20230203101009.946745030@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yan Zhai <yan@cloudflare.com>

commit 876e8ca8366735a604bac86ff7e2732fc9d85d2d upstream.

Commit 3a1296a38d0c ("net: Support GRO/GSO fraglist chaining.")
introduced UDP listifyed GRO. The segmentation relies on frag_list being
untouched when passing through the network stack. This assumption can be
broken sometimes, where frag_list itself gets pulled into linear area,
leaving frag_list being NULL. When this happens it can trigger
following NULL pointer dereference, and panic the kernel. Reverse the
test condition should fix it.

[19185.577801][    C1] BUG: kernel NULL pointer dereference, address:
...
[19185.663775][    C1] RIP: 0010:skb_segment_list+0x1cc/0x390
...
[19185.834644][    C1] Call Trace:
[19185.841730][    C1]  <TASK>
[19185.848563][    C1]  __udp_gso_segment+0x33e/0x510
[19185.857370][    C1]  inet_gso_segment+0x15b/0x3e0
[19185.866059][    C1]  skb_mac_gso_segment+0x97/0x110
[19185.874939][    C1]  __skb_gso_segment+0xb2/0x160
[19185.883646][    C1]  udp_queue_rcv_skb+0xc3/0x1d0
[19185.892319][    C1]  udp_unicast_rcv_skb+0x75/0x90
[19185.900979][    C1]  ip_protocol_deliver_rcu+0xd2/0x200
[19185.910003][    C1]  ip_local_deliver_finish+0x44/0x60
[19185.918757][    C1]  __netif_receive_skb_one_core+0x8b/0xa0
[19185.927834][    C1]  process_backlog+0x88/0x130
[19185.935840][    C1]  __napi_poll+0x27/0x150
[19185.943447][    C1]  net_rx_action+0x27e/0x5f0
[19185.951331][    C1]  ? mlx5_cq_tasklet_cb+0x70/0x160 [mlx5_core]
[19185.960848][    C1]  __do_softirq+0xbc/0x25d
[19185.968607][    C1]  irq_exit_rcu+0x83/0xb0
[19185.976247][    C1]  common_interrupt+0x43/0xa0
[19185.984235][    C1]  asm_common_interrupt+0x22/0x40
...
[19186.094106][    C1]  </TASK>

Fixes: 3a1296a38d0c ("net: Support GRO/GSO fraglist chaining.")
Suggested-by: Daniel Borkmann <daniel@iogearbox.net>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Signed-off-by: Yan Zhai <yan@cloudflare.com>
Acked-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/r/Y9gt5EUizK1UImEP@debian
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/skbuff.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -4034,7 +4034,7 @@ struct sk_buff *skb_segment_list(struct
 
 	skb_shinfo(skb)->frag_list = NULL;
 
-	do {
+	while (list_skb) {
 		nskb = list_skb;
 		list_skb = list_skb->next;
 
@@ -4080,8 +4080,7 @@ struct sk_buff *skb_segment_list(struct
 		if (skb_needs_linearize(nskb, features) &&
 		    __skb_linearize(nskb))
 			goto err_linearize;
-
-	} while (list_skb);
+	}
 
 	skb->truesize = skb->truesize - delta_truesize;
 	skb->data_len = skb->data_len - delta_len;


