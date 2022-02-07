Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D3214ABCD3
	for <lists+stable@lfdr.de>; Mon,  7 Feb 2022 12:50:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229570AbiBGLjk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Feb 2022 06:39:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1386113AbiBGLdj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Feb 2022 06:33:39 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 157DFC043181;
        Mon,  7 Feb 2022 03:33:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CFE27B80EBD;
        Mon,  7 Feb 2022 11:33:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34DD8C004E1;
        Mon,  7 Feb 2022 11:33:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644233615;
        bh=56VyBmj+bRsCsk2a9Y/xPAhsRALIjjZvUHbCqINZASk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MvmIUapKyYuACRlhKOH9xvMDDUaXaS73G95dFiU6YUZORKE4rxbiOGo1luLjOFhhB
         glpG8qjrnblDpQ3ejMe+v/YDGAUEQL4xf755oMpw/tDfSIH6Lq3zr3cAGbWFqDDREA
         oPH2B8WPS6O8GxUAvqJdAXM2qqipS8q8twmlIDv8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 5.16 068/126] netfilter: nft_reject_bridge: Fix for missing reply from prerouting
Date:   Mon,  7 Feb 2022 12:06:39 +0100
Message-Id: <20220207103806.467774635@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220207103804.053675072@linuxfoundation.org>
References: <20220207103804.053675072@linuxfoundation.org>
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

commit aeac4554eb549037ff2f719200c0a9c1c25e7eaa upstream.

Prior to commit fa538f7cf05aa ("netfilter: nf_reject: add reject skbuff
creation helpers"), nft_reject_bridge did not assign to nskb->dev before
passing nskb on to br_forward(). The shared skbuff creation helpers
introduced in above commit do which seems to confuse br_forward() as
reject statements in prerouting hook won't emit a packet anymore.

Fix this by simply passing NULL instead of 'dev' to the helpers - they
use the pointer for just that assignment, nothing else.

Fixes: fa538f7cf05aa ("netfilter: nf_reject: add reject skbuff creation helpers")
Signed-off-by: Phil Sutter <phil@nwl.cc>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bridge/netfilter/nft_reject_bridge.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/net/bridge/netfilter/nft_reject_bridge.c
+++ b/net/bridge/netfilter/nft_reject_bridge.c
@@ -49,7 +49,7 @@ static void nft_reject_br_send_v4_tcp_re
 {
 	struct sk_buff *nskb;
 
-	nskb = nf_reject_skb_v4_tcp_reset(net, oldskb, dev, hook);
+	nskb = nf_reject_skb_v4_tcp_reset(net, oldskb, NULL, hook);
 	if (!nskb)
 		return;
 
@@ -65,7 +65,7 @@ static void nft_reject_br_send_v4_unreac
 {
 	struct sk_buff *nskb;
 
-	nskb = nf_reject_skb_v4_unreach(net, oldskb, dev, hook, code);
+	nskb = nf_reject_skb_v4_unreach(net, oldskb, NULL, hook, code);
 	if (!nskb)
 		return;
 
@@ -81,7 +81,7 @@ static void nft_reject_br_send_v6_tcp_re
 {
 	struct sk_buff *nskb;
 
-	nskb = nf_reject_skb_v6_tcp_reset(net, oldskb, dev, hook);
+	nskb = nf_reject_skb_v6_tcp_reset(net, oldskb, NULL, hook);
 	if (!nskb)
 		return;
 
@@ -98,7 +98,7 @@ static void nft_reject_br_send_v6_unreac
 {
 	struct sk_buff *nskb;
 
-	nskb = nf_reject_skb_v6_unreach(net, oldskb, dev, hook, code);
+	nskb = nf_reject_skb_v6_unreach(net, oldskb, NULL, hook, code);
 	if (!nskb)
 		return;
 


