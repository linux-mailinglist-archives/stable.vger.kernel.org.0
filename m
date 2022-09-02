Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA79A5AB3CD
	for <lists+stable@lfdr.de>; Fri,  2 Sep 2022 16:39:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236600AbiIBOjx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Sep 2022 10:39:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237168AbiIBOiw (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Sep 2022 10:38:52 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8D93BF53
        for <stable@vger.kernel.org>; Fri,  2 Sep 2022 06:59:29 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id v135-20020a63618d000000b00430ac821302so1250225pgb.4
        for <stable@vger.kernel.org>; Fri, 02 Sep 2022 06:59:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date;
        bh=RPXDfWA9lujW4kEczkgobkXTxjOaAFXj4VbLJ20aew8=;
        b=olN4CjCDEFV5NOihx8i3dCWSibdH/KaTQyVs2xZJvX8jKBvagU79f1BB/rHwSbiwPQ
         ORtoa9a8SwQzdoChP+nnPHCGrhwqYAWYoCe7J2pjjgu6klMpX0HC3HX0ib4u6I6faFZH
         8OeHboT1hQicRvIm7GHAElHw9msjds64LKD9YTwU4l9jFFMjTExoTZx+CvOAPPI9xaUz
         YM3eoHKmaP2sm3neTPHOb1BQkV+0A1hWYOEJuGtW7yquvI2ynsIfXVFfl+aTWtDvD8KT
         kz5OBzOLWNHIuEv7AjupTMyKe1JPytfb8SiLORy87bSJqiGAlhm9HQavuFeesgjhphhK
         xjcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date;
        bh=RPXDfWA9lujW4kEczkgobkXTxjOaAFXj4VbLJ20aew8=;
        b=Y6jb319TgV4wrg4GjsFlhJ1Juz7+NkP08WeYUMy7IUz5MoTubTUnGw6Hdh03yIt074
         35DqJ0ek6zIEEkoieEzLwFnUk8qZ9ORsqdBPaw3L9lIIFfoibjNGFk3Fx8Xqx86udMHQ
         HQTxdVuJRUSSHKPR90lF/4gUsQCcfixZ15i1oLQhla4Yj0DxXtRPGl7ePQRBuS+qmKlc
         VcNA7DYsz55e8oun22tTN0wm9HaTVrx9alSO2ohVSQyuGhLV2bdXR9y8281RW8hbtL1j
         vRqpHrpLKG/tlSSMd8US7TQ4umQazNzlIyVcDUg829YfmQh/2VP6gEeLvMKXsA2VTrBj
         Q0mg==
X-Gm-Message-State: ACgBeo2qGJjrXsOgpNHCRxqfGlvC7Qaw12za+cDrJRfzrSC2yd9YHwev
        DD/YLmI6fIw1ynQ8plJ2dNfQFCkmbnKmy+6n9w==
X-Google-Smtp-Source: AA6agR7GOuwYdW7G/rJgHcUOwe0bDiVXi5gvEBS5447akvD65w9vvuw9+0ka0PNgEuZI7Fx49wJViUzOzxrtisUUnQ==
X-Received: from varshat.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:a35])
 (user=teratipally job=sendgmr) by 2002:a17:902:ebc8:b0:172:549d:e392 with
 SMTP id p8-20020a170902ebc800b00172549de392mr35733329plg.141.1662127168060;
 Fri, 02 Sep 2022 06:59:28 -0700 (PDT)
Date:   Fri,  2 Sep 2022 13:59:12 +0000
In-Reply-To: <20220902135912.816188-1-teratipally@google.com>
Mime-Version: 1.0
References: <20220902135912.816188-1-teratipally@google.com>
X-Mailer: git-send-email 2.37.2.789.g6183377224-goog
Message-ID: <20220902135912.816188-2-teratipally@google.com>
Subject: [PATCH] ipc: replace costly bailout check in sysvipc_find_ipc()
From:   Varsha Teratipally <teratipally@google.com>
To:     Andrew Morton <akpm@linux-foundation.org>,
        Manfred Spraul <manfred@colorfullife.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Davidlohr Bueso <dbueso@suse.de>,
        Rafael Aquini <aquini@redhat.com>,
        Alexander Mikhalitsyn <alexander.mikhalitsyn@virtuozzo.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Waiman Long <llong@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rafael Aquini <aquini@redhat.com>

