Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C5076E64D2
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 14:52:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232190AbjDRMwy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 08:52:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232204AbjDRMww (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 08:52:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A0F5167D2
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 05:52:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F04D663437
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 12:52:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11B21C4339B;
        Tue, 18 Apr 2023 12:52:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681822349;
        bh=6gHbb0RiuyF1F5LJ+nQF96wdhbZbI/T01SAqsWRrluM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LK1MfyPgdDsJcGKQT34z37vZSURnc0CYdL2J9yYowD7Wa1dhS3RkAU+9dO4g/OM73
         gfIcWky24llbXCLkhLEwsPHqapJ7XT0gMNpc7d955uOQMKEAZhrMdZVt+6OlWh6oum
         VgmzetwwFBPTZXiJTbkyo/EGGtfr2WXIuV7LkKtE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Josh Don <joshdon@google.com>,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 6.2 117/139] cgroup: fix display of forceidle time at root
Date:   Tue, 18 Apr 2023 14:23:02 +0200
Message-Id: <20230418120318.190976952@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120313.725598495@linuxfoundation.org>
References: <20230418120313.725598495@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Josh Don <joshdon@google.com>

commit fcdb1eda5302599045bb366e679cccb4216f3873 upstream.

We need to reset forceidle_sum to 0 when reading from root, since the
bstat we accumulate into is stack allocated.

To make this more robust, just replace the existing cputime reset with a
memset of the overall bstat.

Signed-off-by: Josh Don <joshdon@google.com>
Fixes: 1fcf54deb767 ("sched/core: add forced idle accounting for cgroups")
Cc: stable@vger.kernel.org # v6.0+
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/cgroup/rstat.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/kernel/cgroup/rstat.c
+++ b/kernel/cgroup/rstat.c
@@ -457,9 +457,7 @@ static void root_cgroup_cputime(struct c
 	struct task_cputime *cputime = &bstat->cputime;
 	int i;
 
-	cputime->stime = 0;
-	cputime->utime = 0;
-	cputime->sum_exec_runtime = 0;
+	memset(bstat, 0, sizeof(*bstat));
 	for_each_possible_cpu(i) {
 		struct kernel_cpustat kcpustat;
 		u64 *cpustat = kcpustat.cpustat;


