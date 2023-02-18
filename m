Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D61D669B9B3
	for <lists+stable@lfdr.de>; Sat, 18 Feb 2023 12:19:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229596AbjBRLTc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 18 Feb 2023 06:19:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229541AbjBRLTc (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 18 Feb 2023 06:19:32 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C176D11E93
        for <stable@vger.kernel.org>; Sat, 18 Feb 2023 03:19:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 32DE660B68
        for <stable@vger.kernel.org>; Sat, 18 Feb 2023 11:18:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4303DC433D2;
        Sat, 18 Feb 2023 11:18:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676719124;
        bh=M7BnO85jyya/3ChJyccjaOgXwaesBZpjXZqCPJMB7CY=;
        h=Subject:To:Cc:From:Date:From;
        b=VpC5UclkeEx2rZD/2xRqV3IUfNeaKzUqM9G8QetaeAxblgWkKqStXGm2ytcIHWLQn
         lWKkx0+5CqZKo/OK9s7MowwMEPOPRwNuUVltWLEHeV/MXWFafuh9jIxPZuAKZUgLsG
         dc9erLcOO77T9qtIHXpVmw14DU0nxbycMHG8Jvb0=
Subject: FAILED: patch "[PATCH] sctp: sctp_sock_filter(): avoid list_entry() on possibly" failed to apply to 4.19-stable tree
To:     borrello@diag.uniroma1.it, kuba@kernel.org, lucien.xin@gmail.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 18 Feb 2023 12:18:41 +0100
Message-ID: <167671912117941@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

a1221703a0f7 ("sctp: sctp_sock_filter(): avoid list_entry() on possibly empty list")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From a1221703a0f75a9d81748c516457e0fc76951496 Mon Sep 17 00:00:00 2001
From: Pietro Borrello <borrello@diag.uniroma1.it>
Date: Thu, 9 Feb 2023 12:13:05 +0000
Subject: [PATCH] sctp: sctp_sock_filter(): avoid list_entry() on possibly
 empty list

Use list_is_first() to check whether tsp->asoc matches the first
element of ep->asocs, as the list is not guaranteed to have an entry.

Fixes: 8f840e47f190 ("sctp: add the sctp_diag.c file")
Signed-off-by: Pietro Borrello <borrello@diag.uniroma1.it>
Acked-by: Xin Long <lucien.xin@gmail.com>
Link: https://lore.kernel.org/r/20230208-sctp-filter-v2-1-6e1f4017f326@diag.uniroma1.it
Signed-off-by: Jakub Kicinski <kuba@kernel.org>

diff --git a/net/sctp/diag.c b/net/sctp/diag.c
index a557009e9832..c3d6b92dd386 100644
--- a/net/sctp/diag.c
+++ b/net/sctp/diag.c
@@ -343,11 +343,9 @@ static int sctp_sock_filter(struct sctp_endpoint *ep, struct sctp_transport *tsp
 	struct sctp_comm_param *commp = p;
 	struct sock *sk = ep->base.sk;
 	const struct inet_diag_req_v2 *r = commp->r;
-	struct sctp_association *assoc =
-		list_entry(ep->asocs.next, struct sctp_association, asocs);
 
 	/* find the ep only once through the transports by this condition */
-	if (tsp->asoc != assoc)
+	if (!list_is_first(&tsp->asoc->asocs, &ep->asocs))
 		return 0;
 
 	if (r->sdiag_family != AF_UNSPEC && sk->sk_family != r->sdiag_family)

