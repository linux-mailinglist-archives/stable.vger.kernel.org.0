Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAD094994FC
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:07:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1391991AbiAXUuL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 15:50:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1389460AbiAXUkz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:40:55 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5876C045926;
        Mon, 24 Jan 2022 11:51:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 93354B81142;
        Mon, 24 Jan 2022 19:51:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFA2EC340E7;
        Mon, 24 Jan 2022 19:51:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643053911;
        bh=jFAPDr8IEDpp7WV0gdkRVMZiZ9GFIrjnmNnKpTkCTy4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cgd+4DDmj6b3G8BsTPVcx/s+unOd4thXzCA8PME753ePS5Pf7VsXvemWYl/5mTNkC
         rBWH5fq41921d/LS8srUFZE8PMQhhIhaQDpp1b0I9YWeo/+JVt+vs6F+oynB0shvbD
         z2PSfAMO7LMg0Rc5JD7bUF/OEhCTCApkHKtq89l8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Antony Antony <antony.antony@secunet.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 174/563] xfrm: state and policy should fail if XFRMA_IF_ID 0
Date:   Mon, 24 Jan 2022 19:38:59 +0100
Message-Id: <20220124184030.428821480@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184024.407936072@linuxfoundation.org>
References: <20220124184024.407936072@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Antony Antony <antony.antony@secunet.com>

[ Upstream commit 68ac0f3810e76a853b5f7b90601a05c3048b8b54 ]

xfrm ineterface does not allow xfrm if_id = 0
fail to create or update xfrm state and policy.

With this commit:
 ip xfrm policy add src 192.0.2.1 dst 192.0.2.2 dir out if_id 0
 RTNETLINK answers: Invalid argument

 ip xfrm state add src 192.0.2.1 dst 192.0.2.2 proto esp spi 1 \
            reqid 1 mode tunnel aead 'rfc4106(gcm(aes))' \
            0x1111111111111111111111111111111111111111 96 if_id 0
 RTNETLINK answers: Invalid argument

v1->v2 change:
 - add Fixes: tag

Fixes: 9f8550e4bd9d ("xfrm: fix disable_xfrm sysctl when used on xfrm interfaces")
Signed-off-by: Antony Antony <antony.antony@secunet.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/xfrm/xfrm_user.c | 21 ++++++++++++++++++---
 1 file changed, 18 insertions(+), 3 deletions(-)

diff --git a/net/xfrm/xfrm_user.c b/net/xfrm/xfrm_user.c
index 97f7ebf5324e7..ddf1b3a5f7c1f 100644
--- a/net/xfrm/xfrm_user.c
+++ b/net/xfrm/xfrm_user.c
@@ -621,8 +621,13 @@ static struct xfrm_state *xfrm_state_construct(struct net *net,
 
 	xfrm_smark_init(attrs, &x->props.smark);
 
-	if (attrs[XFRMA_IF_ID])
+	if (attrs[XFRMA_IF_ID]) {
 		x->if_id = nla_get_u32(attrs[XFRMA_IF_ID]);
+		if (!x->if_id) {
+			err = -EINVAL;
+			goto error;
+		}
+	}
 
 	err = __xfrm_init_state(x, false, attrs[XFRMA_OFFLOAD_DEV]);
 	if (err)
@@ -1353,8 +1358,13 @@ static int xfrm_alloc_userspi(struct sk_buff *skb, struct nlmsghdr *nlh,
 
 	mark = xfrm_mark_get(attrs, &m);
 
-	if (attrs[XFRMA_IF_ID])
+	if (attrs[XFRMA_IF_ID]) {
 		if_id = nla_get_u32(attrs[XFRMA_IF_ID]);
+		if (!if_id) {
+			err = -EINVAL;
+			goto out_noput;
+		}
+	}
 
 	if (p->info.seq) {
 		x = xfrm_find_acq_byseq(net, mark, p->info.seq);
@@ -1667,8 +1677,13 @@ static struct xfrm_policy *xfrm_policy_construct(struct net *net, struct xfrm_us
 
 	xfrm_mark_get(attrs, &xp->mark);
 
-	if (attrs[XFRMA_IF_ID])
+	if (attrs[XFRMA_IF_ID]) {
 		xp->if_id = nla_get_u32(attrs[XFRMA_IF_ID]);
+		if (!xp->if_id) {
+			err = -EINVAL;
+			goto error;
+		}
+	}
 
 	return xp;
  error:
-- 
2.34.1



