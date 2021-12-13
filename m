Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6E0447255E
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 10:43:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234697AbhLMJnb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 04:43:31 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:53434 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234435AbhLMJkL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 04:40:11 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9C098B80D1F;
        Mon, 13 Dec 2021 09:40:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC921C00446;
        Mon, 13 Dec 2021 09:40:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639388408;
        bh=JRLwND2UqkuX4pdUu0vyXYxhqu2IhbH0Yw0KkiAbsD0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=izCIKAVWl0UCxNwt8SJkx4FT1/wIPqRqj+0j9rrJQLTunJxSx+UL/ns0toQPfLBdL
         Cs6VnIPDZsMqjZKoejhLezApUEH2JAjk/XA9jAoUA+52FaDOQd78lNNStPpD6qham6
         lOgkdjmukud472rbHisnnFfr59De4bIlFgvzNCMI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Oleg Nesterov <oleg@redhat.com>,
        Davidlohr Bueso <dbueso@suse.de>, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 4.19 40/74] block: fix ioprio_get(IOPRIO_WHO_PGRP) vs setuid(2)
Date:   Mon, 13 Dec 2021 10:30:11 +0100
Message-Id: <20211213092932.163480192@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211213092930.763200615@linuxfoundation.org>
References: <20211213092930.763200615@linuxfoundation.org>
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
@@ -206,6 +206,7 @@ SYSCALL_DEFINE2(ioprio_get, int, which,
 				pgrp = task_pgrp(current);
 			else
 				pgrp = find_vpid(who);
+			read_lock(&tasklist_lock);
 			do_each_pid_thread(pgrp, PIDTYPE_PGID, p) {
 				tmpio = get_task_ioprio(p);
 				if (tmpio < 0)
@@ -215,6 +216,8 @@ SYSCALL_DEFINE2(ioprio_get, int, which,
 				else
 					ret = ioprio_best(ret, tmpio);
 			} while_each_pid_thread(pgrp, PIDTYPE_PGID, p);
+			read_unlock(&tasklist_lock);
+
 			break;
 		case IOPRIO_WHO_USER:
 			uid = make_kuid(current_user_ns(), who);


