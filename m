Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 874EE5F29F7
	for <lists+stable@lfdr.de>; Mon,  3 Oct 2022 09:29:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230169AbiJCH3R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Oct 2022 03:29:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231172AbiJCH2J (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Oct 2022 03:28:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDCB6C6B;
        Mon,  3 Oct 2022 00:19:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8275860FA2;
        Mon,  3 Oct 2022 07:17:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95C15C433D7;
        Mon,  3 Oct 2022 07:17:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664781467;
        bh=vS+9SYW7kd6xHNsujI0Rd9vRK7JVdZ14PAQh+RhulaA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iQ070zOKIM4feWa8DR4Y79aszH2PFJaRglkatPwdZ8Sk3ioCryB1AT4KFTF6lqyH0
         mukx5OyqURxhA8Hg4aodM6saM11W2qcfFvBUNQO3VDKY0/9Q2EUkeMNrozs0+nUZ51
         Y9S5mutjB07gQuikLwkpSjCrB1RIClFDG52Xvoq8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marco Patalano <mpatalan@redhat.com>,
        Muneendra <muneendra.kumar@broadcom.com>,
        Ming Lei <ming.lei@redhat.com>,
        Mukesh Ojha <quic_mojha@quicinc.com>,
        Tejun Heo <tj@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 06/83] cgroup: cgroup_get_from_id() must check the looked-up kn is a directory
Date:   Mon,  3 Oct 2022 09:10:31 +0200
Message-Id: <20221003070722.143782710@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221003070721.971297651@linuxfoundation.org>
References: <20221003070721.971297651@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ming Lei <ming.lei@redhat.com>

[ Upstream commit df02452f3df069a59bc9e69c84435bf115cb6e37 ]

cgroup has to be one kernfs dir, otherwise kernel panic is caused,
especially cgroup id is provide from userspace.

Reported-by: Marco Patalano <mpatalan@redhat.com>
Fixes: 6b658c4863c1 ("scsi: cgroup: Add cgroup_get_from_id()")
Cc: Muneendra <muneendra.kumar@broadcom.com>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
Acked-by: Mukesh Ojha <quic_mojha@quicinc.com>
Cc: stable@vger.kernel.org # v5.14+
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/cgroup/cgroup.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index 97282d6b5d18..4b19f7fc4deb 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -6025,6 +6025,9 @@ struct cgroup *cgroup_get_from_id(u64 id)
 	if (!kn)
 		goto out;
 
+	if (kernfs_type(kn) != KERNFS_DIR)
+		goto put;
+
 	rcu_read_lock();
 
 	cgrp = rcu_dereference(*(void __rcu __force **)&kn->priv);
@@ -6032,7 +6035,7 @@ struct cgroup *cgroup_get_from_id(u64 id)
 		cgrp = NULL;
 
 	rcu_read_unlock();
-
+put:
 	kernfs_put(kn);
 out:
 	return cgrp;
-- 
2.35.1



