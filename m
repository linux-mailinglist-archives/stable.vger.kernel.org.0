Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3E4A4F2FCA
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 14:18:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236445AbiDEI1r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:27:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239528AbiDEIUM (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:20:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BC22F57;
        Tue,  5 Apr 2022 01:15:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3122B609AD;
        Tue,  5 Apr 2022 08:15:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E91DC385A0;
        Tue,  5 Apr 2022 08:15:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649146525;
        bh=t/QupVy0dbCFdJvA+PQ1ww6kp1XlV5Q+WcimY+Qw8n8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cG9WBbErYHWJTrefnVSnmKt/LXN9gAU/krRTUPaMrS8TlG1/8fY/Wrw31vINOr6Rj
         Mcq8eYmyHx+860ZUnaWicTKuj4fJ/SyR0IQzNObUwGNTe+/FXpoAh6JR3Apu+ARIvt
         iAP8hcEXUb0QdA3cGMJwBIwhBPHPIw4RdC+EFVTk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Phil Sutter <phil@nwl.cc>,
        Florian Westphal <fw@strlen.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0793/1126] netfilter: egress: Report interface as outgoing
Date:   Tue,  5 Apr 2022 09:25:40 +0200
Message-Id: <20220405070430.848547955@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Phil Sutter <phil@nwl.cc>

[ Upstream commit d645552e9bd96671079b27015294ec7f9748fa2b ]

Otherwise packets in egress chains seem like they are being received by
the interface, not sent out via it.

Fixes: 42df6e1d221dd ("netfilter: Introduce egress hook")
Signed-off-by: Phil Sutter <phil@nwl.cc>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/netfilter_netdev.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/netfilter_netdev.h b/include/linux/netfilter_netdev.h
index e6487a691136..8676316547cc 100644
--- a/include/linux/netfilter_netdev.h
+++ b/include/linux/netfilter_netdev.h
@@ -99,7 +99,7 @@ static inline struct sk_buff *nf_hook_egress(struct sk_buff *skb, int *rc,
 		return skb;
 
 	nf_hook_state_init(&state, NF_NETDEV_EGRESS,
-			   NFPROTO_NETDEV, dev, NULL, NULL,
+			   NFPROTO_NETDEV, NULL, dev, NULL,
 			   dev_net(dev), NULL);
 
 	/* nf assumes rcu_read_lock, not just read_lock_bh */
-- 
2.34.1



