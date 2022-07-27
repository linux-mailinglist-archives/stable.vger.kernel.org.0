Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5562B583130
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 19:47:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243220AbiG0Rrf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 13:47:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243219AbiG0RrG (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 13:47:06 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D99328CC8C;
        Wed, 27 Jul 2022 09:53:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3974BB821D8;
        Wed, 27 Jul 2022 16:53:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B7D9C433D6;
        Wed, 27 Jul 2022 16:53:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658940820;
        bh=BjWDKkSbTVk6HOTJj0Ix1G7Bfz2vtR9DF2xF7kRNZnQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QoJyM5nlCTUtLV2s0V+evgdnhgCDR9AEP3UXziXuMk4lwNDfr30DbII62SXZs6lxt
         t7VNSEDT9nJCIKPU2n6X5pD5WAeprYsZfoyifYjKqotuO69s10Bec/WgWT8buXTa3s
         9xQMCw/nDNkE30JonuHL6EmA2J3A43HbP0OZQ+Rk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Juri Lelli <juri.lelli@redhat.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>
Subject: [PATCH 5.18 135/158] sched/deadline: Fix BUG_ON condition for deboosted tasks
Date:   Wed, 27 Jul 2022 18:13:19 +0200
Message-Id: <20220727161026.787205695@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220727161021.428340041@linuxfoundation.org>
References: <20220727161021.428340041@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Juri Lelli <juri.lelli@redhat.com>

commit ddfc710395cccc61247348df9eb18ea50321cbed upstream.

Tasks the are being deboosted from SCHED_DEADLINE might enter
enqueue_task_dl() one last time and hit an erroneous BUG_ON condition:
since they are not boosted anymore, the if (is_dl_boosted()) branch is
not taken, but the else if (!dl_prio) is and inside this one we
BUG_ON(!is_dl_boosted), which is of course false (BUG_ON triggered)
otherwise we had entered the if branch above. Long story short, the
current condition doesn't make sense and always leads to triggering of a
BUG.

Fix this by only checking enqueue flags, properly: ENQUEUE_REPLENISH has
to be present, but additional flags are not a problem.

Fixes: 64be6f1f5f71 ("sched/deadline: Don't replenish from a !SCHED_DEADLINE entity")
Signed-off-by: Juri Lelli <juri.lelli@redhat.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: stable@vger.kernel.org
Link: https://lkml.kernel.org/r/20220714151908.533052-1-juri.lelli@redhat.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/sched/deadline.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -1669,7 +1669,10 @@ static void enqueue_task_dl(struct rq *r
 		 * the throttle.
 		 */
 		p->dl.dl_throttled = 0;
-		BUG_ON(!is_dl_boosted(&p->dl) || flags != ENQUEUE_REPLENISH);
+		if (!(flags & ENQUEUE_REPLENISH))
+			printk_deferred_once("sched: DL de-boosted task PID %d: REPLENISH flag missing\n",
+					     task_pid_nr(p));
+
 		return;
 	}
 


