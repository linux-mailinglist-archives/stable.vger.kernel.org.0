Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0123A4ABC1E
	for <lists+stable@lfdr.de>; Mon,  7 Feb 2022 12:45:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384889AbiBGLaa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Feb 2022 06:30:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383937AbiBGLYJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Feb 2022 06:24:09 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14D07C043181;
        Mon,  7 Feb 2022 03:24:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A64956149A;
        Mon,  7 Feb 2022 11:24:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8165CC004E1;
        Mon,  7 Feb 2022 11:24:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644233048;
        bh=hJ6rLeDugcDbgb7axyWE3/LpJGLdMRgLTJPxwtGqhJs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Gt3HzSFDM1L0ZarUsbjW9ksnIiVasL8Q3avySaILDNUKgjTkTWZ8C5nvuMYqQaSfs
         UlrYtihtewZY2T8LGNU3eRl2NWZt8ouKj7psaptQyBNdMPudEpZaaYZjSkxZ58pok3
         tTpJ5V++sLBxqEcF60eoGki6BN9RfK/Z6vb/oWpM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Waiman Long <longman@redhat.com>,
        Phil Auld <pauld@redhat.com>, Tejun Heo <tj@kernel.org>
Subject: [PATCH 5.10 73/74] cgroup/cpuset: Fix "suspicious RCU usage" lockdep warning
Date:   Mon,  7 Feb 2022 12:07:11 +0100
Message-Id: <20220207103759.621863124@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220207103757.232676988@linuxfoundation.org>
References: <20220207103757.232676988@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Waiman Long <longman@redhat.com>

commit 2bdfd2825c9662463371e6691b1a794e97fa36b4 upstream.

It was found that a "suspicious RCU usage" lockdep warning was issued
with the rcu_read_lock() call in update_sibling_cpumasks().  It is
because the update_cpumasks_hier() function may sleep. So we have
to release the RCU lock, call update_cpumasks_hier() and reacquire
it afterward.

Also add a percpu_rwsem_assert_held() in update_sibling_cpumasks()
instead of stating that in the comment.

Fixes: 4716909cc5c5 ("cpuset: Track cpusets that use parent's effective_cpus")
Signed-off-by: Waiman Long <longman@redhat.com>
Tested-by: Phil Auld <pauld@redhat.com>
Reviewed-by: Phil Auld <pauld@redhat.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/cgroup/cpuset.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -1481,10 +1481,15 @@ static void update_sibling_cpumasks(stru
 	struct cpuset *sibling;
 	struct cgroup_subsys_state *pos_css;
 
+	percpu_rwsem_assert_held(&cpuset_rwsem);
+
 	/*
 	 * Check all its siblings and call update_cpumasks_hier()
 	 * if their use_parent_ecpus flag is set in order for them
 	 * to use the right effective_cpus value.
+	 *
+	 * The update_cpumasks_hier() function may sleep. So we have to
+	 * release the RCU read lock before calling it.
 	 */
 	rcu_read_lock();
 	cpuset_for_each_child(sibling, pos_css, parent) {
@@ -1492,8 +1497,13 @@ static void update_sibling_cpumasks(stru
 			continue;
 		if (!sibling->use_parent_ecpus)
 			continue;
+		if (!css_tryget_online(&sibling->css))
+			continue;
 
+		rcu_read_unlock();
 		update_cpumasks_hier(sibling, tmp);
+		rcu_read_lock();
+		css_put(&sibling->css);
 	}
 	rcu_read_unlock();
 }


