Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC0916E6440
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 14:47:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232032AbjDRMrj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 08:47:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232037AbjDRMrh (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 08:47:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CBB4BBB0
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 05:47:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 85780633C8
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 12:47:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A032C433D2;
        Tue, 18 Apr 2023 12:47:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681822046;
        bh=V7e/AyIHuQEgs1bKHSAVIrxY3J4tgCgRrxFN+SQ7H80=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vZ2NlN9Uk6VGRF2JF6aGqxQ+zX7FaUIWclF7wZ4iMMaAaVq+iG05lonLvhXA1LS+Z
         ruV7FpMRbxepbnrpf7kFcyHwH9cHhv7ghxmjzqxZISxIbyognwe5E1Q0byPEBJm1cj
         mpe9J++/llNaHozaEt2P0qhddSUR/joXgM1k07DY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Josh Don <joshdon@google.com>,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 6.1 111/134] cgroup: fix display of forceidle time at root
Date:   Tue, 18 Apr 2023 14:22:47 +0200
Message-Id: <20230418120317.059603841@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120313.001025904@linuxfoundation.org>
References: <20230418120313.001025904@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
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
 kernel/cgroup/rstat.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/kernel/cgroup/rstat.c b/kernel/cgroup/rstat.c
index 831f1f472bb8..0a2b4967e333 100644
--- a/kernel/cgroup/rstat.c
+++ b/kernel/cgroup/rstat.c
@@ -457,9 +457,7 @@ static void root_cgroup_cputime(struct cgroup_base_stat *bstat)
 	struct task_cputime *cputime = &bstat->cputime;
 	int i;
 
-	cputime->stime = 0;
-	cputime->utime = 0;
-	cputime->sum_exec_runtime = 0;
+	memset(bstat, 0, sizeof(*bstat));
 	for_each_possible_cpu(i) {
 		struct kernel_cpustat kcpustat;
 		u64 *cpustat = kcpustat.cpustat;
-- 
2.40.0



