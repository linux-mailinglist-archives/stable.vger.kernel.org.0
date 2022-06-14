Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5AC3154ACEF
	for <lists+stable@lfdr.de>; Tue, 14 Jun 2022 11:09:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353790AbiFNJHy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jun 2022 05:07:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354344AbiFNJH2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Jun 2022 05:07:28 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7329541F93;
        Tue, 14 Jun 2022 02:06:52 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id gd1so7954807pjb.2;
        Tue, 14 Jun 2022 02:06:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=urc88U4jINF/LMrnPPXmV/iTF0lewPTLBo6jj1gLwoE=;
        b=qU8snO6p1TpZvRrgGAyRUd+2iHHC7PMghN1ZNjsWqP5h3jEII4PWknvk2nJZjuhICp
         1sR4lbq3/kyC4AJNGzc0K5Q5D3w/OYVJ1HELZQ6/CFi2u6B7eMQ43N4pS4fZN0zrq1gI
         +NvaO4ltMiiQngypVhJcuL23aJRuIxHpCKQ762+QzxGyXe3Ta3UFQdrcFDSkADyxn4Gu
         4RC3Rh+NVIGcKGBwoqyzlL6KVK0Uy7RtRHEtQFsY8xJp6lcwSPABsXiEnZASDeCH9ar2
         OJWHlKfyKu5TL0ZcAiqJWhTqfpQMwjW18/17DoTNKbIVV1Ye/nksOP5I3VIrrz3Tw0C0
         39NQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=urc88U4jINF/LMrnPPXmV/iTF0lewPTLBo6jj1gLwoE=;
        b=FfRkWY385DpPL0VaDhVFFNklLOdkN02auxHiSPRXKipxvo+EC1GUlqgxoU4O3LJ/FC
         80777TgcqFkq4uT7gqsb9G/HNIK1ZzNra9TymyB3ihvuyi2TZoV/6Jy5ABH31jXO9ABT
         3FsXZ7F5hYLdMditZ6wOn18IyJXLxiTZjagQorstARB0Byf68yqdDgHrkoDV/kjBMIlj
         g4bBzYOvUu7OUiEDGHZJXdcAjQ583iWP/u+YuR1fsQyZ1geM7XFl/ITSJLHNjHfRpdF4
         /KrYCtv3ZbBiyYsg6L5jg63yw3zfbqftArGF2E8QToTNXbhK0PDzIKFRf6cawdNRxcVb
         vejg==
X-Gm-Message-State: AJIora/MgKJDg2eroTicsoqJtRUjvFizMFJzH4diCqqx5RBd0HDQ+WN2
        HW2O+0PcuZamgU3GNR09gH8=
X-Google-Smtp-Source: AGRyM1vmXjjmsk9QBzZxDERFGj6j8VFL1i4u5KBc6KrSgaV8/ZOIAvXPBwSDsXd3turNJh7DY0QTVw==
X-Received: by 2002:a17:90a:3182:b0:1e3:530d:6994 with SMTP id j2-20020a17090a318200b001e3530d6994mr3483998pjb.69.1655197611813;
        Tue, 14 Jun 2022 02:06:51 -0700 (PDT)
Received: from localhost.localdomain ([47.242.114.172])
        by smtp.gmail.com with ESMTPSA id z5-20020a170902ccc500b0015e8d4eb2aesm6621153ple.248.2022.06.14.02.06.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jun 2022 02:06:51 -0700 (PDT)
From:   Chuang W <nashuiliang@gmail.com>
Cc:     Chuang W <nashuiliang@gmail.com>, stable@vger.kernel.org,
        "Naveen N. Rao" <naveen.n.rao@linux.ibm.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Jessica Yu <jeyu@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] kprobes: Rollback post_handler on failed arm_kprobe()
Date:   Tue, 14 Jun 2022 17:06:33 +0800
Message-Id: <20220614090633.43832-1-nashuiliang@gmail.com>
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

In a scenario where livepatch and aggrprobe coexist, if arm_kprobe()
returns an error, ap.post_handler, while has been modified to
p.post_handler, is not rolled back.

When ap.post_handler is not NULL (not rolled back), the caller (e.g.
register_kprobe/enable_kprobe) of arm_kprobe_ftrace() will always fail.

Fixes: 12310e343755 ("kprobes: Propagate error from arm_kprobe_ftrace()")
Signed-off-by: Chuang W <nashuiliang@gmail.com>
Cc: <stable@vger.kernel.org>
---
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

