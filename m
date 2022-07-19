Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21FBB579A18
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 14:10:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238625AbiGSMKj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 08:10:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239021AbiGSMJ7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 08:09:59 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D1594B495;
        Tue, 19 Jul 2022 05:03:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C0929B81B13;
        Tue, 19 Jul 2022 12:03:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 321A0C341C6;
        Tue, 19 Jul 2022 12:03:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658232184;
        bh=m5i9FHsYFJcVlcTinyFr82qTUWqnUvSXwkfk6qPijUM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Sbc2YYnOFluEfXAfXqWsDbKLRHeUulvtjS+wFLxUrm6b/zFtRfS2Kc5YoLXcvfheL
         G59EJm06tsB2eCdjkMhocEQR6h3K423ZAMHQhSsZm/2LwXp7vuS4pTFuKYYKH+BPPR
         lIr4/71JyZPjNE94Uys5FEPHUPid19+b6UViK10M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrea Mayer <andrea.mayer@uniroma2.it>,
        Paolo Abeni <pabeni@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 42/71] seg6: bpf: fix skb checksum in bpf_push_seg6_encap()
Date:   Tue, 19 Jul 2022 13:54:05 +0200
Message-Id: <20220719114556.358815767@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220719114552.477018590@linuxfoundation.org>
References: <20220719114552.477018590@linuxfoundation.org>
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
index eba96343c7af..75f53b5e6389 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -4955,7 +4955,6 @@ static int bpf_push_seg6_encap(struct sk_buff *skb, u32 type, void *hdr, u32 len
 	if (err)
 		return err;
 
-	ipv6_hdr(skb)->payload_len = htons(skb->len - sizeof(struct ipv6hdr));
 	skb_set_transport_header(skb, sizeof(struct ipv6hdr));
 
 	return seg6_lookup_nexthop(skb, NULL, 0);
-- 
2.35.1



