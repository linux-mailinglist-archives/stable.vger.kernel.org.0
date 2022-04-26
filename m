Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 850B950F567
	for <lists+stable@lfdr.de>; Tue, 26 Apr 2022 10:53:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345368AbiDZIlN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Apr 2022 04:41:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346083AbiDZIj4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Apr 2022 04:39:56 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE50014F5C5;
        Tue, 26 Apr 2022 01:32:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4882AB81A2F;
        Tue, 26 Apr 2022 08:32:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99C68C385A4;
        Tue, 26 Apr 2022 08:32:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650961957;
        bh=qJElKM3bo1SkWeLi6iv1TcKsTrwPNIpEs25oiPoGzHU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FBAdIYPJUP0/HOJdChMTRlFKr9icMZD9ujp+otTVMurOYo3WQ0cpmUOmA/qWTESXJ
         5eON5F/Ly7WwUv/iDD1ef+EUxCJ7qTMIUigwPEsFOxJS+4W9qfhGFYHsRJRX4bYc28
         DPm/i7J/M+AwpyNMHeT0k7le/IPMviWA3m8xIOIE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 24/86] net/sched: cls_u32: fix possible leak in u32_init_knode()
Date:   Tue, 26 Apr 2022 10:20:52 +0200
Message-Id: <20220426081741.908474097@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220426081741.202366502@linuxfoundation.org>
References: <20220426081741.202366502@linuxfoundation.org>
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
index b61db335c49d..da042bc8b239 100644
--- a/net/sched/cls_u32.c
+++ b/net/sched/cls_u32.c
@@ -814,10 +814,6 @@ static struct tc_u_knode *u32_init_knode(struct net *net, struct tcf_proto *tp,
 	new->flags = n->flags;
 	RCU_INIT_POINTER(new->ht_down, ht);
 
-	/* bump reference count as long as we hold pointer to structure */
-	if (ht)
-		ht->refcnt++;
-
 #ifdef CONFIG_CLS_U32_PERF
 	/* Statistics may be incremented by readers during update
 	 * so we must keep them in tact. When the node is later destroyed
@@ -839,6 +835,10 @@ static struct tc_u_knode *u32_init_knode(struct net *net, struct tcf_proto *tp,
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



