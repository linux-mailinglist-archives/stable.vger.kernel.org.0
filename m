Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AA4A51576E1
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 13:56:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730058AbgBJMln (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 07:41:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:44516 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730055AbgBJMlm (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:41:42 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2200720842;
        Mon, 10 Feb 2020 12:41:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338502;
        bh=6oU8j0iQki5Oa3K1ghB2JvtnRZAbLvWYZLWNgB8d+HI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wyZJOMZS5goGsHuMaH4bDbPun5V44ggHsaLGbIuliT1sSNPNlBSUsuL0toy1JiXKV
         bnL00n2UWDq0pGUYQIsg8/TjA5q43/1+J8UEh6oz9xndHkugxEaQlx2qj6BVqLoZsY
         seIvQ9bkeEP3wBNmz++FARVbmJiHHfG1zBB6ynww=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        "J. Bruce Fields" <bfields@redhat.com>
Subject: [PATCH 5.5 299/367] nfsd: fix jiffies/time_t mixup in LRU list
Date:   Mon, 10 Feb 2020 04:33:32 -0800
Message-Id: <20200210122451.209655162@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210122423.695146547@linuxfoundation.org>
References: <20200210122423.695146547@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

commit 9594497f2c78993cb66b696122f7c65528ace985 upstream.

The nfsd4_blocked_lock->nbl_time timestamp is recorded in jiffies,
but then compared to a CLOCK_REALTIME timestamp later on, which makes
no sense.

For consistency with the other timestamps, change this to use a time_t.

This is a change in behavior, which may cause regressions, but the
current code is not sensible. On a system with CONFIG_HZ=1000,
the 'time_after((unsigned long)nbl->nbl_time, (unsigned long)cutoff))'
check is false for roughly the first 18 days of uptime and then true
for the next 49 days.

Fixes: 7919d0a27f1e ("nfsd: add a LRU list for blocked locks")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/nfsd/nfs4state.c |    2 +-
 fs/nfsd/state.h     |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -6550,7 +6550,7 @@ nfsd4_lock(struct svc_rqst *rqstp, struc
 	}
 
 	if (fl_flags & FL_SLEEP) {
-		nbl->nbl_time = jiffies;
+		nbl->nbl_time = get_seconds();
 		spin_lock(&nn->blocked_locks_lock);
 		list_add_tail(&nbl->nbl_list, &lock_sop->lo_blocked);
 		list_add_tail(&nbl->nbl_lru, &nn->blocked_locks_lru);
--- a/fs/nfsd/state.h
+++ b/fs/nfsd/state.h
@@ -606,7 +606,7 @@ static inline bool nfsd4_stateid_generat
 struct nfsd4_blocked_lock {
 	struct list_head	nbl_list;
 	struct list_head	nbl_lru;
-	unsigned long		nbl_time;
+	time_t			nbl_time;
 	struct file_lock	nbl_lock;
 	struct knfsd_fh		nbl_fh;
 	struct nfsd4_callback	nbl_cb;


