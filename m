Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 151334C74CC
	for <lists+stable@lfdr.de>; Mon, 28 Feb 2022 18:48:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236379AbiB1Rsg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Feb 2022 12:48:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239060AbiB1RsD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Feb 2022 12:48:03 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4F139F6E8;
        Mon, 28 Feb 2022 09:38:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 61DA9614C9;
        Mon, 28 Feb 2022 17:38:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53AC0C36AE7;
        Mon, 28 Feb 2022 17:38:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646069907;
        bh=ossGxllUZrIlYgWBbNFBSCk6U86iaYd8wz7QB1nkS7M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0l+irHmeTiW2WIKPCYsgVBjbPEyu2irz5Iqu2jvZsM2cqudFOoob15bGhu+WM3DxU
         aSoaVV3ALGBzUS6M0ADbbHMDY95/DyHnorTRhBKexDf3Uvokauq5snloKIfeXnr6g/
         WRDn4/NSbWvTYyF4h2TkJws0/tIHSPdAJUGfTGVE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 056/139] net: __pskb_pull_tail() & pskb_carve_frag_list() drop_monitor friends
Date:   Mon, 28 Feb 2022 18:23:50 +0100
Message-Id: <20220228172353.594640152@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220228172347.614588246@linuxfoundation.org>
References: <20220228172347.614588246@linuxfoundation.org>
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
@@ -2254,7 +2254,7 @@ void *__pskb_pull_tail(struct sk_buff *s
 		/* Free pulled out fragments. */
 		while ((list = skb_shinfo(skb)->frag_list) != insp) {
 			skb_shinfo(skb)->frag_list = list->next;
-			kfree_skb(list);
+			consume_skb(list);
 		}
 		/* And insert new clone at head. */
 		if (clone) {
@@ -6220,7 +6220,7 @@ static int pskb_carve_frag_list(struct s
 	/* Free pulled out fragments. */
 	while ((list = shinfo->frag_list) != insp) {
 		shinfo->frag_list = list->next;
-		kfree_skb(list);
+		consume_skb(list);
 	}
 	/* And insert new clone at head. */
 	if (clone) {