sysvipc_find_ipc() was left with a costly way to check if the offset
position fed to it is bigger than the total number of IPC IDs in use.  So
much so that the time it takes to iterate over /proc/sysvipc/* files grows
exponentially for a custom benchmark that creates "N" SYSV shm segments
and then times the read of /proc/sysvipc/shm (milliseconds):

    12 msecs to read   1024 segs from /proc/sysvipc/shm
    18 msecs to read   2048 segs from /proc/sysvipc/shm
    65 msecs to read   4096 segs from /proc/sysvipc/shm
   325 msecs to read   8192 segs from /proc/sysvipc/shm
  1303 msecs to read  16384 segs from /proc/sysvipc/shm
  5182 msecs to read  32768 segs from /proc/sysvipc/shm

The root problem lies with the loop that computes the total amount of ids
in use to check if the "pos" feeded to sysvipc_find_ipc() grew bigger than
"ids->in_use".  That is a quite inneficient way to get to the maximum
index in the id lookup table, specially when that value is already
provided by struct ipc_ids.max_idx.

This patch follows up on the optimization introduced via commit
15df03c879836 ("sysvipc: make get_maxid O(1) again") and gets rid of the
aforementioned costly loop replacing it by a simpler checkpoint based on
ipc_get_maxidx() returned value, which allows for a smooth linear increase
in time complexity for the same custom benchmark:

     2 msecs to read   1024 segs from /proc/sysvipc/shm
     2 msecs to read   2048 segs from /proc/sysvipc/shm
     4 msecs to read   4096 segs from /proc/sysvipc/shm
     9 msecs to read   8192 segs from /proc/sysvipc/shm
    19 msecs to read  16384 segs from /proc/sysvipc/shm
    39 msecs to read  32768 segs from /proc/sysvipc/shm

Link: https://lkml.kernel.org/r/20210809203554.1562989-1-aquini@redhat.com
Signed-off-by: Rafael Aquini <aquini@redhat.com>
Acked-by: Davidlohr Bueso <dbueso@suse.de>
Acked-by: Manfred Spraul <manfred@colorfullife.com>
Cc: Waiman Long <llong@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
---
 ipc/util.c | 16 ++++------------
 1 file changed, 4 insertions(+), 12 deletions(-)

diff --git a/ipc/util.c b/ipc/util.c
index 0027e47626b7..d48d8cfa1f3f 100644
--- a/ipc/util.c
+++ b/ipc/util.c
@@ -788,21 +788,13 @@ struct pid_namespace *ipc_seq_pid_ns(struct seq_file *s)
 static struct kern_ipc_perm *sysvipc_find_ipc(struct ipc_ids *ids, loff_t pos,
 					      loff_t *new_pos)
 {
-	struct kern_ipc_perm *ipc;
-	int total, id;
-
-	total = 0;
-	for (id = 0; id < pos && total < ids->in_use; id++) {
-		ipc = idr_find(&ids->ipcs_idr, id);
-		if (ipc != NULL)
-			total++;
-	}
+	struct kern_ipc_perm *ipc = NULL;
+	int max_idx = ipc_get_maxidx(ids);
 
-	ipc = NULL;
-	if (total >= ids->in_use)
+	if (max_idx == -1 || pos > max_idx)
 		goto out;
 
-	for (; pos < ipc_mni; pos++) {
+	for (; pos <= max_idx; pos++) {
 		ipc = idr_find(&ids->ipcs_idr, pos);
 		if (ipc != NULL) {
 			rcu_read_lock();
--

