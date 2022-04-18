Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C6D65053A5
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 14:58:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237268AbiDRNAr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 09:00:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242360AbiDRM7u (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 08:59:50 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2017C201BB;
        Mon, 18 Apr 2022 05:40:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 53002B80EC3;
        Mon, 18 Apr 2022 12:40:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F3D2C385A1;
        Mon, 18 Apr 2022 12:40:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650285654;
        bh=U6HJbILbFH/jDdPNi6UJqdpoL9mzb5+SE4t1nR22814=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pcwffEIBtbbgB2GSQG4b2TB3JhirTPHq7SviNptScrMSLTpr2cfAQa0ldGy8f8Nwv
         W5+dhTifypsdVJfLkZrZ2Lx760jaaltPdC6IEapiT98vcmfTq0GQ/Q03PKupxXenXB
         ec9ReTEksP1HjyHXRYIR8j9NjSFbtQNkov/m8eiE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kongweibin <kongweibin2@huawei.com>,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        David Ahern <dsahern@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.10 085/105] ipv6: fix panic when forwarding a pkt with no in6 dev
Date:   Mon, 18 Apr 2022 14:13:27 +0200
Message-Id: <20220418121149.047517945@linuxfoundation.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220418121145.140991388@linuxfoundation.org>
References: <20220418121145.140991388@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicolas Dichtel <nicolas.dichtel@6wind.com>

commit e3fa461d8b0e185b7da8a101fe94dfe6dd500ac0 upstream.

kongweibin reported a kernel panic in ip6_forward() when input interface
has no in6 dev associated.

The following tc commands were used to reproduce this panic:
tc qdisc del dev vxlan100 root
tc qdisc add dev vxlan100 root netem corrupt 5%

CC: stable@vger.kernel.org
Fixes: ccd27f05ae7b ("ipv6: fix 'disable_policy' for fwd packets")
Reported-by: kongweibin <kongweibin2@huawei.com>
Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/ip6_output.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -508,7 +508,7 @@ int ip6_forward(struct sk_buff *skb)
 		goto drop;
 
 	if (!net->ipv6.devconf_all->disable_policy &&
-	    !idev->cnf.disable_policy &&
+	    (!idev || !idev->cnf.disable_policy) &&
 	    !xfrm6_policy_check(NULL, XFRM_POLICY_FWD, skb)) {
 		__IP6_INC_STATS(net, idev, IPSTATS_MIB_INDISCARDS);
 		goto drop;


