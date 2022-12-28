Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2EFC657DE4
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:48:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234042AbiL1Prr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:47:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234048AbiL1Prp (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:47:45 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19B5C1788D
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:47:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BF8E4B81733
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:47:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3881CC433F1;
        Wed, 28 Dec 2022 15:47:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672242461;
        bh=elHQyZ+au7sMQMRDh8flbJBbGu9ukpqDB/XJj3R5lL8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BOV78Q37krXLKE0KfH+cuhvxo39TuQai7+7AMyUvZpnDb3Gg2D7M9YAffwrLKjxdS
         7FFPhMKoYQYV8a5z5tPNSPmFX+awgmep78io/LFu1VSp1zsYcy1kCJ12KqbwuqAGZr
         C9zwKq1taI8lbIht/nB/gZNNS+6bZnENy9BQ3AoU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Sean Tranchetti <quic_stranche@quicinc.com>,
        Subash Abhinov Kasiviswanathan <quic_subashab@quicinc.com>,
        Alexander Duyck <alexanderduyck@fb.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 606/731] skbuff: Account for tail adjustment during pull operations
Date:   Wed, 28 Dec 2022 15:41:53 +0100
Message-Id: <20221228144314.106624682@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
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

From: Subash Abhinov Kasiviswanathan <quic_subashab@quicinc.com>

[ Upstream commit 2d7afdcbc9d32423f177ee12b7c93783aea338fb ]

Extending the tail can have some unexpected side effects if a program uses
a helper like BPF_FUNC_skb_pull_data to read partial content beyond the
head skb headlen when all the skbs in the gso frag_list are linear with no
head_frag -

  kernel BUG at net/core/skbuff.c:4219!
  pc : skb_segment+0xcf4/0xd2c
  lr : skb_segment+0x63c/0xd2c
  Call trace:
   skb_segment+0xcf4/0xd2c
   __udp_gso_segment+0xa4/0x544
   udp4_ufo_fragment+0x184/0x1c0
   inet_gso_segment+0x16c/0x3a4
   skb_mac_gso_segment+0xd4/0x1b0
   __skb_gso_segment+0xcc/0x12c
   udp_rcv_segment+0x54/0x16c
   udp_queue_rcv_skb+0x78/0x144
   udp_unicast_rcv_skb+0x8c/0xa4
   __udp4_lib_rcv+0x490/0x68c
   udp_rcv+0x20/0x30
   ip_protocol_deliver_rcu+0x1b0/0x33c
   ip_local_deliver+0xd8/0x1f0
   ip_rcv+0x98/0x1a4
   deliver_ptype_list_skb+0x98/0x1ec
   __netif_receive_skb_core+0x978/0xc60

Fix this by marking these skbs as GSO_DODGY so segmentation can handle
the tail updates accordingly.

Fixes: 3dcbdb134f32 ("net: gso: Fix skb_segment splat when splitting gso_size mangled skb having linear-headed frag_list")
Signed-off-by: Sean Tranchetti <quic_stranche@quicinc.com>
Signed-off-by: Subash Abhinov Kasiviswanathan <quic_subashab@quicinc.com>
Reviewed-by: Alexander Duyck <alexanderduyck@fb.com>
Link: https://lore.kernel.org/r/1671084718-24796-1-git-send-email-quic_subashab@quicinc.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/skbuff.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 6706bd3c8e9c..058ec2f17da6 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -2263,6 +2263,9 @@ void *__pskb_pull_tail(struct sk_buff *skb, int delta)
 				insp = list;
 			} else {
 				/* Eaten partially. */
+				if (skb_is_gso(skb) && !list->head_frag &&
+				    skb_headlen(list))
+					skb_shinfo(skb)->gso_type |= SKB_GSO_DODGY;
 
 				if (skb_shared(list)) {
 					/* Sucks! We need to fork list. :-( */
-- 
2.35.1



