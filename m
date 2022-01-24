Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DB024997A7
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:29:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1448945AbiAXVO0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:14:26 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:33594 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1446928AbiAXVJl (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:09:41 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6EE6761425;
        Mon, 24 Jan 2022 21:09:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C8E9C340E5;
        Mon, 24 Jan 2022 21:09:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643058580;
        bh=pz99iXBwo3/nLwZ7y8IoW/K4Ck88weGFXJ6wv6u8PWo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OsSD/CJqRLRjhnkAjc6Sh6xUmk1qvsjKPGCq8sUtIXNB85K3ezAhzEw7bDr3v42mC
         khazCC62FiB2OiNtMKmtU8QtZwiEbV25zaFdvKg1pvY7UktnpllMVOdtG9ia6Gb1V+
         A3GmHjHnXSz/Vm4kiTgTMkXkcCVt7C1nyzeVXKyk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Antony Antony <antony.antony@secunet.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0302/1039] xfrm: state and policy should fail if XFRMA_IF_ID 0
Date:   Mon, 24 Jan 2022 19:34:51 +0100
Message-Id: <20220124184135.467108892@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
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
index 0a2d2bae28316..b571892fe10f5 100644
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
@@ -1413,8 +1418,13 @@ static int xfrm_alloc_userspi(struct sk_buff *skb, struct nlmsghdr *nlh,
 
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
@@ -1727,8 +1737,13 @@ static struct xfrm_policy *xfrm_policy_construct(struct net *net, struct xfrm_us
 
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



