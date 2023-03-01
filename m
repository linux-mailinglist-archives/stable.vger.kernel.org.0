Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 592E76A72ED
	for <lists+stable@lfdr.de>; Wed,  1 Mar 2023 19:10:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229800AbjCASKs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Mar 2023 13:10:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229901AbjCASKr (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Mar 2023 13:10:47 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE60F36453
        for <stable@vger.kernel.org>; Wed,  1 Mar 2023 10:10:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A044FB810DE
        for <stable@vger.kernel.org>; Wed,  1 Mar 2023 18:10:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1A5EC433D2;
        Wed,  1 Mar 2023 18:10:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1677694243;
        bh=kiquuDoY3vOpc5vZLNMCZ1F2+fjemVTNZ6DrDvZgk7U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VtZlmGjNee3yRa2NWcRa1Q4dyMwpiZOakoGQoY4jgsnfc8KUp1jRxC+wwJB6OXU6v
         6pq4IDJczPGFtfQoxhAWhZC5Xifjq3IcHr9etkOiSHHhpdmCt4gNpTKqtIw3c21AzH
         IUGPlSs/sRmxXWJJmDxp2CIFCO8vJVOMhm21CtA4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Martin KaFai Lau <martin.lau@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Subject: [PATCH 5.15 14/22] bpf: bpf_fib_lookup should not return neigh in NUD_FAILED state
Date:   Wed,  1 Mar 2023 19:08:47 +0100
Message-Id: <20230301180653.221539252@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230301180652.658125575@linuxfoundation.org>
References: <20230301180652.658125575@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Martin KaFai Lau <martin.lau@kernel.org>

commit 1fe4850b34ab512ff911e2c035c75fb6438f7307 upstream.

The bpf_fib_lookup() helper does not only look up the fib (ie. route)
but it also looks up the neigh. Before returning the neigh, the helper
does not check for NUD_VALID. When a neigh state (neigh->nud_state)
is in NUD_FAILED, its dmac (neigh->ha) could be all zeros. The helper
still returns SUCCESS instead of NO_NEIGH in this case. Because of the
SUCCESS return value, the bpf prog directly uses the returned dmac
and ends up filling all zero in the eth header.

This patch checks for NUD_VALID and returns NO_NEIGH if the neigh is
not valid.

Signed-off-by: Martin KaFai Lau <martin.lau@kernel.org>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/bpf/20230217004150.2980689-3-martin.lau@linux.dev
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/filter.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -5506,7 +5506,7 @@ static int bpf_ipv4_fib_lookup(struct ne
 		neigh = __ipv6_neigh_lookup_noref_stub(dev, dst);
 	}
 
-	if (!neigh)
+	if (!neigh || !(neigh->nud_state & NUD_VALID))
 		return BPF_FIB_LKUP_RET_NO_NEIGH;
 
 	return bpf_fib_set_fwd_params(params, neigh, dev, mtu);
@@ -5621,7 +5621,7 @@ static int bpf_ipv6_fib_lookup(struct ne
 	 * not needed here.
 	 */
 	neigh = __ipv6_neigh_lookup_noref_stub(dev, dst);
-	if (!neigh)
+	if (!neigh || !(neigh->nud_state & NUD_VALID))
 		return BPF_FIB_LKUP_RET_NO_NEIGH;
 
 	return bpf_fib_set_fwd_params(params, neigh, dev, mtu);


