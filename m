Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA5075EA4DF
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 13:56:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238304AbiIZL4F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 07:56:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238813AbiIZLxu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 07:53:50 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2015D48CAF;
        Mon, 26 Sep 2022 03:49:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1DDF1B80921;
        Mon, 26 Sep 2022 10:49:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FA2FC433C1;
        Mon, 26 Sep 2022 10:49:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664189372;
        bh=5Wecxc0YtwM+6k5gpDHuu2iI+A5vqPhrYMOoNyICU3w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cT+qI3IyPIsyPDE6BHWc0YO4bKH4AMAts3Fh4BYuCmm0hSV6A1YPXJE0tJLD1tOLw
         dF7yl9atS8vlnYe7Tll1EjHyFZYLUWrJ8nuh8UUDd0d4uY5cDUKrek5YjVXeKcYLyC
         qUwR1GTF1Dx8/jVCJ/bqo1AvWp5HZeUDvcBDXjys=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marco Patalano <mpatalan@redhat.com>,
        Muneendra <muneendra.kumar@broadcom.com>,
        Ming Lei <ming.lei@redhat.com>,
        Mukesh Ojha <quic_mojha@quicinc.com>, Tejun Heo <tj@kernel.org>
Subject: [PATCH 5.19 164/207] cgroup: cgroup_get_from_id() must check the looked-up kn is a directory
Date:   Mon, 26 Sep 2022 12:12:33 +0200
Message-Id: <20220926100814.011227446@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100806.522017616@linuxfoundation.org>
References: <20220926100806.522017616@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ming Lei <ming.lei@redhat.com>

commit df02452f3df069a59bc9e69c84435bf115cb6e37 upstream.

cgroup has to be one kernfs dir, otherwise kernel panic is caused,
especially cgroup id is provide from userspace.

Reported-by: Marco Patalano <mpatalan@redhat.com>
Fixes: 6b658c4863c1 ("scsi: cgroup: Add cgroup_get_from_id()")
Cc: Muneendra <muneendra.kumar@broadcom.com>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
Acked-by: Mukesh Ojha <quic_mojha@quicinc.com>
Cc: stable@vger.kernel.org # v5.14+
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/cgroup/cgroup.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -6026,6 +6026,9 @@ struct cgroup *cgroup_get_from_id(u64 id
 	if (!kn)
 		goto out;
 
+	if (kernfs_type(kn) != KERNFS_DIR)
+		goto put;
+
 	rcu_read_lock();
 
 	cgrp = rcu_dereference(*(void __rcu __force **)&kn->priv);
@@ -6033,7 +6036,7 @@ struct cgroup *cgroup_get_from_id(u64 id
 		cgrp = NULL;
 
 	rcu_read_unlock();
-
+put:
 	kernfs_put(kn);
 out:
 	return cgrp;


