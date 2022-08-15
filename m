Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05384594219
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 23:52:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243987AbiHOVFE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 17:05:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344169AbiHOVDq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 17:03:46 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 124E0D347F;
        Mon, 15 Aug 2022 12:14:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3428FB810C6;
        Mon, 15 Aug 2022 19:14:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92B86C433D6;
        Mon, 15 Aug 2022 19:14:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660590877;
        bh=Ntboj5OdAOnTGn4j2kOWSFp861U/2DFFKLts9urgMTQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CW84W8Cmh07yn5kUt6siAXb3lo7L8Wm0A40iXr5NnyKuGeBXQCHHcx31QMzD2mP2l
         IOyyTYJ1A1ZINNQEsMUuQGEPN9R9eXvrOTJ4hj7VuV2GzdNl6pnL0iOHK9DyikL9Rz
         FkOCHnQ7S28j9UuDc2t310Jfd35XskneR6+L9mp4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jian Shen <shenjian15@huawei.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0368/1095] test_bpf: fix incorrect netdev features
Date:   Mon, 15 Aug 2022 19:56:07 +0200
Message-Id: <20220815180444.933953628@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
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
index 0c5cb2d6436a..1a00d0247f70 100644
--- a/lib/test_bpf.c
+++ b/lib/test_bpf.c
@@ -14456,9 +14456,9 @@ static struct skb_segment_test skb_segment_tests[] __initconst = {
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



