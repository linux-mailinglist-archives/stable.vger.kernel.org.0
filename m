Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA59C5AA678
	for <lists+stable@lfdr.de>; Fri,  2 Sep 2022 05:42:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235033AbiIBDlm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Sep 2022 23:41:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233127AbiIBDlk (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Sep 2022 23:41:40 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D12EBB08A2
        for <stable@vger.kernel.org>; Thu,  1 Sep 2022 20:41:38 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id m34-20020a634c62000000b0042aff6dff12so531321pgl.14
        for <stable@vger.kernel.org>; Thu, 01 Sep 2022 20:41:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date;
        bh=WP7qtsk2VxFFx4oAGpcN9imq1FoJrOzfpm0TYEDsW0s=;
        b=CUJGzdgsMTZFwMZk3dY+QABwa5LsHzL1lmuAHK1qioXTMOKOt35ANguuFxRakqBuZZ
         kynfUZumS2uGS/f+phd0JAgNUaA4BIrfdsWjzO2PkxDCzwfboJEB1y9pk2jxRAh3P7QF
         OmDHym14r50Wcfl0HMwSE6Gcdb785L15Z0gOLeLwJ/zUxvHEbRViTWp3QnQGmYtcZrEB
         2pmzrY5jbLuNK0+oitd9ZDJCMst+/2nDmd2v7pK/ciLRUJSwkHOgVQ11hB2GadCqohM3
         vst1aiN4UFSbPvV4eEhcDp7u1VcnXGwUZ8C0ZE9IeptefCO+dssYHw4APoxZQ0FYZXIJ
         CvMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date;
        bh=WP7qtsk2VxFFx4oAGpcN9imq1FoJrOzfpm0TYEDsW0s=;
        b=34hei/is95f4ICeZpBH89c4DREnLlCzo9V6LaeNrlm58i0kytdUWG5vduA41qRiDi9
         osGwBswekkBLqfQsVpIgO7L5rBSvhVhymDylDId/DLGUQn9JaYFkUnfa1pk/v9VxMzGf
         /xAbiVWRELACR8ZZBGDn99efrw8zMPfO04L024qu6pJse5fAPQQwQ/2F3s1TgN/K50Hx
         DEhwD8isOAw1PWBXWHn8M/008Atu84v5HsztaLmjy8If6MNEGaAUfqFzvt7ffA4N6/nA
         MAhwelsH7a+5sCLSLwpZaBMVCm3gG+wsk42cYLrm7w/ZtWWdSF/TLjRQM2p22IuCvKfp
         CD7Q==
X-Gm-Message-State: ACgBeo2tCzIrgg7UqGmV1o694ZQsnyWdb6iiifsgbzPb6UQwztQF5+Yk
        a9fIVOGhQ2eLL5/DHb8Z0W7iKWw=
X-Google-Smtp-Source: AA6agR5Ni8zN3uWnA4MhMdqbYNlBQldZ0TtUYN6uE250OTbUuAC7dCohTYoz1LPOTzqjMbcNlAR/wDA=
X-Received: from hmarynka.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:925])
 (user=ovt job=sendgmr) by 2002:a05:6a00:4147:b0:52d:fe84:2614 with SMTP id
 bv7-20020a056a00414700b0052dfe842614mr35107661pfb.10.1662090098328; Thu, 01
 Sep 2022 20:41:38 -0700 (PDT)
Date:   Fri,  2 Sep 2022 03:41:35 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.37.2.789.g6183377224-goog
Message-ID: <20220902034135.2853973-1-ovt@google.com>
Subject: [PATCH] seccomp: fix refcounter leak if fork/clone is terminated
From:   Oleksandr Tymoshenko <ovt@google.com>
To:     linux-kernel@vger.kernel.org
Cc:     brauner@kernel.org, Oleksandr Tymoshenko <ovt@google.com>,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

release_task, where the seccomp's filter refcounter is released, is not
called for the case when the fork/clone is terminated midway by a
signal. This leaves an extra reference that prevents filter from being
destroyed even after all processes using it exit leading to a BPF JIT
memory leak. Dereference the refcounter in the failure path of the
copy_process function.

Fixes: 3a15fb6ed92c ("seccomp: release filter after task is fully dead")
Cc: Christian Brauner <brauner@kernel.org>
Cc: stable@vger.kernel.org
Signed-off-by: Oleksandr Tymoshenko <ovt@google.com>
---
 kernel/fork.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/kernel/fork.c b/kernel/fork.c
index 90c85b17bf69..20f7a3e91354 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1763,6 +1763,21 @@ static void copy_seccomp(struct task_struct *p)
 #endif
 }
 
+static void release_seccomp(struct task_struct *p)
+{
+#ifdef CONFIG_SECCOMP
+	/*
+	 * Must be called with sighand->lock held, which is common to
+	 * all threads in the group. Holding cred_guard_mutex is not
+	 * needed because this new task is not yet running and cannot
+	 * be racing exec.
+	 */
+	assert_spin_locked(&current->sighand->siglock);
+
+	seccomp_filter_release(p);
+#endif
+}
+
 SYSCALL_DEFINE1(set_tid_address, int __user *, tidptr)
 {
 	current->clear_child_tid = tidptr;
@@ -2495,6 +2510,7 @@ static __latent_entropy struct task_struct *copy_process(
 	return p;
 
 bad_fork_cancel_cgroup:
+	release_seccomp(p);
 	sched_core_free(p);
 	spin_unlock(&current->sighand->siglock);
 	write_unlock_irq(&tasklist_lock);
-- 
2.37.2.789.g6183377224-goog

