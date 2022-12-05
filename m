Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B41336433B2
	for <lists+stable@lfdr.de>; Mon,  5 Dec 2022 20:38:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233932AbiLETis (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Dec 2022 14:38:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234533AbiLETi3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Dec 2022 14:38:29 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A81665B0
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 11:35:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AA68661335
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 19:35:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA398C433C1;
        Mon,  5 Dec 2022 19:35:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670268925;
        bh=xcCMToOjpI2y+if9KDd+nbgje9d4OZrS/sDs4ogx62s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GJJxnwlfmeQVvSKs9K5JH/ncKDA8osOEoa0YCDAS69lKPN1mUE/j5Tn3g4UuP4//8
         F0ACeXEccxdb7fezwcqXcshXt7EGOfV76nXTRRpncKcnn1B5+Bse0L6R2bJ25TL4sE
         0x93uHqMuwcnl6U0ku2wy3EIciQLyGuJhHT1l8RQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        syzbot+29c402e56c4760763cc0@syzkaller.appspotmail.com,
        Zhengchao Shao <shaozhengchao@huawei.com>,
        Xin Long <lucien.xin@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 062/120] sctp: fix memory leak in sctp_stream_outq_migrate()
Date:   Mon,  5 Dec 2022 20:10:02 +0100
Message-Id: <20221205190808.489927543@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221205190806.528972574@linuxfoundation.org>
References: <20221205190806.528972574@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhengchao Shao <shaozhengchao@huawei.com>

[ Upstream commit 9ed7bfc79542119ac0a9e1ce8a2a5285e43433e9 ]

When sctp_stream_outq_migrate() is called to release stream out resources,
the memory pointed to by prio_head in stream out is not released.

The memory leak information is as follows:
 unreferenced object 0xffff88801fe79f80 (size 64):
   comm "sctp_repo", pid 7957, jiffies 4294951704 (age 36.480s)
   hex dump (first 32 bytes):
     80 9f e7 1f 80 88 ff ff 80 9f e7 1f 80 88 ff ff  ................
     90 9f e7 1f 80 88 ff ff 90 9f e7 1f 80 88 ff ff  ................
   backtrace:
     [<ffffffff81b215c6>] kmalloc_trace+0x26/0x60
     [<ffffffff88ae517c>] sctp_sched_prio_set+0x4cc/0x770
     [<ffffffff88ad64f2>] sctp_stream_init_ext+0xd2/0x1b0
     [<ffffffff88aa2604>] sctp_sendmsg_to_asoc+0x1614/0x1a30
     [<ffffffff88ab7ff1>] sctp_sendmsg+0xda1/0x1ef0
     [<ffffffff87f765ed>] inet_sendmsg+0x9d/0xe0
     [<ffffffff8754b5b3>] sock_sendmsg+0xd3/0x120
     [<ffffffff8755446a>] __sys_sendto+0x23a/0x340
     [<ffffffff87554651>] __x64_sys_sendto+0xe1/0x1b0
     [<ffffffff89978b49>] do_syscall_64+0x39/0xb0
     [<ffffffff89a0008b>] entry_SYSCALL_64_after_hwframe+0x63/0xcd

Link: https://syzkaller.appspot.com/bug?exrid=29c402e56c4760763cc0
Fixes: 637784ade221 ("sctp: introduce priority based stream scheduler")
Reported-by: syzbot+29c402e56c4760763cc0@syzkaller.appspotmail.com
Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
Reviewed-by: Xin Long <lucien.xin@gmail.com>
Link: https://lore.kernel.org/r/20221126031720.378562-1-shaozhengchao@huawei.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/sctp/stream_sched.h |  2 ++
 net/sctp/stream.c               | 25 ++++++++++++++++++-------
 net/sctp/stream_sched.c         |  5 +++++
 net/sctp/stream_sched_prio.c    | 19 +++++++++++++++++++
 net/sctp/stream_sched_rr.c      |  5 +++++
 5 files changed, 49 insertions(+), 7 deletions(-)

diff --git a/include/net/sctp/stream_sched.h b/include/net/sctp/stream_sched.h
index 01a70b27e026..65058faea4db 100644
--- a/include/net/sctp/stream_sched.h
+++ b/include/net/sctp/stream_sched.h
@@ -26,6 +26,8 @@ struct sctp_sched_ops {
 	int (*init)(struct sctp_stream *stream);
 	/* Init a stream */
 	int (*init_sid)(struct sctp_stream *stream, __u16 sid, gfp_t gfp);
+	/* free a stream */
+	void (*free_sid)(struct sctp_stream *stream, __u16 sid);
 	/* Frees the entire thing */
 	void (*free)(struct sctp_stream *stream);
 
diff --git a/net/sctp/stream.c b/net/sctp/stream.c
index ef9fceadef8d..ee6514af830f 100644
--- a/net/sctp/stream.c
+++ b/net/sctp/stream.c
@@ -52,6 +52,19 @@ static void sctp_stream_shrink_out(struct sctp_stream *stream, __u16 outcnt)
 	}
 }
 
