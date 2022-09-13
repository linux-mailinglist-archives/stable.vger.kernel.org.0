Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A87585B7118
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 16:43:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234213AbiIMOfu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 10:35:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233988AbiIMOef (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 10:34:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4817A6053A;
        Tue, 13 Sep 2022 07:20:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 684AE614C0;
        Tue, 13 Sep 2022 14:18:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58887C433C1;
        Tue, 13 Sep 2022 14:18:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663078689;
        bh=tZN3IDs+UnwYCgalvUoDqz0Q4xbcT88unav2bMnv0xQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=plj6U8thBFGzIqCFCz6NNiFZAfsl4L/skOk65koOtowPl7vblKax2KPrRTPHYBiJK
         cb8AkyGUFJwaGv0uAk3tJfmAFbot4HhRZNkY3SwNBvP0xWBaKBpCKW2TfOXJDkl06/
         vFq8gbRheeDFWf/1YdyMMhOEsQL14437oqQHIR4g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Major Chen <major.chen@samsung.com>,
        stable <stable@kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Juri Lelli <juri.lelli@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
        Valentin Schneider <vschneid@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Kuyo Chang <kuyo.chang@mediatek.com>
Subject: [PATCH 5.15 037/121] sched/debug: fix dentry leak in update_sched_domain_debugfs
Date:   Tue, 13 Sep 2022 16:03:48 +0200
Message-Id: <20220913140358.952197808@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220913140357.323297659@linuxfoundation.org>
References: <20220913140357.323297659@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit c2e406596571659451f4b95e37ddfd5a8ef1d0dc upstream.

Kuyo reports that the pattern of using debugfs_remove(debugfs_lookup())
leaks a dentry and with a hotplug stress test, the machine eventually
runs out of memory.

Fix this up by using the newly created debugfs_lookup_and_remove() call
instead which properly handles the dentry reference counting logic.

Cc: Major Chen <major.chen@samsung.com>
Cc: stable <stable@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Juri Lelli <juri.lelli@redhat.com>
Cc: Vincent Guittot <vincent.guittot@linaro.org>
Cc: Dietmar Eggemann <dietmar.eggemann@arm.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Ben Segall <bsegall@google.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Daniel Bristot de Oliveira <bristot@redhat.com>
Cc: Valentin Schneider <vschneid@redhat.com>
Cc: Matthias Brugger <matthias.bgg@gmail.com>
Reported-by: Kuyo Chang <kuyo.chang@mediatek.com>
Tested-by: Kuyo Chang <kuyo.chang@mediatek.com>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lore.kernel.org/r/20220902123107.109274-2-gregkh@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/sched/debug.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/sched/debug.c
+++ b/kernel/sched/debug.c
@@ -416,7 +416,7 @@ void update_sched_domain_debugfs(void)
 		char buf[32];
 
 		snprintf(buf, sizeof(buf), "cpu%d", cpu);
-		debugfs_remove(debugfs_lookup(buf, sd_dentry));
+		debugfs_lookup_and_remove(buf, sd_dentry);
 		d_cpu = debugfs_create_dir(buf, sd_dentry);
 
 		i = 0;


