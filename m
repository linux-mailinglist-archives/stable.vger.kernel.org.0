Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 521854990C3
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 21:07:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347343AbiAXUEJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 15:04:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349343AbiAXUCF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:02:05 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7D14C068085;
        Mon, 24 Jan 2022 11:28:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 843D96148B;
        Mon, 24 Jan 2022 19:28:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74B1CC340E5;
        Mon, 24 Jan 2022 19:28:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643052535;
        bh=7TEbViqa5qzpkns3ce5kg4p4DVWtQcObvdBdTHY3K1Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o4ZYnh75VhWTcKiYCnSh8rZGXsUXJZtUa4hVlzsy4BgbqJ9wl8EolXd2LJGc0UTih
         qoOyXp0g6LHAlBX6rUSOV3YFSMmHvTIr6pgQx5S5s0+p4pe7zANqRrCyhW1mtWyQiF
         om06ZU8zN3r+DI5uUG90K0k7hX1XB7ure4+oRNyY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Antony Antony <antony.antony@secunet.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 090/320] xfrm: state and policy should fail if XFRMA_IF_ID 0
Date:   Mon, 24 Jan 2022 19:41:14 +0100
Message-Id: <20220124183956.800549443@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124183953.750177707@linuxfoundation.org>
References: <20220124183953.750177707@linuxfoundation.org>
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
index ddcf569d852f7..42ff32700d68b 100644
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
@@ -1328,8 +1333,13 @@ static int xfrm_alloc_userspi(struct sk_buff *skb, struct nlmsghdr *nlh,
 
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
@@ -1631,8 +1641,13 @@ static struct xfrm_policy *xfrm_policy_construct(struct net *net, struct xfrm_us
 
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



