Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B27F69CE9B
	for <lists+stable@lfdr.de>; Mon, 20 Feb 2023 15:00:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232773AbjBTOAv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Feb 2023 09:00:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232781AbjBTOAt (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Feb 2023 09:00:49 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A5871EBCE
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 06:00:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B758DB80D07
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 14:00:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31040C4339C;
        Mon, 20 Feb 2023 14:00:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676901618;
        bh=CBExR8AHEmCoIjSQLDPHYCrxhewByaO9AoeOQU4oNjg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U/Eayth+OCK6MREGkV4uOCuSKsCbB8/LChHY/2r//QK7SJCqITqbStfIJGmsKHTqw
         2keuRgZQ/PpsDLbza15WvrhAKYq/yLf32fOfNAbote3LmfcmwFFkBuwSnwdDeuLvF0
         R3Ml2nfx1wWChp+u2ehR1xUAPOnJfnnAdS08XRIA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Pietro Borrello <borrello@diag.uniroma1.it>,
        Xin Long <lucien.xin@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 086/118] sctp: sctp_sock_filter(): avoid list_entry() on possibly empty list
Date:   Mon, 20 Feb 2023 14:36:42 +0100
Message-Id: <20230220133603.851587128@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230220133600.368809650@linuxfoundation.org>
References: <20230220133600.368809650@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
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
@@ -343,11 +343,9 @@ static int sctp_sock_filter(struct sctp_
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


