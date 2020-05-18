Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18D2B1D8630
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 20:23:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730523AbgERSXo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 14:23:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:50260 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730461AbgERRtA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 May 2020 13:49:00 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5699520715;
        Mon, 18 May 2020 17:48:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589824139;
        bh=t67HidTyqvuTCFA1pM7lYbAAr9hS5Sny8fXHsx5iDYY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xBHhMa87zO9gGdOQLRfw3hbilIFEXtg9ZS9jtp8u1zfUDIF+IaYGHgC8O2dRqkP+4
         DXmxyy0fx3h4MZDR9zKym0gNDzYJUnHer7B/kaxdX8gGn5zHJmCDLI5AZXUagBMR6C
         H1CrU+8zs2tiWdjZXVnsvgiNQN1rViMYo9xE48II=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yang Yingliang <yangyingliang@huawei.com>,
        Zefan Li <lizefan@huawei.com>, Tejun Heo <tj@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 4.14 088/114] netprio_cgroup: Fix unlimited memory leak of v2 cgroups
Date:   Mon, 18 May 2020 19:37:00 +0200
Message-Id: <20200518173518.278476162@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200518173503.033975649@linuxfoundation.org>
References: <20200518173503.033975649@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zefan Li <lizefan@huawei.com>

[ Upstream commit 090e28b229af92dc5b40786ca673999d59e73056 ]

If systemd is configured to use hybrid mode which enables the use of
both cgroup v1 and v2, systemd will create new cgroup on both the default
root (v2) and netprio_cgroup hierarchy (v1) for a new session and attach
task to the two cgroups. If the task does some network thing then the v2
cgroup can never be freed after the session exited.

One of our machines ran into OOM due to this memory leak.

In the scenario described above when sk_alloc() is called
cgroup_sk_alloc() thought it's in v2 mode, so it stores
the cgroup pointer in sk->sk_cgrp_data and increments
the cgroup refcnt, but then sock_update_netprioidx()
thought it's in v1 mode, so it stores netprioidx value
in sk->sk_cgrp_data, so the cgroup refcnt will never be freed.

Currently we do the mode switch when someone writes to the ifpriomap
cgroup control file. The easiest fix is to also do the switch when
a task is attached to a new cgroup.

Fixes: bd1060a1d671 ("sock, cgroup: add sock->sk_cgroup")
Reported-by: Yang Yingliang <yangyingliang@huawei.com>
Tested-by: Yang Yingliang <yangyingliang@huawei.com>
Signed-off-by: Zefan Li <lizefan@huawei.com>
Acked-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/netprio_cgroup.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/net/core/netprio_cgroup.c
+++ b/net/core/netprio_cgroup.c
@@ -241,6 +241,8 @@ static void net_prio_attach(struct cgrou
 	struct task_struct *p;
 	struct cgroup_subsys_state *css;
 
+	cgroup_sk_alloc_disable();
+
 	cgroup_taskset_for_each(p, css, tset) {
 		void *v = (void *)(unsigned long)css->cgroup->id;
 


