Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E10C16BB130
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 13:25:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232342AbjCOMZ0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 08:25:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232351AbjCOMZJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 08:25:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A393960BE
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 05:24:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BEF2A61D13
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 12:23:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5AB8C433D2;
        Wed, 15 Mar 2023 12:23:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678883006;
        bh=DoLAf9SXuAvTh9NuPLe3W5g6Kot22tjwUY9zOn6e6eM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gvkcgv4ie93DmQpSF8jT+wLZRrhzB0IqbFIFpQ4y0ib56CHvkUBozyivZSTbndLWk
         rxFNrnMQdsLwl/50tC/ABdpnJkOB3TGA9EV+0o4IHUD42Inek0gIKQjAOFQfFzEDhO
         JeLiARzQ67rXZDvWBbMy8ChOAeepkPyntmIIZvHk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Qais Yousef <qais.yousef@arm.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        "Qais Yousef (Google)" <qyousef@layalina.io>
Subject: [PATCH 5.10 085/104] sched/uclamp: Make cpu_overutilized() use util_fits_cpu()
Date:   Wed, 15 Mar 2023 13:12:56 +0100
Message-Id: <20230315115735.483886583@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115731.942692602@linuxfoundation.org>
References: <20230315115731.942692602@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qais Yousef <qais.yousef@arm.com>

commit c56ab1b3506ba0e7a872509964b100912bde165d upstream.

So that it is now uclamp aware.

This fixes a major problem of busy tasks capped with UCLAMP_MAX keeping
the system in overutilized state which disables EAS and leads to wasting
energy in the long run.

Without this patch running a busy background activity like JIT
compilation on Pixel 6 causes the system to be in overutilized state
74.5% of the time.

With this patch this goes down to  9.79%.

It also fixes another problem when long running tasks that have their
UCLAMP_MIN changed while running such that they need to upmigrate to
honour the new UCLAMP_MIN value. The upmigration doesn't get triggered
because overutilized state never gets set in this state, hence misfit
migration never happens at tick in this case until the task wakes up
again.

Fixes: af24bde8df202 ("sched/uclamp: Add uclamp support to energy_compute()")
Signed-off-by: Qais Yousef <qais.yousef@arm.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lore.kernel.org/r/20220804143609.515789-7-qais.yousef@arm.com
(cherry picked from commit c56ab1b3506ba0e7a872509964b100912bde165d)
[Conflict in kernel/sched/fair.c: use cpu_util() instead of
cpu_util_cfs()]
Signed-off-by: Qais Yousef (Google) <qyousef@layalina.io>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/sched/fair.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -5610,7 +5610,10 @@ static inline unsigned long cpu_util(int
 
 static inline bool cpu_overutilized(int cpu)
 {
-	return !fits_capacity(cpu_util(cpu), capacity_of(cpu));
+	unsigned long rq_util_min = uclamp_rq_get(cpu_rq(cpu), UCLAMP_MIN);
+	unsigned long rq_util_max = uclamp_rq_get(cpu_rq(cpu), UCLAMP_MAX);
+
+	return !util_fits_cpu(cpu_util(cpu), rq_util_min, rq_util_max, cpu);
 }
 
 static inline void update_overutilized_status(struct rq *rq)


