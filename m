Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A100459433B
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 00:55:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348993AbiHOWaP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 18:30:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351026AbiHOW11 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 18:27:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59AE674B9E;
        Mon, 15 Aug 2022 12:46:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DCD806122B;
        Mon, 15 Aug 2022 19:46:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9C5AC433D6;
        Mon, 15 Aug 2022 19:46:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660592774;
        bh=ZxhMVr49eMNwslMvCFUqsr9mcAHtbfXm7urEzpKHVlo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UC5DcKpttu1xooE6uA3d6ByPVEhl2Nje9wdikkWdEFo5ZGoF1Pbblr2/pJ2fPxphO
         QsZKtLLFYM1GMw4z4+KP7Tl4aUNPQVOCFq5vqMzhOnE5jwd9/+nrTKWIcH/cGoMQ9J
         cBo+jR44FemC2Csq51clfbf4YxikE1CVNOBHlUcg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Joe Lawrence <joe.lawrence@redhat.com>,
        Petr Mladek <pmladek@suse.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0843/1095] selftests/livepatch: better synchronize test_klp_callbacks_busy
Date:   Mon, 15 Aug 2022 20:04:02 +0200
Message-Id: <20220815180504.214052020@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
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

From: Joe Lawrence <joe.lawrence@redhat.com>

[ Upstream commit 55eb9a6c8bf3e2099863118ef53e02d9f44f85a8 ]

The test_klp_callbacks_busy module conditionally blocks a future
livepatch transition by busy waiting inside its workqueue function,
busymod_work_func().  After scheduling this work, a test livepatch is
loaded, introducing the transition under test.

Both events are marked in the kernel log for later verification, but
there is no synchronization to ensure that busymod_work_func() logs its
function entry message before subsequent selftest commands log their own
messages.  This can lead to a rare test failure due to unexpected
ordering like:

#  --- expected
#  +++ result
#  @@ -1,7 +1,7 @@
#   % modprobe test_klp_callbacks_busy block_transition=Y
#   test_klp_callbacks_busy: test_klp_callbacks_busy_init
#  -test_klp_callbacks_busy: busymod_work_func enter
#   % modprobe test_klp_callbacks_demo
#  +test_klp_callbacks_busy: busymod_work_func enter
#   livepatch: enabling patch 'test_klp_callbacks_demo'
#   livepatch: 'test_klp_callbacks_demo': initializing patching transition
#   test_klp_callbacks_demo: pre_patch_callback: vmlinux

Force the module init function to wait until busymod_work_func() has
started (and logged its message), before exiting to the next selftest
steps.

Fixes: 547840bd5ae5 ("selftests/livepatch: simplify test-klp-callbacks busy target tests")
Signed-off-by: Joe Lawrence <joe.lawrence@redhat.com>
Reviewed-by: Petr Mladek <pmladek@suse.com>
Signed-off-by: Petr Mladek <pmladek@suse.com>
Link: https://lore.kernel.org/r/20220602203233.979681-1-joe.lawrence@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/livepatch/test_klp_callbacks_busy.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/lib/livepatch/test_klp_callbacks_busy.c
+++ b/lib/livepatch/test_klp_callbacks_busy.c
@@ -16,10 +16,12 @@ MODULE_PARM_DESC(block_transition, "bloc
 
 static void busymod_work_func(struct work_struct *work);
 static DECLARE_WORK(work, busymod_work_func);
+static DECLARE_COMPLETION(busymod_work_started);
 
 static void busymod_work_func(struct work_struct *work)
 {
 	pr_info("%s enter\n", __func__);
+	complete(&busymod_work_started);
 
 	while (READ_ONCE(block_transition)) {
 		/*
@@ -37,6 +39,12 @@ static int test_klp_callbacks_busy_init(
 	pr_info("%s\n", __func__);
 	schedule_work(&work);
 
+	/*
+	 * To synchronize kernel messages, hold the init function from
+	 * exiting until the work function's entry message has printed.
+	 */
+	wait_for_completion(&busymod_work_started);
+
 	if (!block_transition) {
 		/*
 		 * Serialize output: print all messages from the work


