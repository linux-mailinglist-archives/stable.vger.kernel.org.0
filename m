Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8384D4728A5
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 11:15:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236342AbhLMKOR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 05:14:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240742AbhLMKCj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 05:02:39 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11761C08EC32;
        Mon, 13 Dec 2021 01:49:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 89E8BCE0EA9;
        Mon, 13 Dec 2021 09:49:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3764DC341CD;
        Mon, 13 Dec 2021 09:49:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639388966;
        bh=JnK1LYUicSuaJ7/Z5ADoa7St4da7BZCIVl7r2dgMYC0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=q3AO3NhA5RP2ZPFunOV5gpGOsZ4BqnFt32IAbEA7sWefGEm3b4lCY9gnG2TDn2Pyg
         bTBA3cW9WWRc1mPeG1bPfdbrbniWxLgWXxw68IK6VJrRofwhF8iIW1oiaZnevRXpSZ
         f1A403FNP4COrDR632X3gKYqlBkDP6XC+mr6jHW4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Oleg Nesterov <oleg@redhat.com>,
        Davidlohr Bueso <dbueso@suse.de>, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.10 071/132] block: fix ioprio_get(IOPRIO_WHO_PGRP) vs setuid(2)
Date:   Mon, 13 Dec 2021 10:30:12 +0100
Message-Id: <20211213092941.550432586@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211213092939.074326017@linuxfoundation.org>
References: <20211213092939.074326017@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Davidlohr Bueso <dave@stgolabs.net>

commit e6a59aac8a8713f335a37d762db0dbe80e7f6d38 upstream.

do_each_pid_thread(PIDTYPE_PGID) can race with a concurrent
change_pid(PIDTYPE_PGID) that can move the task from one hlist
to another while iterating. Serialize ioprio_get to take
the tasklist_lock in this case, just like it's set counterpart.

Fixes: d69b78ba1de (ioprio: grab rcu_read_lock in sys_ioprio_{set,get}())
Acked-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Davidlohr Bueso <dbueso@suse.de>
Link: https://lore.kernel.org/r/20211210182058.43417-1-dave@stgolabs.net
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 block/ioprio.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/block/ioprio.c
+++ b/block/ioprio.c
@@ -214,6 +214,7 @@ SYSCALL_DEFINE2(ioprio_get, int, which,
 				pgrp = task_pgrp(current);
 			else
 				pgrp = find_vpid(who);
+			read_lock(&tasklist_lock);
 			do_each_pid_thread(pgrp, PIDTYPE_PGID, p) {
 				tmpio = get_task_ioprio(p);
 				if (tmpio < 0)
@@ -223,6 +224,8 @@ SYSCALL_DEFINE2(ioprio_get, int, which,
 				else
 					ret = ioprio_best(ret, tmpio);
 			} while_each_pid_thread(pgrp, PIDTYPE_PGID, p);
+			read_unlock(&tasklist_lock);
+
 			break;
 		case IOPRIO_WHO_USER:
 			uid = make_kuid(current_user_ns(), who);


