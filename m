Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C724D53D012
	for <lists+stable@lfdr.de>; Fri,  3 Jun 2022 20:01:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346208AbiFCR7t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Jun 2022 13:59:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346095AbiFCR6s (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Jun 2022 13:58:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 875DA580C3;
        Fri,  3 Jun 2022 10:55:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DE7F5612DA;
        Fri,  3 Jun 2022 17:55:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7073C385B8;
        Fri,  3 Jun 2022 17:55:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654278902;
        bh=bftCAUS1CFLOhyDhxNmw9rQEm8llGxgW7+GrrahPN1g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rlbvIwooOEGthI+nowKKrDD1yRq81fjfP0Jc7Vf2K7P1hJzHf9kN9zclxTdlurZQ6
         LOXhAdHhqK4LVtYVDTuV7b/JK8U6UxZE/Ux8Hp4W7sdhBek+8L7O//OlcR1FSLR+qq
         kYOleaY+129CcWPWryvHC/XtHwfgEKmxChwp1dOQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 5.17 23/75] netfilter: nf_tables: hold mutex on netns pre_exit path
Date:   Fri,  3 Jun 2022 19:43:07 +0200
Message-Id: <20220603173822.405677031@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220603173821.749019262@linuxfoundation.org>
References: <20220603173821.749019262@linuxfoundation.org>
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

From: Pablo Neira Ayuso <pablo@netfilter.org>

commit 3923b1e4406680d57da7e873da77b1683035d83f upstream.

clean_net() runs in workqueue while walking over the lists, grab mutex.

Fixes: 767d1216bff8 ("netfilter: nftables: fix possible UAF over chains from packet path in netns")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netfilter/nf_tables_api.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -9813,7 +9813,11 @@ static int __net_init nf_tables_init_net
 
 static void __net_exit nf_tables_pre_exit_net(struct net *net)
 {
+	struct nftables_pernet *nft_net = nft_pernet(net);
+
+	mutex_lock(&nft_net->commit_mutex);
 	__nft_release_hooks(net);
+	mutex_unlock(&nft_net->commit_mutex);
 }
 
 static void __net_exit nf_tables_exit_net(struct net *net)


