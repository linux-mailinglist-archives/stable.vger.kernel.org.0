Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5366E69CD95
	for <lists+stable@lfdr.de>; Mon, 20 Feb 2023 14:50:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232404AbjBTNuk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Feb 2023 08:50:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232418AbjBTNuk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Feb 2023 08:50:40 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 046B81D91A
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 05:50:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 95ADA60CBA
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 13:50:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC0FDC433EF;
        Mon, 20 Feb 2023 13:50:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676901038;
        bh=viNjHuWFMEtdbL6gqWaL7GvAryIKcU5xm0+XTmXTk2I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kJ6H8j1L3Xwta6wayM7Gia0e4R6aeIPiQSior0paxNDBnhoKdU/bC1U6zLSPpBJVA
         uxlBH0NAd+uN9fvbZOPp3Jjk/XVyhd/O+/9Jrb5WHSbB/pMKgTpc7YELJVWIrbhKWl
         +OxBJgBWpqCbtqiY9Phb12PmPepd3MtFKZxvn4fk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Pietro Borrello <borrello@diag.uniroma1.it>,
        Xin Long <lucien.xin@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.4 141/156] sctp: sctp_sock_filter(): avoid list_entry() on possibly empty list
Date:   Mon, 20 Feb 2023 14:36:25 +0100
Message-Id: <20230220133608.518509203@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230220133602.515342638@linuxfoundation.org>
References: <20230220133602.515342638@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pietro Borrello <borrello@diag.uniroma1.it>

commit a1221703a0f75a9d81748c516457e0fc76951496 upstream.

Use list_is_first() to check whether tsp->asoc matches the first
element of ep->asocs, as the list is not guaranteed to have an entry.

Fixes: 8f840e47f190 ("sctp: add the sctp_diag.c file")
Signed-off-by: Pietro Borrello <borrello@diag.uniroma1.it>
Acked-by: Xin Long <lucien.xin@gmail.com>
Link: https://lore.kernel.org/r/20230208-sctp-filter-v2-1-6e1f4017f326@diag.uniroma1.it
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sctp/diag.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/net/sctp/diag.c
+++ b/net/sctp/diag.c
@@ -349,11 +349,9 @@ static int sctp_sock_filter(struct sctp_
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


