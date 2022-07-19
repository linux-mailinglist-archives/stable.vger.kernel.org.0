Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9071579996
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 14:05:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238009AbiGSMFA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 08:05:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238162AbiGSMEH (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 08:04:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6E3C4BD3E;
        Tue, 19 Jul 2022 04:59:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 687AA61614;
        Tue, 19 Jul 2022 11:59:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4405CC341C6;
        Tue, 19 Jul 2022 11:59:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658231995;
        bh=xL1HltxFhI1tLbk5EtyBpYCOs7A1TDc2DLehvGPeY/A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NjiIkXPulWdCL/jaKM+MmPkYWXDFdbroM739uqHtbaV0jF3ns+hL5xHMJPV/poy7c
         ha2+rkhR1HWcGQoaPsj5IvC/NWiA0oEO/K7tvqo7iZJzwhfzGrWcKF+DPvW2odICqe
         tkHlwjuRjBE8ecu9yOc7hzuJw1rOWr+PgZJ7fMf0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrea Mayer <andrea.mayer@uniroma2.it>,
        Paolo Abeni <pabeni@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 25/48] seg6: bpf: fix skb checksum in bpf_push_seg6_encap()
Date:   Tue, 19 Jul 2022 13:54:02 +0200
Message-Id: <20220719114522.156902900@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220719114518.915546280@linuxfoundation.org>
References: <20220719114518.915546280@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrea Mayer <andrea.mayer@uniroma2.it>

[ Upstream commit 4889fbd98deaf243c3baadc54e296d71c6af1eb0 ]

Both helper functions bpf_lwt_seg6_action() and bpf_lwt_push_encap() use
the bpf_push_seg6_encap() to encapsulate the packet in an IPv6 with Segment
Routing Header (SRH) or insert an SRH between the IPv6 header and the
payload.
To achieve this result, such helper functions rely on bpf_push_seg6_encap()
which, in turn, leverages seg6_do_srh_{encap,inline}() to perform the
required operation (i.e. encap/inline).

This patch removes the initialization of the IPv6 header payload length
from bpf_push_seg6_encap(), as it is now handled properly by
seg6_do_srh_{encap,inline}() to prevent corruption of the skb checksum.

Fixes: fe94cc290f53 ("bpf: Add IPv6 Segment Routing helpers")
Signed-off-by: Andrea Mayer <andrea.mayer@uniroma2.it>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/filter.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/net/core/filter.c b/net/core/filter.c
index c1310c9d1b90..5129e89f52bb 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -4570,7 +4570,6 @@ static int bpf_push_seg6_encap(struct sk_buff *skb, u32 type, void *hdr, u32 len
 	if (err)
 		return err;
 
-	ipv6_hdr(skb)->payload_len = htons(skb->len - sizeof(struct ipv6hdr));
 	skb_set_transport_header(skb, sizeof(struct ipv6hdr));
 
 	return seg6_lookup_nexthop(skb, NULL, 0);
-- 
2.35.1



