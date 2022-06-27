Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7862155C771
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 14:54:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235539AbiF0Ld4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 07:33:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236014AbiF0LdD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 07:33:03 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06C09BCBE;
        Mon, 27 Jun 2022 04:30:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 83FAEB81122;
        Mon, 27 Jun 2022 11:30:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6B6BC3411D;
        Mon, 27 Jun 2022 11:30:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656329403;
        bh=SYnv/FhFH1ekUtV6eC1WyevHUII+0SmBoVZiwtyZeUA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QKN5LpM20M6Ry22VMZJ1OYycawkQ8rWCm5zSqrZ7hBJhCAf0cBGx50/3dORJTA+yp
         WgAZ08QrgfFYSs2/aCxpI8/WGSZRwfw+kV9Tvjb7q5ehe29EtQ1b0w0TPGRIvs8Oby
         vnYTGJ7t1J8NPg1VSPVQGTu+WsRwQm8wn3JexPWI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rosemarie ORiorden <roriorden@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>,
        Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 5.4 07/60] net: openvswitch: fix parsing of nw_proto for IPv6 fragments
Date:   Mon, 27 Jun 2022 13:21:18 +0200
Message-Id: <20220627111927.866949565@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220627111927.641837068@linuxfoundation.org>
References: <20220627111927.641837068@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rosemarie O'Riorden <roriorden@redhat.com>

commit 12378a5a75e33f34f8586706eb61cca9e6d4690c upstream.

When a packet enters the OVS datapath and does not match any existing
flows installed in the kernel flow cache, the packet will be sent to
userspace to be parsed, and a new flow will be created. The kernel and
OVS rely on each other to parse packet fields in the same way so that
packets will be handled properly.

As per the design document linked below, OVS expects all later IPv6
fragments to have nw_proto=44 in the flow key, so they can be correctly
matched on OpenFlow rules. OpenFlow controllers create pipelines based
on this design.

This behavior was changed by the commit in the Fixes tag so that
nw_proto equals the next_header field of the last extension header.
However, there is no counterpart for this change in OVS userspace,
meaning that this field is parsed differently between OVS and the
kernel. This is a problem because OVS creates actions based on what is
parsed in userspace, but the kernel-provided flow key is used as a match
criteria, as described in Documentation/networking/openvswitch.rst. This
leads to issues such as packets incorrectly matching on a flow and thus
the wrong list of actions being applied to the packet. Such changes in
packet parsing cannot be implemented without breaking the userspace.

The offending commit is partially reverted to restore the expected
behavior.

The change technically made sense and there is a good reason that it was
implemented, but it does not comply with the original design of OVS.
If in the future someone wants to implement such a change, then it must
be user-configurable and disabled by default to preserve backwards
compatibility with existing OVS versions.

Cc: stable@vger.kernel.org
Fixes: fa642f08839b ("openvswitch: Derive IP protocol number for IPv6 later frags")
Link: https://docs.openvswitch.org/en/latest/topics/design/#fragments
Signed-off-by: Rosemarie O'Riorden <roriorden@redhat.com>
Acked-by: Eelco Chaudron <echaudro@redhat.com>
Link: https://lore.kernel.org/r/20220621204845.9721-1-roriorden@redhat.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/openvswitch/flow.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/openvswitch/flow.c
+++ b/net/openvswitch/flow.c
@@ -265,7 +265,7 @@ static int parse_ipv6hdr(struct sk_buff
 	if (flags & IP6_FH_F_FRAG) {
 		if (frag_off) {
 			key->ip.frag = OVS_FRAG_TYPE_LATER;
-			key->ip.proto = nexthdr;
+			key->ip.proto = NEXTHDR_FRAGMENT;
 			return 0;
 		}
 		key->ip.frag = OVS_FRAG_TYPE_FIRST;