+static void sctp_stream_free_ext(struct sctp_stream *stream, __u16 sid)
+{
+	struct sctp_sched_ops *sched;
+
+	if (!SCTP_SO(stream, sid)->ext)
+		return;
+
+	sched = sctp_sched_ops_from_stream(stream);
+	sched->free_sid(stream, sid);
+	kfree(SCTP_SO(stream, sid)->ext);
+	SCTP_SO(stream, sid)->ext = NULL;
+}
+
 /* Migrates chunks from stream queues to new stream queues if needed,
  * but not across associations. Also, removes those chunks to streams
  * higher than the new max.
@@ -70,16 +83,14 @@ static void sctp_stream_outq_migrate(struct sctp_stream *stream,
 		 * sctp_stream_update will swap ->out pointers.
 		 */
 		for (i = 0; i < outcnt; i++) {
-			kfree(SCTP_SO(new, i)->ext);
+			sctp_stream_free_ext(new, i);
 			SCTP_SO(new, i)->ext = SCTP_SO(stream, i)->ext;
 			SCTP_SO(stream, i)->ext = NULL;
 		}
 	}
 
-	for (i = outcnt; i < stream->outcnt; i++) {
-		kfree(SCTP_SO(stream, i)->ext);
-		SCTP_SO(stream, i)->ext = NULL;
-	}
+	for (i = outcnt; i < stream->outcnt; i++)
+		sctp_stream_free_ext(stream, i);
 }
 
 static int sctp_stream_alloc_out(struct sctp_stream *stream, __u16 outcnt,
@@ -174,9 +185,9 @@ void sctp_stream_free(struct sctp_stream *stream)
 	struct sctp_sched_ops *sched = sctp_sched_ops_from_stream(stream);
 	int i;
 
-	sched->free(stream);
+	sched->unsched_all(stream);
 	for (i = 0; i < stream->outcnt; i++)
-		kfree(SCTP_SO(stream, i)->ext);
+		sctp_stream_free_ext(stream, i);
 	genradix_free(&stream->out);
 	genradix_free(&stream->in);
 }
diff --git a/net/sctp/stream_sched.c b/net/sctp/stream_sched.c
index a2e1d34f52c5..33c2630c2496 100644
--- a/net/sctp/stream_sched.c
+++ b/net/sctp/stream_sched.c
@@ -46,6 +46,10 @@ static int sctp_sched_fcfs_init_sid(struct sctp_stream *stream, __u16 sid,
 	return 0;
 }
 
+static void sctp_sched_fcfs_free_sid(struct sctp_stream *stream, __u16 sid)
+{
+}
+
 static void sctp_sched_fcfs_free(struct sctp_stream *stream)
 {
 }
@@ -96,6 +100,7 @@ static struct sctp_sched_ops sctp_sched_fcfs = {
 	.get = sctp_sched_fcfs_get,
 	.init = sctp_sched_fcfs_init,
 	.init_sid = sctp_sched_fcfs_init_sid,
+	.free_sid = sctp_sched_fcfs_free_sid,
 	.free = sctp_sched_fcfs_free,
 	.enqueue = sctp_sched_fcfs_enqueue,
 	.dequeue = sctp_sched_fcfs_dequeue,
diff --git a/net/sctp/stream_sched_prio.c b/net/sctp/stream_sched_prio.c
index 80b5a2c4cbc7..4fc9f2923ed1 100644
--- a/net/sctp/stream_sched_prio.c
+++ b/net/sctp/stream_sched_prio.c
@@ -204,6 +204,24 @@ static int sctp_sched_prio_init_sid(struct sctp_stream *stream, __u16 sid,
 	return sctp_sched_prio_set(stream, sid, 0, gfp);
 }
 
+static void sctp_sched_prio_free_sid(struct sctp_stream *stream, __u16 sid)
+{
+	struct sctp_stream_priorities *prio = SCTP_SO(stream, sid)->ext->prio_head;
+	int i;
+
+	if (!prio)
+		return;
+
+	SCTP_SO(stream, sid)->ext->prio_head = NULL;
+	for (i = 0; i < stream->outcnt; i++) {
+		if (SCTP_SO(stream, i)->ext &&
+		    SCTP_SO(stream, i)->ext->prio_head == prio)
+			return;
+	}
+
+	kfree(prio);
+}
+
 static void sctp_sched_prio_free(struct sctp_stream *stream)
 {
 	struct sctp_stream_priorities *prio, *n;
@@ -323,6 +341,7 @@ static struct sctp_sched_ops sctp_sched_prio = {
 	.get = sctp_sched_prio_get,
 	.init = sctp_sched_prio_init,
 	.init_sid = sctp_sched_prio_init_sid,
+	.free_sid = sctp_sched_prio_free_sid,
 	.free = sctp_sched_prio_free,
 	.enqueue = sctp_sched_prio_enqueue,
 	.dequeue = sctp_sched_prio_dequeue,
diff --git a/net/sctp/stream_sched_rr.c b/net/sctp/stream_sched_rr.c
index ff425aed62c7..cc444fe0d67c 100644
--- a/net/sctp/stream_sched_rr.c
+++ b/net/sctp/stream_sched_rr.c
@@ -90,6 +90,10 @@ static int sctp_sched_rr_init_sid(struct sctp_stream *stream, __u16 sid,
 	return 0;
 }
 
+static void sctp_sched_rr_free_sid(struct sctp_stream *stream, __u16 sid)
+{
+}
+
 static void sctp_sched_rr_free(struct sctp_stream *stream)
 {
 	sctp_sched_rr_unsched_all(stream);
@@ -177,6 +181,7 @@ static struct sctp_sched_ops sctp_sched_rr = {
 	.get = sctp_sched_rr_get,
 	.init = sctp_sched_rr_init,
 	.init_sid = sctp_sched_rr_init_sid,
+	.free_sid = sctp_sched_rr_free_sid,
 	.free = sctp_sched_rr_free,
 	.enqueue = sctp_sched_rr_enqueue,
 	.dequeue = sctp_sched_rr_dequeue,
-- 
2.35.1



