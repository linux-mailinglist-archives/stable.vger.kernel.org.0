Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CC7C5E9173
	for <lists+stable@lfdr.de>; Sun, 25 Sep 2022 09:35:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229567AbiIYHfp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 25 Sep 2022 03:35:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229763AbiIYHfo (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 25 Sep 2022 03:35:44 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD5F113DE6
        for <stable@vger.kernel.org>; Sun, 25 Sep 2022 00:35:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6B3F2B80E80
        for <stable@vger.kernel.org>; Sun, 25 Sep 2022 07:35:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71397C433D6;
        Sun, 25 Sep 2022 07:35:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664091341;
        bh=H30ct3d2RSWkFKg0K+jG7vADeuQpz/f+7Kfd4N2PrCw=;
        h=Subject:To:Cc:From:Date:From;
        b=S0PfteVws6vgTzOPAYWoEcG0uWPHVCUHbGUl9n7XKp8OiM1B7jGaFGQQuRXtq07qd
         U4Sv6KqMGJ3hmBkUDerBkSd8KXyzVWP28hvSmCEMknyCtvZa8E3ZclSTuLcX8j0yBa
         68e12BKnJo2tjUu7PmsoASjY02YVZr9BqNF0LnfY=
Subject: FAILED: patch "[PATCH] cgroup: cgroup_get_from_id() must check the looked-up kn is a" failed to apply to 5.15-stable tree
To:     ming.lei@redhat.com, mpatalan@redhat.com,
        muneendra.kumar@broadcom.com, quic_mojha@quicinc.com, tj@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 25 Sep 2022 09:35:38 +0200
Message-ID: <1664091338227131@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

df02452f3df0 ("cgroup: cgroup_get_from_id() must check the looked-up kn is a directory")
be288169712f ("cgroup: reduce dependency on cgroup_mutex")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From df02452f3df069a59bc9e69c84435bf115cb6e37 Mon Sep 17 00:00:00 2001
From: Ming Lei <ming.lei@redhat.com>
Date: Fri, 23 Sep 2022 19:51:19 +0800
Subject: [PATCH] cgroup: cgroup_get_from_id() must check the looked-up kn is a
 directory

cgroup has to be one kernfs dir, otherwise kernel panic is caused,
especially cgroup id is provide from userspace.

Reported-by: Marco Patalano <mpatalan@redhat.com>
Fixes: 6b658c4863c1 ("scsi: cgroup: Add cgroup_get_from_id()")
Cc: Muneendra <muneendra.kumar@broadcom.com>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
Acked-by: Mukesh Ojha <quic_mojha@quicinc.com>
Cc: stable@vger.kernel.org # v5.14+
Signed-off-by: Tejun Heo <tj@kernel.org>

diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index e4bb5d57f4d1..5f2090d051ac 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -6049,6 +6049,9 @@ struct cgroup *cgroup_get_from_id(u64 id)
 	if (!kn)
 		goto out;
 
+	if (kernfs_type(kn) != KERNFS_DIR)
+		goto put;
+
 	rcu_read_lock();
 
 	cgrp = rcu_dereference(*(void __rcu __force **)&kn->priv);
@@ -6056,7 +6059,7 @@ struct cgroup *cgroup_get_from_id(u64 id)
 		cgrp = NULL;
 
 	rcu_read_unlock();
-
+put:
 	kernfs_put(kn);
 out:
 	return cgrp;

