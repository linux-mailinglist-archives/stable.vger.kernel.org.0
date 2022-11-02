Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F366615A43
	for <lists+stable@lfdr.de>; Wed,  2 Nov 2022 04:28:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231147AbiKBD14 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 23:27:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231158AbiKBD1t (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 23:27:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23F2C25EBB
        for <stable@vger.kernel.org>; Tue,  1 Nov 2022 20:27:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9E586617DA
        for <stable@vger.kernel.org>; Wed,  2 Nov 2022 03:27:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22ACCC433D6;
        Wed,  2 Nov 2022 03:27:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667359668;
        bh=1eXI12tE0TquepeqJI/1t938PlAcaEQ9MA8JDBbTCb4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bdCGUv3/gp0+Pd3GNcvEr/NzR2RXXZ14IKAZW03ze3vPDbuAF6DoBK+aRdTMiCOtp
         QYnVnPKho8IFbjHkP3qbN/xbz75U6wPWupBJFWxsirkcGn/nfgK8sU5YBlAvY3y6sQ
         q3BFTc6Ay5/XcO1zc/AH7XmriwukOJa9GWvwKegs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Mark Tomlinson <mark.tomlinson@alliedtelesis.co.nz>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 14/78] tipc: Fix recognition of trial period
Date:   Wed,  2 Nov 2022 03:33:59 +0100
Message-Id: <20221102022053.370165138@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022052.895556444@linuxfoundation.org>
References: <20221102022052.895556444@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mark Tomlinson <mark.tomlinson@alliedtelesis.co.nz>

[ Upstream commit 28be7ca4fcfd69a2d52aaa331adbf9dbe91f9e6e ]

The trial period exists until jiffies is after addr_trial_end. But as
jiffies will eventually overflow, just using time_after will eventually
give incorrect results. As the node address is set once the trial period
ends, this can be used to know that we are not in the trial period.

Fixes: e415577f57f4 ("tipc: correct discovery message handling during address trial period")
Signed-off-by: Mark Tomlinson <mark.tomlinson@alliedtelesis.co.nz>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/tipc/discover.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/tipc/discover.c b/net/tipc/discover.c
index c138d68e8a69..0006c9f87199 100644
--- a/net/tipc/discover.c
+++ b/net/tipc/discover.c
@@ -146,8 +146,8 @@ static bool tipc_disc_addr_trial_msg(struct tipc_discoverer *d,
 {
 	struct net *net = d->net;
 	struct tipc_net *tn = tipc_net(net);
-	bool trial = time_before(jiffies, tn->addr_trial_end);
 	u32 self = tipc_own_addr(net);
+	bool trial = time_before(jiffies, tn->addr_trial_end) && !self;
 
 	if (mtyp == DSC_TRIAL_FAIL_MSG) {
 		if (!trial)
-- 
2.35.1



