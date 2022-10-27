Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F56560FDB8
	for <lists+stable@lfdr.de>; Thu, 27 Oct 2022 18:58:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236580AbiJ0Q6V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Oct 2022 12:58:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236592AbiJ0Q6U (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Oct 2022 12:58:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 339FE17D28B
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 09:58:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DF38EB826F9
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 16:58:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A2CBC433C1;
        Thu, 27 Oct 2022 16:58:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666889896;
        bh=gWEe51behrIY2+op2PTQtXCr0ihSuGro0sRg+A70xpQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UhW1sp1M9HKqG3TFC/eqa1mkY5//4wPTw0yoZnrLnU8BAA61xFHCBSyHSAAMveP9Q
         9UnFwZ1BLPL2PrQ9O2fc+Xao9a+fmDYtYaydCooQLHew9B4noMdqrAvEENgoRGuqMg
         URcMhxLJ5bojVUVE2DHoQh4NIFd5n/wtOYa2m2v0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 40/94] tls: strp: make sure the TCP skbs do not have overlapping data
Date:   Thu, 27 Oct 2022 18:54:42 +0200
Message-Id: <20221027165058.739245641@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221027165057.208202132@linuxfoundation.org>
References: <20221027165057.208202132@linuxfoundation.org>
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

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit 0d87bbd39d7fd1135ab9eca672d760470f6508e8 ]

TLS tries to get away with using the TCP input queue directly.
This does not work if there is duplicated data (multiple skbs
holding bytes for the same seq number range due to retransmits).
Check for this condition and fall back to copy mode, it should
be rare.

Fixes: 84c61fe1a75b ("tls: rx: do not use the standard strparser")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/tls/tls_strp.c | 32 ++++++++++++++++++++++++++++----
 1 file changed, 28 insertions(+), 4 deletions(-)

diff --git a/net/tls/tls_strp.c b/net/tls/tls_strp.c
index 9b79e334dbd9..955ac3e0bf4d 100644
--- a/net/tls/tls_strp.c
+++ b/net/tls/tls_strp.c
@@ -273,7 +273,7 @@ static int tls_strp_read_copyin(struct tls_strparser *strp)
 	return desc.error;
 }
 
-static int tls_strp_read_short(struct tls_strparser *strp)
+static int tls_strp_read_copy(struct tls_strparser *strp, bool qshort)
 {
 	struct skb_shared_info *shinfo;
 	struct page *page;
@@ -283,7 +283,7 @@ static int tls_strp_read_short(struct tls_strparser *strp)
 	 * to read the data out. Otherwise the connection will stall.
 	 * Without pressure threshold of INT_MAX will never be ready.
 	 */
-	if (likely(!tcp_epollin_ready(strp->sk, INT_MAX)))
+	if (likely(qshort && !tcp_epollin_ready(strp->sk, INT_MAX)))
 		return 0;
 
 	shinfo = skb_shinfo(strp->anchor);
@@ -315,6 +315,27 @@ static int tls_strp_read_short(struct tls_strparser *strp)
 	return 0;
 }
 
+static bool tls_strp_check_no_dup(struct tls_strparser *strp)
+{
+	unsigned int len = strp->stm.offset + strp->stm.full_len;
+	struct sk_buff *skb;
+	u32 seq;
+
+	skb = skb_shinfo(strp->anchor)->frag_list;
+	seq = TCP_SKB_CB(skb)->seq;
+
+	while (skb->len < len) {
+		seq += skb->len;
+		len -= skb->len;
+		skb = skb->next;
+
+		if (TCP_SKB_CB(skb)->seq != seq)
+			return false;
+	}
+
+	return true;
+}
+
 static void tls_strp_load_anchor_with_queue(struct tls_strparser *strp, int len)
 {
 	struct tcp_sock *tp = tcp_sk(strp->sk);
@@ -373,7 +394,7 @@ static int tls_strp_read_sock(struct tls_strparser *strp)
 		return tls_strp_read_copyin(strp);
 
 	if (inq < strp->stm.full_len)
-		return tls_strp_read_short(strp);
+		return tls_strp_read_copy(strp, true);
 
 	if (!strp->stm.full_len) {
 		tls_strp_load_anchor_with_queue(strp, inq);
@@ -387,9 +408,12 @@ static int tls_strp_read_sock(struct tls_strparser *strp)
 		strp->stm.full_len = sz;
 
 		if (!strp->stm.full_len || inq < strp->stm.full_len)
-			return tls_strp_read_short(strp);
+			return tls_strp_read_copy(strp, true);
 	}
 
+	if (!tls_strp_check_no_dup(strp))
+		return tls_strp_read_copy(strp, false);
+
 	strp->msg_ready = 1;
 	tls_rx_msg_ready(strp);
 
-- 
2.35.1



