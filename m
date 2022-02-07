Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 582854ABDC8
	for <lists+stable@lfdr.de>; Mon,  7 Feb 2022 13:05:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1389086AbiBGLqD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Feb 2022 06:46:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1386774AbiBGLgj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Feb 2022 06:36:39 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F578C0401C0;
        Mon,  7 Feb 2022 03:36:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5E6E0B8112C;
        Mon,  7 Feb 2022 11:36:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6E5AC004E1;
        Mon,  7 Feb 2022 11:36:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644233796;
        bh=A8AXPBtYBDFFG2VgJ8Qp7mlnjDSOfbScHXZaILBJqkY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xAAVsUUEOFOgNoXcxoFsLN1dL25gRCcHHENquP+n9yn/oSqA1c8fZTPkMvhO4Y92G
         OIEcUAX+f+zuRRgMQWu703g1qGYBY4zEPnto2I9+78i/VdH8BeYitiFeiIZnlfwhLC
         IZhK5gKTVkCdmbTQyLuzL8+fUqM03XDWOKQUkFgs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Waiman Long <longman@redhat.com>,
        Phil Auld <pauld@redhat.com>, Tejun Heo <tj@kernel.org>
Subject: [PATCH 5.16 121/126] cgroup/cpuset: Fix "suspicious RCU usage" lockdep warning
Date:   Mon,  7 Feb 2022 12:07:32 +0100
Message-Id: <20220207103808.231751970@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220207103804.053675072@linuxfoundation.org>
References: <20220207103804.053675072@linuxfoundation.org>
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
@@ -1530,10 +1530,15 @@ static void update_sibling_cpumasks(stru
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
@@ -1541,8 +1546,13 @@ static void update_sibling_cpumasks(stru
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


