Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0651540E7B
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 20:58:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353998AbiFGSz0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 14:55:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353848AbiFGSqM (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 14:46:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0386518C056;
        Tue,  7 Jun 2022 10:59:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BC9E761804;
        Tue,  7 Jun 2022 17:59:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA034C34115;
        Tue,  7 Jun 2022 17:59:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654624775;
        bh=nWt4wUDnnEvLJTmQdlN93TVR6sDNPCVwj5jBLGUviy0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jlSLE6DeHAOcOjEdOVM0ys4A2mWDPb8CYmqnCNtq3gZmr1MxXIvk846gYeHz5Xb1m
         08hBYIpjZKXYxi+4vIJKN2x4iLKpgzikjE/L7cM1hh9fM0Ye++rdONbgaT+uP6k2fm
         PoykHrmBu3pB12GT7bgdYHkcE0uy50TzX48IemrY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexey Dobriyan <adobriyan@gmail.com>,
        hui li <juanfengpy@gmail.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 450/667] proc: fix dentry/inode overinstantiating under /proc/${pid}/net
Date:   Tue,  7 Jun 2022 19:01:55 +0200
Message-Id: <20220607164948.213565442@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164934.766888869@linuxfoundation.org>
References: <20220607164934.766888869@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Alexey Dobriyan <adobriyan@gmail.com>

[ Upstream commit 7055197705709c59b8ab77e6a5c7d46d61edd96e ]

When a process exits, /proc/${pid}, and /proc/${pid}/net dentries are
flushed.  However some leaf dentries like /proc/${pid}/net/arp_cache
aren't.  That's because respective PDEs have proc_misc_d_revalidate() hook
which returns 1 and leaves dentries/inodes in the LRU.

Force revalidation/lookup on everything under /proc/${pid}/net by
inheriting proc_net_dentry_ops.

[akpm@linux-foundation.org: coding-style cleanups]
Link: https://lkml.kernel.org/r/YjdVHgildbWO7diJ@localhost.localdomain
Fixes: c6c75deda813 ("proc: fix lookup in /proc/net subdirectories after setns(2)")
Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Reported-by: hui li <juanfengpy@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/proc/generic.c  | 3 +++
 fs/proc/proc_net.c | 3 +++
 2 files changed, 6 insertions(+)

diff --git a/fs/proc/generic.c b/fs/proc/generic.c
index 5b78739e60e4..d32f69aaaa36 100644
--- a/fs/proc/generic.c
+++ b/fs/proc/generic.c
@@ -448,6 +448,9 @@ static struct proc_dir_entry *__proc_create(struct proc_dir_entry **parent,
 	proc_set_user(ent, (*parent)->uid, (*parent)->gid);
 
 	ent->proc_dops = &proc_misc_dentry_ops;
+	/* Revalidate everything under /proc/${pid}/net */
+	if ((*parent)->proc_dops == &proc_net_dentry_ops)
+		pde_force_lookup(ent);
 
 out:
 	return ent;
diff --git a/fs/proc/proc_net.c b/fs/proc/proc_net.c
index 15c2e55d2ed2..123e3c9d8674 100644
--- a/fs/proc/proc_net.c
+++ b/fs/proc/proc_net.c
@@ -363,6 +363,9 @@ static __net_init int proc_net_ns_init(struct net *net)
 
 	proc_set_user(netd, uid, gid);
 
+	/* Seed dentry revalidation for /proc/${pid}/net */
+	pde_force_lookup(netd);
+
 	err = -EEXIST;
 	net_statd = proc_net_mkdir(net, "stat", netd);
 	if (!net_statd)
-- 
2.35.1



