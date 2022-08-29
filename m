Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6BA4E5A486E
	for <lists+stable@lfdr.de>; Mon, 29 Aug 2022 13:10:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231168AbiH2LK0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Aug 2022 07:10:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231173AbiH2LJl (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Aug 2022 07:09:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 659E26B8E7;
        Mon, 29 Aug 2022 04:07:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1D42F611E7;
        Mon, 29 Aug 2022 11:06:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28891C433C1;
        Mon, 29 Aug 2022 11:06:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661771202;
        bh=c3mgWRxCA72LwoTlctjyeQI1EGN5ZfAcpD7L1ju73eM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zAlNC2BKIvbtvwgM/tsFPa/hiLjqnd4CsIsMVqu1pHAInlA7DmUx9UfRXadHZE2dJ
         EaWk15LRjnQA9+k7iT9R5Ff5dDqXD1FoTWIIwj25ZOPgW9tXiXhdo9i3BHcscAC/gp
         BQ7FA0sekWRO26LHD3/LXsXhlUgz/a3oVfYjPsNU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jing-Ting Wu <jing-ting.wu@mediatek.com>,
        =?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
        Mukesh Ojha <quic_mojha@quicinc.com>, Tejun Heo <tj@kernel.org>
Subject: [PATCH 5.19 004/158] cgroup: Fix race condition at rebind_subsystems()
Date:   Mon, 29 Aug 2022 12:57:34 +0200
Message-Id: <20220829105809.018206751@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220829105808.828227973@linuxfoundation.org>
References: <20220829105808.828227973@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Jing-Ting Wu <Jing-Ting.Wu@mediatek.com>

commit 763f4fb76e24959c370cdaa889b2492ba6175580 upstream.

Root cause:
The rebind_subsystems() is no lock held when move css object from A
list to B list,then let B's head be treated as css node at
list_for_each_entry_rcu().

Solution:
Add grace period before invalidating the removed rstat_css_node.

Reported-by: Jing-Ting Wu <jing-ting.wu@mediatek.com>
Suggested-by: Michal Koutný <mkoutny@suse.com>
Signed-off-by: Jing-Ting Wu <jing-ting.wu@mediatek.com>
Tested-by: Jing-Ting Wu <jing-ting.wu@mediatek.com>
Link: https://lore.kernel.org/linux-arm-kernel/d8f0bc5e2fb6ed259f9334c83279b4c011283c41.camel@mediatek.com/T/
Acked-by: Mukesh Ojha <quic_mojha@quicinc.com>
Fixes: a7df69b81aac ("cgroup: rstat: support cgroup1")
Cc: stable@vger.kernel.org # v5.13+
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/cgroup/cgroup.c |    1 +
 1 file changed, 1 insertion(+)

--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -1811,6 +1811,7 @@ int rebind_subsystems(struct cgroup_root
 
 		if (ss->css_rstat_flush) {
 			list_del_rcu(&css->rstat_css_node);
+			synchronize_rcu();
 			list_add_rcu(&css->rstat_css_node,
 				     &dcgrp->rstat_css_list);
 		}


