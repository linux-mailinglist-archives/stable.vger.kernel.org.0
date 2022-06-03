Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC5DB53CBDF
	for <lists+stable@lfdr.de>; Fri,  3 Jun 2022 16:58:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232815AbiFCO6A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Jun 2022 10:58:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229785AbiFCO57 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Jun 2022 10:57:59 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1C3739834
        for <stable@vger.kernel.org>; Fri,  3 Jun 2022 07:57:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A703EB82345
        for <stable@vger.kernel.org>; Fri,  3 Jun 2022 14:57:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF579C385B8;
        Fri,  3 Jun 2022 14:57:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654268276;
        bh=MMyri9PI2Pahs0ksLicQMWoTO0rRugpxrOJDG3amWaU=;
        h=Subject:To:Cc:From:Date:From;
        b=WPTJZ4/8BpftSyHzl51FFJwUTIhZtQK0+Fu2m2HXCYuUQSz3UUzuvhYdvsKlG8+Zr
         iVZ5gBboUh4tOSzLZVLKu02iaMmei96ty0YnLJo5oNo+Zn9O+Yx71Tkf0ACI2gRU8o
         qIbsv+1WM5zszN/XkrE8UVsQgrXqklo0b+EDIrk8=
Subject: FAILED: patch "[PATCH] netfilter: nf_tables: hold mutex on netns pre_exit path" failed to apply to 5.10-stable tree
To:     pablo@netfilter.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 03 Jun 2022 16:57:53 +0200
Message-ID: <16542682731868@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
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


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 3923b1e4406680d57da7e873da77b1683035d83f Mon Sep 17 00:00:00 2001
From: Pablo Neira Ayuso <pablo@netfilter.org>
Date: Mon, 30 May 2022 18:24:05 +0200
Subject: [PATCH] netfilter: nf_tables: hold mutex on netns pre_exit path

clean_net() runs in workqueue while walking over the lists, grab mutex.

Fixes: 767d1216bff8 ("netfilter: nftables: fix possible UAF over chains from packet path in netns")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index dcefb5f36b3a..f77414e13de1 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -9896,7 +9896,11 @@ static int __net_init nf_tables_init_net(struct net *net)
 
 static void __net_exit nf_tables_pre_exit_net(struct net *net)
 {
+	struct nftables_pernet *nft_net = nft_pernet(net);
+
+	mutex_lock(&nft_net->commit_mutex);
 	__nft_release_hooks(net);
+	mutex_unlock(&nft_net->commit_mutex);
 }
 
 static void __net_exit nf_tables_exit_net(struct net *net)

