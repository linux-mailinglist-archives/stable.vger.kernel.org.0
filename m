Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98F8C664835
	for <lists+stable@lfdr.de>; Tue, 10 Jan 2023 19:10:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238883AbjAJSKK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Jan 2023 13:10:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238871AbjAJSJY (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Jan 2023 13:09:24 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADB9DBE23
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 10:06:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4A7FF61871
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 18:06:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F1C2C433EF;
        Tue, 10 Jan 2023 18:06:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673374017;
        bh=ErIq4vTDpbGNAq8PeOv5RhOvAPs6LHJJFbtxqI0MTgg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aZ5A5UH/y3S0fdkwWSf+Kmbov4jtlyG0HSOZVaRVrk8/MXrjk5GNXZ+6LnEX6HJ1z
         dSQVtPpd3w8RQl6cucngPohtkayX70+1JByk36lky21cTRmyEOgCfR/YoZ2MJqKm4g
         Do+x+qmfP9mqtVyKVHTlnwcIDSNNJ36BUaxCbUAc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Anand Parthasarathy <anpartha@meta.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Martin KaFai Lau <martin.lau@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 014/148] bpf: pull before calling skb_postpull_rcsum()
Date:   Tue, 10 Jan 2023 19:01:58 +0100
Message-Id: <20230110180017.642708055@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230110180017.145591678@linuxfoundation.org>
References: <20230110180017.145591678@linuxfoundation.org>
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

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit 54c3f1a81421f85e60ae2eaae7be3727a09916ee ]

Anand hit a BUG() when pulling off headers on egress to a SW tunnel.
We get to skb_checksum_help() with an invalid checksum offset
(commit d7ea0d9df2a6 ("net: remove two BUG() from skb_checksum_help()")
converted those BUGs to WARN_ONs()).
He points out oddness in how skb_postpull_rcsum() gets used.
Indeed looks like we should pull before "postpull", otherwise
the CHECKSUM_PARTIAL fixup from skb_postpull_rcsum() will not
be able to do its job:

	if (skb->ip_summed == CHECKSUM_PARTIAL &&
	    skb_checksum_start_offset(skb) < 0)
		skb->ip_summed = CHECKSUM_NONE;

Reported-by: Anand Parthasarathy <anpartha@meta.com>
Fixes: 6578171a7ff0 ("bpf: add bpf_skb_change_proto helper")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Acked-by: Stanislav Fomichev <sdf@google.com>
Link: https://lore.kernel.org/r/20221220004701.402165-1-kuba@kernel.org
Signed-off-by: Martin KaFai Lau <martin.lau@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/filter.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/net/core/filter.c b/net/core/filter.c
index 3aae1885b970..50d685be517d 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -3182,15 +3182,18 @@ static int bpf_skb_generic_push(struct sk_buff *skb, u32 off, u32 len)
 
 static int bpf_skb_generic_pop(struct sk_buff *skb, u32 off, u32 len)
 {
+	void *old_data;
+
 	/* skb_ensure_writable() is not needed here, as we're
 	 * already working on an uncloned skb.
 	 */
 	if (unlikely(!pskb_may_pull(skb, off + len)))
 		return -ENOMEM;
 
-	skb_postpull_rcsum(skb, skb->data + off, len);
-	memmove(skb->data + len, skb->data, off);
+	old_data = skb->data;
 	__skb_pull(skb, len);
+	skb_postpull_rcsum(skb, old_data + off, len);
+	memmove(skb->data, old_data, off);
 
 	return 0;
 }
-- 
2.35.1



