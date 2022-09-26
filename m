Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2EF295EA4E0
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 13:56:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236485AbiIZL4D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 07:56:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238374AbiIZLxb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 07:53:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3841645F51;
        Mon, 26 Sep 2022 03:49:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0572960C0D;
        Mon, 26 Sep 2022 10:49:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09F09C433D6;
        Mon, 26 Sep 2022 10:49:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664189387;
        bh=1Q+uX897ILffysQZbDfO0e/zl4cC96DqijuJesJwVPY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0u9u+1nmnYYwroAHpe4obYYhA1M9PqXow2bG/CuvD8EFAzmyE7a6cERGo4GLrh+uR
         w4kZOumGhHte5TZV+QXETzj5kRcrltguK7rIrW2DoeQhbBYMXWRQXAaptd5Ael1oCN
         5G3nM4o4NuF3CLCIJD1Zy9NPV1lwCWact8TI5NoI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Bruno de Paula Larini <bruno.larini@riosoft.com.br>,
        Florian Westphal <fw@strlen.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 140/207] netfilter: nf_ct_ftp: fix deadlock when nat rewrite is needed
Date:   Mon, 26 Sep 2022 12:12:09 +0200
Message-Id: <20220926100812.783060195@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100806.522017616@linuxfoundation.org>
References: <20220926100806.522017616@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

[ Upstream commit d25088932227680988a6b794221e031a7232f137 ]

We can't use ct->lock, this is already used by the seqadj internals.
When using ftp helper + nat, seqadj will attempt to acquire ct->lock
again.

Revert back to a global lock for now.

Fixes: c783a29c7e59 ("netfilter: nf_ct_ftp: prefer skb_linearize")
Reported-by: Bruno de Paula Larini <bruno.larini@riosoft.com.br>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_conntrack_ftp.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_conntrack_ftp.c b/net/netfilter/nf_conntrack_ftp.c
index 0d9332e9cf71..617f744a2e3a 100644
--- a/net/netfilter/nf_conntrack_ftp.c
+++ b/net/netfilter/nf_conntrack_ftp.c
@@ -33,6 +33,7 @@ MODULE_AUTHOR("Rusty Russell <rusty@rustcorp.com.au>");
 MODULE_DESCRIPTION("ftp connection tracking helper");
 MODULE_ALIAS("ip_conntrack_ftp");
 MODULE_ALIAS_NFCT_HELPER(HELPER_NAME);
+static DEFINE_SPINLOCK(nf_ftp_lock);
 
 #define MAX_PORTS 8
 static u_int16_t ports[MAX_PORTS];
@@ -409,7 +410,8 @@ static int help(struct sk_buff *skb,
 	}
 	datalen = skb->len - dataoff;
 
-	spin_lock_bh(&ct->lock);
+	/* seqadj (nat) uses ct->lock internally, nf_nat_ftp would cause deadlock */
+	spin_lock_bh(&nf_ftp_lock);
 	fb_ptr = skb->data + dataoff;
 
 	ends_in_nl = (fb_ptr[datalen - 1] == '\n');
@@ -538,7 +540,7 @@ static int help(struct sk_buff *skb,
 	if (ends_in_nl)
 		update_nl_seq(ct, seq, ct_ftp_info, dir, skb);
  out:
-	spin_unlock_bh(&ct->lock);
+	spin_unlock_bh(&nf_ftp_lock);
 	return ret;
 }
 
-- 
2.35.1



