Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC2666B4A82
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 16:23:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234155AbjCJPXz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 10:23:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232918AbjCJPXi (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 10:23:38 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BE91BE5F3
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 07:13:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 41145B822E7
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 15:12:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94E3EC433EF;
        Fri, 10 Mar 2023 15:12:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678461161;
        bh=HN74uE7hW2rSdAF1M2BkttIjbrlW7eN68Vf0lvdDCXA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bIKSTGpFGiyjtjCjoSYIPck6a+NPCwWjGFgDi4QXrgXz6ZU05oI5dHc6XpMctP0lq
         W3FenggZSEQt3kz7LNYdn1/X+Wgon/NMSVLjGFZMO372JO4xp9p4e3DZIrUq7Ad2ce
         G78MS1odtakQUichy3YLKTwB5OqyxZBTuG8i4ikM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Ying Xu <yinxu@redhat.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Xin Long <lucien.xin@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 045/136] sctp: add a refcnt in sctp_stream_priorities to avoid a nested loop
Date:   Fri, 10 Mar 2023 14:42:47 +0100
Message-Id: <20230310133708.438058444@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133706.811226272@linuxfoundation.org>
References: <20230310133706.811226272@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xin Long <lucien.xin@gmail.com>

[ Upstream commit 68ba44639537de6f91fe32783766322d41848127 ]

With this refcnt added in sctp_stream_priorities, we don't need to
traverse all streams to check if the prio is used by other streams
when freeing one stream's prio in sctp_sched_prio_free_sid(). This
can avoid a nested loop (up to 65535 * 65535), which may cause a
stuck as Ying reported:

    watchdog: BUG: soft lockup - CPU#23 stuck for 26s! [ksoftirqd/23:136]
    Call Trace:
     <TASK>
     sctp_sched_prio_free_sid+0xab/0x100 [sctp]
     sctp_stream_free_ext+0x64/0xa0 [sctp]
     sctp_stream_free+0x31/0x50 [sctp]
     sctp_association_free+0xa5/0x200 [sctp]

Note that it doesn't need to use refcount_t type for this counter,
as its accessing is always protected under the sock lock.

v1->v2:
 - add a check in sctp_sched_prio_set to avoid the possible prio_head
   refcnt overflow.

Fixes: 9ed7bfc79542 ("sctp: fix memory leak in sctp_stream_outq_migrate()")
Reported-by: Ying Xu <yinxu@redhat.com>
Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
Link: https://lore.kernel.org/r/825eb0c905cb864991eba335f4a2b780e543f06b.1677085641.git.lucien.xin@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/sctp/structs.h   |  1 +
 net/sctp/stream_sched_prio.c | 52 +++++++++++++++---------------------
 2 files changed, 22 insertions(+), 31 deletions(-)

diff --git a/include/net/sctp/structs.h b/include/net/sctp/structs.h
index 8d2c3dd9f5953..790252c1478b0 100644
--- a/include/net/sctp/structs.h
+++ b/include/net/sctp/structs.h
@@ -1420,6 +1420,7 @@ struct sctp_stream_priorities {
 	/* The next stream in line */
 	struct sctp_stream_out_ext *next;
 	__u16 prio;
+	__u16 users;
 };
 
 struct sctp_stream_out_ext {
diff --git a/net/sctp/stream_sched_prio.c b/net/sctp/stream_sched_prio.c
index 4fc9f2923ed11..7dd9f8b387cca 100644
--- a/net/sctp/stream_sched_prio.c
+++ b/net/sctp/stream_sched_prio.c
@@ -25,6 +25,18 @@
 
 static void sctp_sched_prio_unsched_all(struct sctp_stream *stream);
 
+static struct sctp_stream_priorities *sctp_sched_prio_head_get(struct sctp_stream_priorities *p)
+{
+	p->users++;
+	return p;
+}
+
+static void sctp_sched_prio_head_put(struct sctp_stream_priorities *p)
+{
+	if (p && --p->users == 0)
+		kfree(p);
+}
+
 static struct sctp_stream_priorities *sctp_sched_prio_new_head(
 			struct sctp_stream *stream, int prio, gfp_t gfp)
 {
@@ -38,6 +50,7 @@ static struct sctp_stream_priorities *sctp_sched_prio_new_head(
 	INIT_LIST_HEAD(&p->active);
 	p->next = NULL;
 	p->prio = prio;
+	p->users = 1;
 
 	return p;
 }
@@ -53,7 +66,7 @@ static struct sctp_stream_priorities *sctp_sched_prio_get_head(
 	 */
 	list_for_each_entry(p, &stream->prio_list, prio_sched) {
 		if (p->prio == prio)
-			return p;
+			return sctp_sched_prio_head_get(p);
 		if (p->prio > prio)
 			break;
 	}
@@ -70,7 +83,7 @@ static struct sctp_stream_priorities *sctp_sched_prio_get_head(
 			 */
 			break;
 		if (p->prio == prio)
-			return p;
+			return sctp_sched_prio_head_get(p);
 	}
 
 	/* If not even there, allocate a new one. */
@@ -154,32 +167,21 @@ static int sctp_sched_prio_set(struct sctp_stream *stream, __u16 sid,
 	struct sctp_stream_out_ext *soute = sout->ext;
 	struct sctp_stream_priorities *prio_head, *old;
 	bool reschedule = false;
-	int i;
+
+	old = soute->prio_head;
+	if (old && old->prio == prio)
+		return 0;
 
 	prio_head = sctp_sched_prio_get_head(stream, prio, gfp);
 	if (!prio_head)
 		return -ENOMEM;
 
 	reschedule = sctp_sched_prio_unsched(soute);
-	old = soute->prio_head;
 	soute->prio_head = prio_head;
 	if (reschedule)
 		sctp_sched_prio_sched(stream, soute);
 
-	if (!old)
-		/* Happens when we set the priority for the first time */
-		return 0;
-
-	for (i = 0; i < stream->outcnt; i++) {
-		soute = SCTP_SO(stream, i)->ext;
-		if (soute && soute->prio_head == old)
-			/* It's still in use, nothing else to do here. */
-			return 0;
-	}
-
-	/* No hits, we are good to free it. */
-	kfree(old);
-
+	sctp_sched_prio_head_put(old);
 	return 0;
 }
 
@@ -206,20 +208,8 @@ static int sctp_sched_prio_init_sid(struct sctp_stream *stream, __u16 sid,
 
 static void sctp_sched_prio_free_sid(struct sctp_stream *stream, __u16 sid)
 {
-	struct sctp_stream_priorities *prio = SCTP_SO(stream, sid)->ext->prio_head;
-	int i;
-
-	if (!prio)
-		return;
-
+	sctp_sched_prio_head_put(SCTP_SO(stream, sid)->ext->prio_head);
 	SCTP_SO(stream, sid)->ext->prio_head = NULL;
-	for (i = 0; i < stream->outcnt; i++) {
-		if (SCTP_SO(stream, i)->ext &&
-		    SCTP_SO(stream, i)->ext->prio_head == prio)
-			return;
-	}
-
-	kfree(prio);
 }
 
 static void sctp_sched_prio_free(struct sctp_stream *stream)
-- 
2.39.2



