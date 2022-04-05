Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86ABD4F2BB9
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 13:21:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239143AbiDEIof (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:44:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241242AbiDEIc5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:32:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2194B60C0;
        Tue,  5 Apr 2022 01:30:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B5469609D0;
        Tue,  5 Apr 2022 08:30:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C60E7C385A2;
        Tue,  5 Apr 2022 08:30:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649147421;
        bh=1Y2tJszXJ8mM7Vg/4Mf9uvXQFr8vz3unAZ/gygB5MPE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u8O0iZ6HwKLwArFzvZpIADIFG7eABKrKMmn0CkYYH3ula8pQT7Mxd0NvIqG9sSavJ
         G+dOZP0TfsFswDO4uCbqWEvn0FVQBED0wT7QZenlgEkUbatQ0kmLD6DvKKtWDF+tKO
         4JO3NHPKt1OMW25Q/tTxSIO5j9S6ebA5jZQ/YOuw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Martin Varghese <martin.varghese@nokia.com>,
        Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 5.17 1117/1126] openvswitch: Fixed nd target mask field in the flow dump.
Date:   Tue,  5 Apr 2022 09:31:04 +0200
Message-Id: <20220405070440.216919630@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Martin Varghese <martin.varghese@nokia.com>

commit f19c44452b58a84d95e209b847f5495d91c9983a upstream.

IPv6 nd target mask was not getting populated in flow dump.

In the function __ovs_nla_put_key the icmp code mask field was checked
instead of icmp code key field to classify the flow as neighbour discovery.

ufid:bdfbe3e5-60c2-43b0-a5ff-dfcac1c37328, recirc_id(0),dp_hash(0/0),
skb_priority(0/0),in_port(ovs-nm1),skb_mark(0/0),ct_state(0/0),
ct_zone(0/0),ct_mark(0/0),ct_label(0/0),
eth(src=00:00:00:00:00:00/00:00:00:00:00:00,
dst=00:00:00:00:00:00/00:00:00:00:00:00),
eth_type(0x86dd),
ipv6(src=::/::,dst=::/::,label=0/0,proto=58,tclass=0/0,hlimit=0/0,frag=no),
icmpv6(type=135,code=0),
nd(target=2001::2/::,
sll=00:00:00:00:00:00/00:00:00:00:00:00,
tll=00:00:00:00:00:00/00:00:00:00:00:00),
packets:10, bytes:860, used:0.504s, dp:ovs, actions:ovs-nm2

Fixes: e64457191a25 (openvswitch: Restructure datapath.c and flow.c)
Signed-off-by: Martin Varghese <martin.varghese@nokia.com>
Link: https://lore.kernel.org/r/20220328054148.3057-1-martinvarghesenokia@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/openvswitch/flow_netlink.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/net/openvswitch/flow_netlink.c
+++ b/net/openvswitch/flow_netlink.c
@@ -2201,8 +2201,8 @@ static int __ovs_nla_put_key(const struc
 			icmpv6_key->icmpv6_type = ntohs(output->tp.src);
 			icmpv6_key->icmpv6_code = ntohs(output->tp.dst);
 
-			if (icmpv6_key->icmpv6_type == NDISC_NEIGHBOUR_SOLICITATION ||
-			    icmpv6_key->icmpv6_type == NDISC_NEIGHBOUR_ADVERTISEMENT) {
+			if (swkey->tp.src == htons(NDISC_NEIGHBOUR_SOLICITATION) ||
+			    swkey->tp.src == htons(NDISC_NEIGHBOUR_ADVERTISEMENT)) {
 				struct ovs_key_nd *nd_key;
 
 				nla = nla_reserve(skb, OVS_KEY_ATTR_ND, sizeof(*nd_key));


