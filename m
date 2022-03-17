Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE7444DC664
	for <lists+stable@lfdr.de>; Thu, 17 Mar 2022 13:50:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234007AbiCQMvs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Mar 2022 08:51:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234009AbiCQMv1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Mar 2022 08:51:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4939A1F2DF6;
        Thu, 17 Mar 2022 05:49:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D80F861228;
        Thu, 17 Mar 2022 12:49:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8CE2C36AE7;
        Thu, 17 Mar 2022 12:49:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647521357;
        bh=UhQNUoxsJHByRYAMviZMXY6gdrwlMtN6HZUq7vp/B5U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a27PEyn7Y+dnTIfGTodQBFWmZgGE+t2tzQgeYOJ7AmwLMNLPX0gVwMRuTGp3tGMG/
         esKdAL+7AyZFAITAYTdx0inkf3qwvu8KW9VIH4RpO46rejBmKVFLMPzq/3aYdXMfc/
         2qVNtLloRZqvguAjA/xTpeqOMlmqurxY7vdNcUDA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kai Lueke <kailueke@linux.microsoft.com>,
        Steffen Klassert <steffen.klassert@secunet.com>
Subject: [PATCH 5.10 01/23] Revert "xfrm: state and policy should fail if XFRMA_IF_ID 0"
Date:   Thu, 17 Mar 2022 13:45:42 +0100
Message-Id: <20220317124525.999854626@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220317124525.955110315@linuxfoundation.org>
References: <20220317124525.955110315@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kai Lueke <kailueke@linux.microsoft.com>

commit a3d9001b4e287fc043e5539d03d71a32ab114bcb upstream.

This reverts commit 68ac0f3810e76a853b5f7b90601a05c3048b8b54 because ID
0 was meant to be used for configuring the policy/state without
matching for a specific interface (e.g., Cilium is affected, see
https://github.com/cilium/cilium/pull/18789 and
https://github.com/cilium/cilium/pull/19019).

Signed-off-by: Kai Lueke <kailueke@linux.microsoft.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/xfrm/xfrm_user.c |   21 +++------------------
 1 file changed, 3 insertions(+), 18 deletions(-)

--- a/net/xfrm/xfrm_user.c
+++ b/net/xfrm/xfrm_user.c
@@ -629,13 +629,8 @@ static struct xfrm_state *xfrm_state_con
 
 	xfrm_smark_init(attrs, &x->props.smark);
 
-	if (attrs[XFRMA_IF_ID]) {
+	if (attrs[XFRMA_IF_ID])
 		x->if_id = nla_get_u32(attrs[XFRMA_IF_ID]);
-		if (!x->if_id) {
-			err = -EINVAL;
-			goto error;
-		}
-	}
 
 	err = __xfrm_init_state(x, false, attrs[XFRMA_OFFLOAD_DEV]);
 	if (err)
@@ -1371,13 +1366,8 @@ static int xfrm_alloc_userspi(struct sk_
 
 	mark = xfrm_mark_get(attrs, &m);
 
-	if (attrs[XFRMA_IF_ID]) {
+	if (attrs[XFRMA_IF_ID])
 		if_id = nla_get_u32(attrs[XFRMA_IF_ID]);
-		if (!if_id) {
-			err = -EINVAL;
-			goto out_noput;
-		}
-	}
 
 	if (p->info.seq) {
 		x = xfrm_find_acq_byseq(net, mark, p->info.seq);
@@ -1690,13 +1680,8 @@ static struct xfrm_policy *xfrm_policy_c
 
 	xfrm_mark_get(attrs, &xp->mark);
 
-	if (attrs[XFRMA_IF_ID]) {
+	if (attrs[XFRMA_IF_ID])
 		xp->if_id = nla_get_u32(attrs[XFRMA_IF_ID]);
-		if (!xp->if_id) {
-			err = -EINVAL;
-			goto error;
-		}
-	}
 
 	return xp;
  error:


