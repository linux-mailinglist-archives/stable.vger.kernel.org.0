Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2BD660A3D3
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 14:00:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232408AbiJXMAc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 08:00:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232671AbiJXL7c (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 07:59:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A46A7C324;
        Mon, 24 Oct 2022 04:48:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E963061290;
        Mon, 24 Oct 2022 11:48:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05CB8C433D6;
        Mon, 24 Oct 2022 11:48:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666612091;
        bh=31mqhKt9Gn0j2CERCn74MGBZCFxUFX+32ob2F+G9/y8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rWdKEX8mYUfeGOn7NAjKix1fuqrEvaD4+kLZePuehEeCLEmFrCrQPW56l60TNzJst
         ikt2ZFTdbKzYURhhLGBxdNklbKOlahhoR6CAinsVtRcA09jp9xi1RJSXXq/4W6/5Wb
         X1N/Vbyqky9sAblxYXc7r+HQfE4L4qByhyzdmbGA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "fw@strlen.de, avimalin@gmail.com, Vimal Agrawal" 
        <vimal.agrawal@sophos.com>, Florian Westphal <fw@strlen.de>,
        Vimal Agrawal <vimal.agrawal@sophos.com>
Subject: [PATCH 4.14 035/210] netfilter: nf_queue: fix socket leak
Date:   Mon, 24 Oct 2022 13:29:12 +0200
Message-Id: <20221024112958.115275475@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024112956.797777597@linuxfoundation.org>
References: <20221024112956.797777597@linuxfoundation.org>
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

From: Vimal Agrawal <avimalin@gmail.com>

Removal of the sock_hold got lost when backporting commit 4d05239203fa
("netfilter: nf_queue: fix possible use-after-free") to 4.14

This was causing a socket leak and was caught by kmemleak.
Tested by running kmemleak again with this fix.

Fixes: ef97921ccdc2 ("netfilter: nf_queue: fix possible use-after-free") in 4.14
Signed-off-by: Vimal Agrawal <vimal.agrawal@sophos.com>
Reviewed-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nf_queue.c |    2 --
 1 file changed, 2 deletions(-)

--- a/net/netfilter/nf_queue.c
+++ b/net/netfilter/nf_queue.c
@@ -91,8 +91,6 @@ bool nf_queue_entry_get_refs(struct nf_q
 		dev_hold(state->in);
 	if (state->out)
 		dev_hold(state->out);
-	if (state->sk)
-		sock_hold(state->sk);
 #if IS_ENABLED(CONFIG_BRIDGE_NETFILTER)
 	if (entry->skb->nf_bridge) {
 		struct net_device *physdev;


