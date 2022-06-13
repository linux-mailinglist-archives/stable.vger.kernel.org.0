Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 853AA548C67
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:12:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378567AbiFMNlw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 09:41:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379193AbiFMNkB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 09:40:01 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 682B1FFF;
        Mon, 13 Jun 2022 04:29:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id CEF91CE116E;
        Mon, 13 Jun 2022 11:29:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB234C34114;
        Mon, 13 Jun 2022 11:29:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655119780;
        bh=jC3Qa2+8AWIZhkfpYbOEHdB/jRcXKKWqEo8ePkeuK8w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nDcln9u95LVLp/MVACPBIRXmL7AlwkwlheuSpTwWpYzqgcYSoJaZtjfVYoNOteqCO
         D1K+LKYGa7W18Sb5mW5mnITN/hsX2H93RdS8rf3kGs+8ACsCXhNhGqcs2u7mtC9FAy
         K0trO9Ix9cYRS3N2tD5OwfQprP7YRpMGKorBAtRE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ivan Kozik <ivan@ludios.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 117/339] sched/autogroup: Fix sysctl move
Date:   Mon, 13 Jun 2022 12:09:02 +0200
Message-Id: <20220613094930.055964897@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094926.497929857@linuxfoundation.org>
References: <20220613094926.497929857@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Peter Zijlstra <peterz@infradead.org>

[ Upstream commit 82f586f923e3ac6062bc7867717a7f8afc09e0ff ]

Ivan reported /proc/sys/kernel/sched_autogroup_enabled went walk-about
and using the noautogroup command line parameter would result in a
boot error message.

Turns out the sysctl move placed the init function wrong.

Fixes: c8eaf6ac76f4 ("sched: move autogroup sysctls into its own file")
Reported-by: Ivan Kozik <ivan@ludios.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Tested-by: Ivan Kozik <ivan@ludios.org>
Link: https://lkml.kernel.org/r/YpR2IqndgsyMzN00@worktop.programming.kicks-ass.net
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/autogroup.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/sched/autogroup.c b/kernel/sched/autogroup.c
index 16092b49ff6a..4ebaf97f7bd8 100644
--- a/kernel/sched/autogroup.c
+++ b/kernel/sched/autogroup.c
@@ -36,6 +36,7 @@ void __init autogroup_init(struct task_struct *init_task)
 	kref_init(&autogroup_default.kref);
 	init_rwsem(&autogroup_default.lock);
 	init_task->signal->autogroup = &autogroup_default;
+	sched_autogroup_sysctl_init();
 }
 
 void autogroup_free(struct task_group *tg)
@@ -219,7 +220,6 @@ void sched_autogroup_exit(struct signal_struct *sig)
 static int __init setup_autogroup(char *str)
 {
 	sysctl_sched_autogroup_enabled = 0;
-	sched_autogroup_sysctl_init();
 
 	return 1;
 }
-- 
2.35.1



