Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C07216648E9
	for <lists+stable@lfdr.de>; Tue, 10 Jan 2023 19:16:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235116AbjAJSQM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Jan 2023 13:16:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238840AbjAJSPt (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Jan 2023 13:15:49 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BDBBBF67
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 10:13:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 34572B81906
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 18:13:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 879FAC433EF;
        Tue, 10 Jan 2023 18:13:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673374426;
        bh=7CH8tDzzKIHZVnqu7GpV9Gl/OscIOcxbwrIV8sJjBVw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DIJKVLKG8ItbwjUJDn3m1m1YsxPJnhMzCOQ7vkPSubBa3cleMqPO2zqW8D71cIVhN
         KvuuHNufrGI9s/Ws3HsdZEk2XmZ7zONjAhm8usOH1+MTL+oy0NPJd7hzvR/6Rksi0z
         Lp/h2cFllm2BlaIpEE6g4pD35furXk6GwmYRLHLk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Anand Parthasarathy <anpartha@meta.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Martin KaFai Lau <martin.lau@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 014/159] bpf: pull before calling skb_postpull_rcsum()
Date:   Tue, 10 Jan 2023 19:02:42 +0100
Message-Id: <20230110180018.761704912@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230110180018.288460217@linuxfoundation.org>
References: <20230110180018.288460217@linuxfoundation.org>
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
index a368edd9057c..0c2666e041d3 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -3184,15 +3184,18 @@ static int bpf_skb_generic_push(struct sk_buff *skb, u32 off, u32 len)
 
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



