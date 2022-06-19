Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7638A5508AD
	for <lists+stable@lfdr.de>; Sun, 19 Jun 2022 06:50:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230178AbiFSEut (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 19 Jun 2022 00:50:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229639AbiFSEus (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 19 Jun 2022 00:50:48 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 871C7E0EB;
        Sat, 18 Jun 2022 21:50:46 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id 73-20020a17090a0fcf00b001eaee69f600so7438626pjz.1;
        Sat, 18 Jun 2022 21:50:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=sX9KInSnfsNdA1A/VXjX4rbpXLJ3ZyJ1BBGX0VMOA7U=;
        b=kuqNVli+ZIlaqlnbd4ILqzWsND4ax1rK1DdWJF2tL5DW8bqUEIvy03sDu3+h19jZLv
         b0PxugaVqPzlie0pkVZWqKuwVXrLF8OYyFe1NHBkmGBViGBhwe2hCggf19c7nBEosSsY
         VNoLsFSB8UGmYHQrR4Rhhm2zzE7TMBt8eHrHZbnGI3AzYE19m1T+g2o77aDO3w2oNjMC
         Hbt07PstnDLDoKHBPI9mW3WWdELMvHqdCQCu4EYtIBXrw2nUA8J4q5Pu2twgE7XJx4xF
         FFz/Gcln4LCAJ683YdYgaJhFqqFrmGtN4sLATyAEZnfI6gcjHdNRxFHDJ/bntKGXVOnT
         tzZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=sX9KInSnfsNdA1A/VXjX4rbpXLJ3ZyJ1BBGX0VMOA7U=;
        b=gA4U0zGqgsuRqxIS9nOQa2DbwKQJ04EFnDwv7FgpHV5prcnUkQFfQ4rY8B7nGAFiLZ
         NXv5Ws+peuPpfbaGzjIKH8kcHiVb4v0L231T3SB2ozsAsXhcAKOEUEsLvqS4J1p44xMF
         Nulk8CCTQ3v+K02VmkMMVwlSfuYUBunBPl1HNQhDiGGRYYu6Ziv76Z7qnLvOh3Fhea7d
         K1AQbvxWCXfUWx9qcHSIwP5/v6R3eDOSQgGmFInaX7Yd2SW/7DMb2hHdjhmBF+v9K9el
         5W7K6udIgS6WwpJCc4nPmo/OmXdq+b0mlXcniETJXNQL89bF8J0CWTrM0nL6seIHOz9I
         bHLA==
X-Gm-Message-State: AJIora8eFhOFk/uLGKhhXqkFOJfk+2wMI1xeC/qEQ9daljbP3rsAkYmc
        rwVUadvoX5Yk25hKx0ZUgng=
X-Google-Smtp-Source: AGRyM1uPe4zkRUTRAu+NcCg/5lAIeQYm3PQntNL37t6ky6xkSyIjaBU7ggSBirYd9Jj0o/7NcAVglw==
X-Received: by 2002:a17:90b:4b02:b0:1e2:ff51:272a with SMTP id lx2-20020a17090b4b0200b001e2ff51272amr19473918pjb.56.1655614245936;
        Sat, 18 Jun 2022 21:50:45 -0700 (PDT)
Received: from localhost.localdomain ([47.242.114.172])
        by smtp.gmail.com with ESMTPSA id c200-20020a624ed1000000b005251b1fde90sm502757pfb.219.2022.06.18.21.50.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Jun 2022 21:50:45 -0700 (PDT)
From:   Chuang W <nashuiliang@gmail.com>
Cc:     Chuang W <nashuiliang@gmail.com>, stable@vger.kernel.org,
        "Naveen N. Rao" <naveen.n.rao@linux.ibm.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Jessica Yu <jeyu@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2] kprobes: Rollback the aggrprobe post_handler on failed arm_kprobe()
Date:   Sun, 19 Jun 2022 12:50:27 +0800
Message-Id: <20220619045028.50619-1-nashuiliang@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

In a scenario where livepatch and aggrprobe coexist on the same function
entry, and if this aggrprobe has a post_handler, arm_kprobe() always
fails as both livepatch and aggrprobe with post_handler will use
FTRACE_OPS_FL_IPMODIFY.
Since register_aggr_kprobe() doesn't roll back the post_handler on
failed arm_kprobe(), this aggrprobe will no longer be available even if
all kprobes on this aggrprobe don't have the post_handler.

Fix to roll back the aggrprobe post_handler for this case.
With this patch, if a kprobe that has the post_handler is removed from
this aggrprobe (since arm_kprobe() failed), it will be available again.

Fixes: 12310e343755 ("kprobes: Propagate error from arm_kprobe_ftrace()")
Signed-off-by: Chuang W <nashuiliang@gmail.com>
Cc: <stable@vger.kernel.org>
---
v1 -> v2:
- Add commit details

 kernel/kprobes.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/kernel/kprobes.c b/kernel/kprobes.c
index f214f8c088ed..0610b02a3a05 100644
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -1300,6 +1300,7 @@ static int register_aggr_kprobe(struct kprobe *orig_p, struct kprobe *p)
 {
 	int ret = 0;
 	struct kprobe *ap = orig_p;
+	kprobe_post_handler_t old_post_handler = NULL;
 
 	cpus_read_lock();
 
@@ -1351,6 +1352,9 @@ static int register_aggr_kprobe(struct kprobe *orig_p, struct kprobe *p)
 
 	/* Copy the insn slot of 'p' to 'ap'. */
 	copy_kprobe(ap, p);
+
+	/* save the old post_handler */
+	old_post_handler = ap->post_handler;
 	ret = add_new_kprobe(ap, p);
 
 out:
@@ -1365,6 +1369,7 @@ static int register_aggr_kprobe(struct kprobe *orig_p, struct kprobe *p)
 			ret = arm_kprobe(ap);
 			if (ret) {
 				ap->flags |= KPROBE_FLAG_DISABLED;
+				ap->post_handler = old_post_handler;
 				list_del_rcu(&p->list);
 				synchronize_rcu();
 			}
-- 
2.34.1

