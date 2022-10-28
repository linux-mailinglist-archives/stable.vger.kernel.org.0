Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56893611068
	for <lists+stable@lfdr.de>; Fri, 28 Oct 2022 14:05:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229519AbiJ1MFN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Oct 2022 08:05:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229952AbiJ1MFM (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 28 Oct 2022 08:05:12 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 951D72A70E
        for <stable@vger.kernel.org>; Fri, 28 Oct 2022 05:05:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 05D70B829BC
        for <stable@vger.kernel.org>; Fri, 28 Oct 2022 12:05:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B73DC433C1;
        Fri, 28 Oct 2022 12:05:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666958706;
        bh=yCVUPlFb9eOLdQPkEjgCEVBE1snfYheSL+9eN/PUsrk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dDQa27axJjsN6WUUZOoaRb8+u8yNQ2He3aZlsPMLVe280iBBCE5kLIy9zmqC4UwMT
         9d+O75E+ofqtvKe98BsqiLerZS98pOGv+RdaZXjoMWv73L7Gli2dyQPSUF44hvoOcX
         Q/DTBQ83DhLzc8rClPEKSTrKeN92ZrCqM6nRNlGk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Mark Tomlinson <mark.tomlinson@alliedtelesis.co.nz>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 22/73] tipc: Fix recognition of trial period
Date:   Fri, 28 Oct 2022 14:03:19 +0200
Message-Id: <20221028120233.307645402@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221028120232.344548477@linuxfoundation.org>
References: <20221028120232.344548477@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
index 14bc20604051..2ae268b67465 100644
--- a/net/tipc/discover.c
+++ b/net/tipc/discover.c
@@ -147,8 +147,8 @@ static bool tipc_disc_addr_trial_msg(struct tipc_discoverer *d,
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



