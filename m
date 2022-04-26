Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8EFAB50F6B3
	for <lists+stable@lfdr.de>; Tue, 26 Apr 2022 10:59:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345784AbiDZI60 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Apr 2022 04:58:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245020AbiDZI5Y (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Apr 2022 04:57:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB1EA81677;
        Tue, 26 Apr 2022 01:41:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A77ABB81CED;
        Tue, 26 Apr 2022 08:41:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C329C385A4;
        Tue, 26 Apr 2022 08:41:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650962515;
        bh=Oaa1kYDZlmNoZlnAkZ1ogI20WNPdZk//Lu5Kqqcgd04=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qDSjBdQiiozyNJclvsVg7ae8mw4mTWIjCwKHUWIK+FnlcRv6W9EQDNA05Wb7Hb8k5
         lLUdBMW1v/B9SQLZz7todEgZtBt8ScWWod1BebfZhAMBM+3QLMm+HbhT+Y8f+DctDk
         HQ1Yd9C/iQ5HMI8nU6eNzNMgmcMxbCuezPCc1kQ8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <oliver.sang@intel.com>,
        Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 5.15 120/124] netfilter: nft_ct: fix use after free when attaching zone template
Date:   Tue, 26 Apr 2022 10:22:01 +0200
Message-Id: <20220426081750.701058603@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220426081747.286685339@linuxfoundation.org>
References: <20220426081747.286685339@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

commit 34243b9ec856309339172b1507379074156947e8 upstream.

The conversion erroneously removed the refcount increment.
In case we can use the percpu template, we need to increment
the refcount, else it will be released when the skb gets freed.

In case the slowpath is taken, the new template already has a
refcount of 1.

Fixes: 719774377622 ("netfilter: conntrack: convert to refcount_t api")
Reported-by: kernel test robot <oliver.sang@intel.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netfilter/nft_ct.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/net/netfilter/nft_ct.c
+++ b/net/netfilter/nft_ct.c
@@ -260,9 +260,12 @@ static void nft_ct_set_zone_eval(const s
 	ct = this_cpu_read(nft_ct_pcpu_template);
 
 	if (likely(refcount_read(&ct->ct_general.use) == 1)) {
+		refcount_inc(&ct->ct_general.use);
 		nf_ct_zone_add(ct, &zone);
 	} else {
-		/* previous skb got queued to userspace */
+		/* previous skb got queued to userspace, allocate temporary
+		 * one until percpu template can be reused.
+		 */
 		ct = nf_ct_tmpl_alloc(nft_net(pkt), &zone, GFP_ATOMIC);
 		if (!ct) {
 			regs->verdict.code = NF_DROP;


