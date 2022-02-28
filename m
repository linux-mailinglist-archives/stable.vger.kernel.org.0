Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8AE7C4C72FC
	for <lists+stable@lfdr.de>; Mon, 28 Feb 2022 18:31:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236473AbiB1RbX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Feb 2022 12:31:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236624AbiB1Ral (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Feb 2022 12:30:41 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D72476E0F;
        Mon, 28 Feb 2022 09:28:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E982261368;
        Mon, 28 Feb 2022 17:28:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A895C340E7;
        Mon, 28 Feb 2022 17:28:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646069307;
        bh=o94hYCFRSnzlDf+I9xTdnx7GOnIE5nmw3pfFfFJDXVU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tkfzdbT7z6huN9Q5ZY8PUCKN6/9cSp3CZufaq1BzNwha07BZ0G2bUQbq/XzC/mhPT
         1OAvhtqyV7/ZRkf+ccx6FCGMos+BlC/Zgdz4JDsErDNkKgxlb6+CQx3qVC6o50r1vA
         jyjZCDlBUaw76hTPns99o8dEtdthKg2jidkj4FZM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 4.14 09/31] net: __pskb_pull_tail() & pskb_carve_frag_list() drop_monitor friends
Date:   Mon, 28 Feb 2022 18:24:05 +0100
Message-Id: <20220228172200.844848580@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220228172159.515152296@linuxfoundation.org>
References: <20220228172159.515152296@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

commit ef527f968ae05c6717c39f49c8709a7e2c19183a upstream.

Whenever one of these functions pull all data from an skb in a frag_list,
use consume_skb() instead of kfree_skb() to avoid polluting drop
monitoring.

Fixes: 6fa01ccd8830 ("skbuff: Add pskb_extract() helper function")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Link: https://lore.kernel.org/r/20220220154052.1308469-1-eric.dumazet@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/skbuff.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -1974,7 +1974,7 @@ void *__pskb_pull_tail(struct sk_buff *s
 		/* Free pulled out fragments. */
 		while ((list = skb_shinfo(skb)->frag_list) != insp) {
 			skb_shinfo(skb)->frag_list = list->next;
-			kfree_skb(list);
+			consume_skb(list);
 		}
 		/* And insert new clone at head. */
 		if (clone) {
@@ -5408,7 +5408,7 @@ static int pskb_carve_frag_list(struct s
 	/* Free pulled out fragments. */
 	while ((list = shinfo->frag_list) != insp) {
 		shinfo->frag_list = list->next;
-		kfree_skb(list);
+		consume_skb(list);
 	}
 	/* And insert new clone at head. */
 	if (clone) {


