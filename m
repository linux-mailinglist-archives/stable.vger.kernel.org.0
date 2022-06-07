Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99712540B84
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 20:29:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350976AbiFGS3b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 14:29:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352193AbiFGSZh (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 14:25:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F044AF45E7;
        Tue,  7 Jun 2022 10:54:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CE5A0B82370;
        Tue,  7 Jun 2022 17:54:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1DF3C341C5;
        Tue,  7 Jun 2022 17:54:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654624466;
        bh=GmTmEoKMELgeb+7KwRtxj81u5wokKuWO8GhID1OMUk8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H0PpgQlXmAHEL17/hkFKIc8E4oGGNRRp6CO5JeoXPsPHLXNIt7QwpD2UWegfLeYFb
         dn/ILgL9u6WDlo7HV3B3GXWOWGWOM1d3XxzePdlQ19J3bSjckP2OkNVR1tq30qaeS+
         aF1ZnEiNIBOwfRiCd1lvP2eY/Apt+3bWLuMpTLmyCK3ZCEThWTRsS/xOYBnXCEX46p
         Kjcj02/6whilAAw8fAW/w/4NCEdKDbbRKY/Ns7YkiiE6BcEV2tugyxw93m7hExjhhc
         0qMimINFuWhKMvh/YMjqVQDXrX0sR/YdxGcsIG7qitrXzXsj21A2Jz1WNZ73JF43Da
         FIJlSWG4ujUeQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Guoqing Jiang <guoqing.jiang@cloud.ionos.com>,
        Donald Buczek <buczek@molgen.mpg.de>,
        Guoqing Jiang <guoqing.jiang@linux.dev>,
        Song Liu <song@kernel.org>, Sasha Levin <sashal@kernel.org>,
        linux-raid@vger.kernel.org
Subject: [PATCH AUTOSEL 5.17 34/60] md: protect md_unregister_thread from reentrancy
Date:   Tue,  7 Jun 2022 13:52:31 -0400
Message-Id: <20220607175259.478835-34-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220607175259.478835-1-sashal@kernel.org>
References: <20220607175259.478835-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

From: Guoqing Jiang <guoqing.jiang@cloud.ionos.com>

[ Upstream commit 1e267742283a4b5a8ca65755c44166be27e9aa0f ]

Generally, the md_unregister_thread is called with reconfig_mutex, but
raid_message in dm-raid doesn't hold reconfig_mutex to unregister thread,
so md_unregister_thread can be called simulitaneously from two call sites
in theory.

Then after previous commit which remove the protection of reconfig_mutex
for md_unregister_thread completely, the potential issue could be worse
than before.

Let's take pers_lock at the beginning of function to ensure reentrancy.

Reported-by: Donald Buczek <buczek@molgen.mpg.de>
Signed-off-by: Guoqing Jiang <guoqing.jiang@linux.dev>
Signed-off-by: Song Liu <song@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/md.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 8efe9c8ff937..7cfd4aaa6428 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -7964,17 +7964,22 @@ EXPORT_SYMBOL(md_register_thread);
 
 void md_unregister_thread(struct md_thread **threadp)
 {
-	struct md_thread *thread = *threadp;
-	if (!thread)
-		return;
-	pr_debug("interrupting MD-thread pid %d\n", task_pid_nr(thread->tsk));
-	/* Locking ensures that mddev_unlock does not wake_up a
+	struct md_thread *thread;
+
+	/*
+	 * Locking ensures that mddev_unlock does not wake_up a
 	 * non-existent thread
 	 */
 	spin_lock(&pers_lock);
+	thread = *threadp;
+	if (!thread) {
+		spin_unlock(&pers_lock);
+		return;
+	}
 	*threadp = NULL;
 	spin_unlock(&pers_lock);
 
+	pr_debug("interrupting MD-thread pid %d\n", task_pid_nr(thread->tsk));
 	kthread_stop(thread->tsk);
 	kfree(thread);
 }
-- 
2.35.1

