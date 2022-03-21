Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CBA844E2867
	for <lists+stable@lfdr.de>; Mon, 21 Mar 2022 14:56:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348397AbiCUN5I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Mar 2022 09:57:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348332AbiCUN4c (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Mar 2022 09:56:32 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB90316F06E;
        Mon, 21 Mar 2022 06:54:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 28B00B81644;
        Mon, 21 Mar 2022 13:54:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B6A4C340E8;
        Mon, 21 Mar 2022 13:54:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647870895;
        bh=wRlbELFcSaNKD9S2F10d7gbg4M2/MDxgsTY8gQvkjOM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JwoUBJZBlQL4uf5Zk5YJ+Dos/CzvSGY9UGnoICiS0X4u1xs4UCBVY/XJZj+z1qrCz
         BfAL9ZBICIKcfKWLQd4gYLpIPkZQKX0OBQ5bbKCt7555wWQ+E1OS8wMjLXT+8Jve29
         jJYxkJ/Qu2wtN+4Xg5LrwdLxy9aX4V1ko/Ltxosg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kai Lueke <kailueke@linux.microsoft.com>,
        Steffen Klassert <steffen.klassert@secunet.com>
Subject: [PATCH 4.19 01/57] Revert "xfrm: state and policy should fail if XFRMA_IF_ID 0"
Date:   Mon, 21 Mar 2022 14:51:42 +0100
Message-Id: <20220321133222.028331018@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220321133221.984120927@linuxfoundation.org>
References: <20220321133221.984120927@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
@@ -620,13 +620,8 @@ static struct xfrm_state *xfrm_state_con
 
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
@@ -1332,13 +1327,8 @@ static int xfrm_alloc_userspi(struct sk_
 
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
@@ -1640,13 +1630,8 @@ static struct xfrm_policy *xfrm_policy_c
 
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


