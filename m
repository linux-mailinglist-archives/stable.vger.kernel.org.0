Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1DE154B7B61
	for <lists+stable@lfdr.de>; Wed, 16 Feb 2022 00:51:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244665AbiBOXvH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Feb 2022 18:51:07 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:43062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233263AbiBOXvH (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Feb 2022 18:51:07 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 758E1C4E25
        for <stable@vger.kernel.org>; Tue, 15 Feb 2022 15:50:56 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id h7-20020a17090a648700b001b927560c2bso833276pjj.1
        for <stable@vger.kernel.org>; Tue, 15 Feb 2022 15:50:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=CnaJAOyANRsvHgLjOZ0mZdBEgEpxIJfQBL5MTEYycqM=;
        b=OUWwvjlOfRsEQRQy/8gi6Ypu4Im7cml1hJD9k3q6gtAMH6knOsnaUMmoJTeU2mJ8a8
         BBbtBMPRqLn72zd6PPF/aBFSsxcQ7G7UnTyjEQQyAVAEqzjcJH2P4rmOlv9O2iW/+kOY
         Ej9GYWjTkxpZDjN23zE8fQRo+p/Za7eKUDfVAJAnugAYcDjXill+YQKmF3LStgX+tuJT
         5CU9C+hc6WzVPU1oBk7hcgus+yfo2z1U35Km5ZwY2mBjV9RCg6SeTMH0tjgbMM7Uu+ez
         m68d9QhpkI4+5LMPLLtPzn5WOgIiiBbgtwbwSozyZef9T27SgHcqlWSuo1xQkfBa7EBp
         4sXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=CnaJAOyANRsvHgLjOZ0mZdBEgEpxIJfQBL5MTEYycqM=;
        b=OHNScm1wHkgCO/Tycc+IjJ/Cseiof712sYJHjai3g0Ws2hoSuLweJGyic0kT/OXvqV
         ZA2/tjVOdo5++JAiCKJ7dGgfoYHmuFbotr3I32dwaL7B1GLx/AMZFNlng83kCwXtpViQ
         iqhZCsGk++MmzzUuDixkUElf951YZQaOqq35xaXF4temtFXS/LchCX/Z1auslirmaR30
         Frozp+2O48icMqsQ24arW3jQMCDN6VEM5Pu97l2WDbOnKoUybPkuSI6H4vyDvVa9cbCg
         dLILLfV/cSVb/FEjOHMlcK/6EEt4WmmXYMSFi6mXXLJ1z3d0UiJRPs5rjBdvjU2T4X96
         dNPg==
X-Gm-Message-State: AOAM530IHJhzcKrX4inSArZi02vGTR0Wl3NB2lV2ZUnUptsjAEk1dfGI
        kVFUTysezopNvO4PQeYCqp8=
X-Google-Smtp-Source: ABdhPJzqnQlN9Cs7d/OIj4JGQ5BCYCuD/AC6v0AsjYpcdzJ04laMfuOy5K2IM/tN2rz09UsnD2x5NA==
X-Received: by 2002:a17:902:e94c:: with SMTP id b12mr1401267pll.161.1644969055909;
        Tue, 15 Feb 2022 15:50:55 -0800 (PST)
Received: from moon.. (FL1-110-233-204-67.tky.mesh.ad.jp. [110.233.204.67])
        by smtp.gmail.com with ESMTPSA id x34sm4930379pfh.178.2022.02.15.15.50.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Feb 2022 15:50:54 -0800 (PST)
From:   Masami Ichikawa <masami256@gmail.com>
To:     cip-dev@lists.cip-project.org
Cc:     "Eric W. Biederman" <ebiederm@xmission.com>,
        Tabitha Sable <tabitha.c.sable@gmail.com>,
        stable@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        =?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Masami Ichikawa <masami.ichikawa@cybertrust.co.jp>
Subject: [PATCH for 4.4.y-cip] cgroup-v1: Require capabilities to set release_agent
Date:   Wed, 16 Feb 2022 08:40:37 +0900
Message-Id: <20220215234036.19800-1-masami256@gmail.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Eric W. Biederman" <ebiederm@xmission.com>

commit 24f6008564183aa120d07c03d9289519c2fe02af upstream.

The cgroup release_agent is called with call_usermodehelper.  The function
call_usermodehelper starts the release_agent with a full set fo capabilities.
Therefore require capabilities when setting the release_agaent.

Reported-by: Tabitha Sable <tabitha.c.sable@gmail.com>
Tested-by: Tabitha Sable <tabitha.c.sable@gmail.com>
Fixes: 81a6a5cdd2c5 ("Task Control Groups: automatic userspace notification of idle cgroups")
Cc: stable@vger.kernel.org # v2.6.24+
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
[mkoutny: Adjust for pre-fs_context, duplicate mount/remount check, drop log messages.]
Acked-by: Michal Koutný <mkoutny@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[masami: Backport patch from 4.9. Adjust to use current_user_ns() to get current user_ns.
Fix conflict in cgroup_release_agent_write().]
Reference: CVE-2022-0492
Signed-off-by: Masami Ichikawa(CIP) <masami.ichikawa@cybertrust.co.jp>
---
 kernel/cgroup.c | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 1f5e7dcbfd40..af521a3da21c 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -1786,6 +1786,13 @@ static int cgroup_remount(struct kernfs_root *kf_root, int *flags, char *data)
 		pr_warn("option changes via remount are deprecated (pid=%d comm=%s)\n",
 			task_tgid_nr(current), current->comm);
 
+	/* See cgroup_mount release_agent handling */
+	if (opts.release_agent &&
+	    ((current_user_ns() != &init_user_ns) || !capable(CAP_SYS_ADMIN))) {
+		ret = -EINVAL;
+		goto out_unlock;
+	}
+
 	added_mask = opts.subsys_mask & ~root->subsys_mask;
 	removed_mask = root->subsys_mask & ~opts.subsys_mask;
 
@@ -2135,6 +2142,16 @@ static struct dentry *cgroup_mount(struct file_system_type *fs_type,
 		goto out_unlock;
 	}
 
+	/*
+	 * Release agent gets called with all capabilities,
+	 * require capabilities to set release agent.
+	 */
+	if (opts.release_agent &&
+	    ((current_user_ns() != &init_user_ns) || !capable(CAP_SYS_ADMIN))) {
+		ret = -EINVAL;
+		goto out_unlock;
+	}
+
 	root = kzalloc(sizeof(*root), GFP_KERNEL);
 	if (!root) {
 		ret = -ENOMEM;
@@ -2839,6 +2856,14 @@ static ssize_t cgroup_release_agent_write(struct kernfs_open_file *of,
 
 	BUILD_BUG_ON(sizeof(cgrp->root->release_agent_path) < PATH_MAX);
 
+	/*
+	 * Release agent gets called with all capabilities,
+	 * require capabilities to set release agent.
+	 */
+	if ((of->file->f_cred->user_ns != &init_user_ns) ||
+		!capable(CAP_SYS_ADMIN))
+			return -EPERM;
+
 	cgrp = cgroup_kn_lock_live(of->kn);
 	if (!cgrp)
 		return -ENODEV;
-- 
2.35.1

