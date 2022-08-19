Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BDE1059A077
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 18:33:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351292AbiHSQG5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 12:06:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351612AbiHSQGJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 12:06:09 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA4F910C80C;
        Fri, 19 Aug 2022 08:55:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 569ADB827F8;
        Fri, 19 Aug 2022 15:55:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59203C433D6;
        Fri, 19 Aug 2022 15:55:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660924527;
        bh=frxGgoYrwHHi4aB9uzxcpORzALqIQCrZ8zBnomAcIM4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O7Kr7gzywyDksettN3ewdiCSKxqbCVX9FsJY80Zxcg/h7zZyuyU/912LaBIKmTibW
         NKQWsVNKuNWp2mq2WfadpQe6aMTrxy9oJ45FMWvn5T8C0+gONdR11r4zXhqEvf7nhX
         rLB7obENik7DkyBn3w00stZXVcNyErafNiGtAELs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jian Shen <shenjian15@huawei.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 182/545] test_bpf: fix incorrect netdev features
Date:   Fri, 19 Aug 2022 17:39:12 +0200
Message-Id: <20220819153837.508612900@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220819153829.135562864@linuxfoundation.org>
References: <20220819153829.135562864@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Jian Shen <shenjian15@huawei.com>

[ Upstream commit 9676feccacdb0571791c88b23e3b7ac4e7c9c457 ]

The prototype of .features is netdev_features_t, it should use
NETIF_F_LLTX and NETIF_F_HW_VLAN_STAG_TX, not NETIF_F_LLTX_BIT
and NETIF_F_HW_VLAN_STAG_TX_BIT.

Fixes: cf204a718357 ("bpf, testing: Introduce 'gso_linear_no_head_frag' skb_segment test")
Signed-off-by: Jian Shen <shenjian15@huawei.com>
Acked-by: John Fastabend <john.fastabend@gmail.com>
Link: https://lore.kernel.org/r/20220622135002.8263-1-shenjian15@huawei.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/test_bpf.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/lib/test_bpf.c b/lib/test_bpf.c
index 4a9137c8551a..8761b9797073 100644
--- a/lib/test_bpf.c
+++ b/lib/test_bpf.c
@@ -6918,9 +6918,9 @@ static struct skb_segment_test skb_segment_tests[] __initconst = {
 		.build_skb = build_test_skb_linear_no_head_frag,
 		.features = NETIF_F_SG | NETIF_F_FRAGLIST |
 			    NETIF_F_HW_VLAN_CTAG_TX | NETIF_F_GSO |
-			    NETIF_F_LLTX_BIT | NETIF_F_GRO |
+			    NETIF_F_LLTX | NETIF_F_GRO |
 			    NETIF_F_IPV6_CSUM | NETIF_F_RXCSUM |
-			    NETIF_F_HW_VLAN_STAG_TX_BIT
+			    NETIF_F_HW_VLAN_STAG_TX
 	}
 };
 
-- 
2.35.1



