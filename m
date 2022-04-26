Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7766050F438
	for <lists+stable@lfdr.de>; Tue, 26 Apr 2022 10:32:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242579AbiDZIfa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Apr 2022 04:35:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345171AbiDZIeL (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Apr 2022 04:34:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0FD66EB22;
        Tue, 26 Apr 2022 01:26:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 47DC66179E;
        Tue, 26 Apr 2022 08:26:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4757FC385A0;
        Tue, 26 Apr 2022 08:26:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650961580;
        bh=1p1Yb7l2k7G9BT7/XN3WtepUiU/Z/dfOrJ4l6vuEh9U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aerxXl9qnbZXmuFa1mh9mOc9bPOEZOZiht+nxKvVU7umdpDwOrSFPAJ9a+gzSLbS3
         DYLF9BL+zXwQBcx5rVg8oxDePDKaoyv1nq3SOg7AezGRW2Q+E4Y319wosGFsDLcH6X
         MdPmQhy7B59xpb9MK+JYyX9tgO3U+MPeY6PW+FHE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 15/53] net/sched: cls_u32: fix possible leak in u32_init_knode()
Date:   Tue, 26 Apr 2022 10:20:55 +0200
Message-Id: <20220426081736.100870781@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220426081735.651926456@linuxfoundation.org>
References: <20220426081735.651926456@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit ec5b0f605b105457f257f2870acad4a5d463984b ]

While investigating a related syzbot report,
I found that whenever call to tcf_exts_init()
from u32_init_knode() is failing, we end up
with an elevated refcount on ht->refcnt

To avoid that, only increase the refcount after
all possible errors have been evaluated.

Fixes: b9a24bb76bf6 ("net_sched: properly handle failure case of tcf_exts_init()")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Cong Wang <xiyou.wangcong@gmail.com>
Cc: Jiri Pirko <jiri@resnulli.us>
Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/cls_u32.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/sched/cls_u32.c b/net/sched/cls_u32.c
index fe246e03fcd9..5eee26cf9011 100644
--- a/net/sched/cls_u32.c
+++ b/net/sched/cls_u32.c
@@ -873,10 +873,6 @@ static struct tc_u_knode *u32_init_knode(struct tcf_proto *tp,
 	new->flags = n->flags;
 	RCU_INIT_POINTER(new->ht_down, ht);
 
-	/* bump reference count as long as we hold pointer to structure */
-	if (ht)
-		ht->refcnt++;
-
 #ifdef CONFIG_CLS_U32_PERF
 	/* Statistics may be incremented by readers during update
 	 * so we must keep them in tact. When the node is later destroyed
@@ -899,6 +895,10 @@ static struct tc_u_knode *u32_init_knode(struct tcf_proto *tp,
 		return NULL;
 	}
 
+	/* bump reference count as long as we hold pointer to structure */
+	if (ht)
+		ht->refcnt++;
+
 	return new;
 }
 
-- 
2.35.1



