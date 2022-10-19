Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C03B603D96
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 11:05:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232153AbiJSJFP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 05:05:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232390AbiJSJEI (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 05:04:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5275F2E690;
        Wed, 19 Oct 2022 01:57:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3775F6187A;
        Wed, 19 Oct 2022 08:53:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48B5FC43144;
        Wed, 19 Oct 2022 08:53:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666169587;
        bh=EtP+T23VdFQowWwzjB9/ws5vszh9Tjc6/grKZe9yz5M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fS2O/jUcYY6x53pERcsiL5Z/V6Q2Nv9OXf7guhNIZeyOrUYb5XQzVcuLitiPA7pKF
         YmD+69G/2GDu1NIVBhOfiKcA0PNvAeRRZJGDAbNUi2FFvh2rQAQFLwM7RrMKhDSWdH
         QauLr4T3AkDVOIkwQB2MTYddHWQ9dFG6kQ5hGleQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qingqing Yang <qingqing.yang@broadcom.com>,
        Boris Sukholitko <boris.sukholitko@broadcom.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 305/862] flow_dissector: Do not count vlan tags inside tunnel payload
Date:   Wed, 19 Oct 2022 10:26:32 +0200
Message-Id: <20221019083303.487021389@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qingqing Yang <qingqing.yang@broadcom.com>

[ Upstream commit 9f87eb4246994e32a4e4ea88476b20ab3b412840 ]

We've met the problem that when there is a vlan tag inside
GRE encapsulation, the match of num_of_vlans fails.
It is caused by the vlan tag inside GRE payload has been
counted into num_of_vlans, which is not expected.

One example packet is like this:
Ethernet II, Src: Broadcom_68:56:07 (00:10:18:68:56:07)
                   Dst: Broadcom_68:56:08 (00:10:18:68:56:08)
802.1Q Virtual LAN, PRI: 0, DEI: 0, ID: 100
Internet Protocol Version 4, Src: 192.168.1.4, Dst: 192.168.1.200
Generic Routing Encapsulation (Transparent Ethernet bridging)
Ethernet II, Src: Broadcom_68:58:07 (00:10:18:68:58:07)
                   Dst: Broadcom_68:58:08 (00:10:18:68:58:08)
802.1Q Virtual LAN, PRI: 0, DEI: 0, ID: 200
...
It should match the (num_of_vlans 1) rule, but it matches
the (num_of_vlans 2) rule.

The vlan tags inside the GRE or other tunnel encapsulated payload
should not be taken into num_of_vlans.
The fix is to stop counting the vlan number when the encapsulation
bit is set.

Fixes: 34951fcf26c5 ("flow_dissector: Add number of vlan tags dissector")
Signed-off-by: Qingqing Yang <qingqing.yang@broadcom.com>
Reviewed-by: Boris Sukholitko <boris.sukholitko@broadcom.com>
Link: https://lore.kernel.org/r/20220919074808.136640-1-qingqing.yang@broadcom.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/flow_dissector.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/core/flow_dissector.c b/net/core/flow_dissector.c
index 5dc3860e9fc7..7105529abb0f 100644
--- a/net/core/flow_dissector.c
+++ b/net/core/flow_dissector.c
@@ -1173,8 +1173,8 @@ bool __skb_flow_dissect(const struct net *net,
 			nhoff += sizeof(*vlan);
 		}
 
-		if (dissector_uses_key(flow_dissector,
-				       FLOW_DISSECTOR_KEY_NUM_OF_VLANS)) {
+		if (dissector_uses_key(flow_dissector, FLOW_DISSECTOR_KEY_NUM_OF_VLANS) &&
+		    !(key_control->flags & FLOW_DIS_ENCAPSULATION)) {
 			struct flow_dissector_key_num_of_vlans *key_nvs;
 
 			key_nvs = skb_flow_dissector_target(flow_dissector,
-- 
2.35.1



