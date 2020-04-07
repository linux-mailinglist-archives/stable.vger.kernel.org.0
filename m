Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9EC2A1A0D6A
	for <lists+stable@lfdr.de>; Tue,  7 Apr 2020 14:18:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728146AbgDGMSV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Apr 2020 08:18:21 -0400
Received: from mx2.suse.de ([195.135.220.15]:47832 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726562AbgDGMSV (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Apr 2020 08:18:21 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 50ABFABE9;
        Tue,  7 Apr 2020 12:18:19 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id 02F171E1233; Tue,  7 Apr 2020 14:18:18 +0200 (CEST)
From:   Jan Kara <jack@suse.cz>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     Andrei Vagin <avagin@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, Jan Kara <jack@suse.cz>,
        stable@vger.kernel.org
Subject: [PATCH] ucount: Fix wrong inotify ucounts in /proc/sys/user
Date:   Tue,  7 Apr 2020 14:18:14 +0200
Message-Id: <20200407121814.26073-1-jack@suse.cz>
X-Mailer: git-send-email 2.16.4
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Commit 769071ac9f20 "ns: Introduce Time Namespace" broke reporting of
inotify ucounts (max_inotify_instances, max_inotify_watches) in
/proc/sys/user because it has added UCOUNT_TIME_NAMESPACES into enum
ucount_type but didn't properly update reporting in
kernel/ucount.c:setup_userns_sysctls(). Update the reporting to fix the
issue and also add BUILD_BUG_ON to catch a similar problem in the
future.

Fixes: 769071ac9f20 "ns: Introduce Time Namespace"
CC: stable@vger.kernel.org
Signed-off-by: Jan Kara <jack@suse.cz>
---
 kernel/ucount.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/kernel/ucount.c b/kernel/ucount.c
index a53cc2b4179c..11b1596e2542 100644
--- a/kernel/ucount.c
+++ b/kernel/ucount.c
@@ -69,6 +69,7 @@ static struct ctl_table user_table[] = {
 	UCOUNT_ENTRY("max_net_namespaces"),
 	UCOUNT_ENTRY("max_mnt_namespaces"),
 	UCOUNT_ENTRY("max_cgroup_namespaces"),
+	UCOUNT_ENTRY("max_time_namespaces"),
 #ifdef CONFIG_INOTIFY_USER
 	UCOUNT_ENTRY("max_inotify_instances"),
 	UCOUNT_ENTRY("max_inotify_watches"),
@@ -81,6 +82,8 @@ bool setup_userns_sysctls(struct user_namespace *ns)
 {
 #ifdef CONFIG_SYSCTL
 	struct ctl_table *tbl;
+
+	BUILD_BUG_ON(ARRAY_SIZE(user_table) != UCOUNT_COUNTS + 1);
 	setup_sysctl_set(&ns->set, &set_root, set_is_seen);
 	tbl = kmemdup(user_table, sizeof(user_table), GFP_KERNEL);
 	if (tbl) {
-- 
2.16.4

