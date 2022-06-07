Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 144F8540E2A
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 20:53:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353177AbiFGSw6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 14:52:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347217AbiFGSsZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 14:48:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C92C1C92A;
        Tue,  7 Jun 2022 11:03:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DC513616B6;
        Tue,  7 Jun 2022 18:03:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67447C36B01;
        Tue,  7 Jun 2022 18:03:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654624984;
        bh=jR+NnDaGTHCgP0rySlQV0yuLMMr5ppYhWj7XwS5nCbE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UWwfc/DUDGxeecXI+TotGA3uCRUCMxf9rmHDLOnq/rkRlyV1uSIln6UEKthAv3r1O
         UTo3qhDM8kQi0BRL+UVhFKLlp4rd2fCOyTp4Af7+2IPttLk3S3l5JNNO5Q+Xe2fojW
         0+cZKZTeqYrYusy1GHZOjkblgV1NbD4U5Fe/0q8kyrrulkl7dpHhAKfHUDDvS1bD2Q
         7/4MyHAy5QdeAIEvnW1z1VDh3yN1xra5W/7vzcpVXPhU84TLrqcpPtNOfuw82cyLtr
         YZDNo0HoIIahQohSEg6rP2vexA2RYtU9O/uH0CwINWzpYF/X1ghC53gK8g4XsKUGZk
         WobkzFWZz434g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Guoqing Jiang <guoqing.jiang@cloud.ionos.com>,
        Donald Buczek <buczek@molgen.mpg.de>,
        Guoqing Jiang <guoqing.jiang@linux.dev>,
        Song Liu <song@kernel.org>, Sasha Levin <sashal@kernel.org>,
        linux-raid@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 18/25] md: protect md_unregister_thread from reentrancy
Date:   Tue,  7 Jun 2022 14:02:19 -0400
Message-Id: <20220607180229.482040-18-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220607180229.482040-1-sashal@kernel.org>
References: <20220607180229.482040-1-sashal@kernel.org>
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
index 85bccc53fdd1..bdbd62007ee5 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -7588,17 +7588,22 @@ EXPORT_SYMBOL(md_register_thread);
 
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

