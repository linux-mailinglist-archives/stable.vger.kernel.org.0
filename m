Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA83F4C95D7
	for <lists+stable@lfdr.de>; Tue,  1 Mar 2022 21:16:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234766AbiCAURZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Mar 2022 15:17:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237829AbiCAURA (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Mar 2022 15:17:00 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08D98793BB;
        Tue,  1 Mar 2022 12:16:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9B612B81B0A;
        Tue,  1 Mar 2022 20:16:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09165C340F1;
        Tue,  1 Mar 2022 20:16:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646165763;
        bh=8ekR9n4CWvjAjDsuorDJhQ71aeZSSGm3yhRFxbWDCSw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AdAwyBRRQflWf/lRousQHIdKCYWO3uKzw7FMMGv4wClIntIbiBKmGiGHQnTaV1aHx
         kBw+ULDK4w8Qd94DyyqJS2rvNFbqJlgQ6oGZdgyQxvhLYcPotlb+hiWbTLFLPoE/bL
         XZuuWqstQbDxiuZIg1/HlwSGMb7xGJ4EDGuSthE6ieuQWihoSf2hxuri4UKly679Fj
         z16R4Cf8F8GHm96qq2AcjTk5Hql3u1znjbl40lshUiJlQ+x8QNPhZ3WCa1tkVyOegZ
         v5TcrwEL6jX9b6zShe5co4UU8T1mlowShQF8sNo5elScEBE0xhfaaeKee6/pQHnvQh
         J7eji7jS7gHDw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sven Schnelle <svens@linux.ibm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Sasha Levin <sashal@kernel.org>, mingo@redhat.com
Subject: [PATCH AUTOSEL 5.16 24/28] tracing: Ensure trace buffer is at least 4096 bytes large
Date:   Tue,  1 Mar 2022 15:13:29 -0500
Message-Id: <20220301201344.18191-24-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220301201344.18191-1-sashal@kernel.org>
References: <20220301201344.18191-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sven Schnelle <svens@linux.ibm.com>

[ Upstream commit 7acf3a127bb7c65ff39099afd78960e77b2ca5de ]

Booting the kernel with 'trace_buf_size=1' give a warning at
boot during the ftrace selftests:

[    0.892809] Running postponed tracer tests:
[    0.892893] Testing tracer function:
[    0.901899] Callback from call_rcu_tasks_trace() invoked.
[    0.983829] Callback from call_rcu_tasks_rude() invoked.
[    1.072003] .. bad ring buffer .. corrupted trace buffer ..
[    1.091944] Callback from call_rcu_tasks() invoked.
[    1.097695] PASSED
[    1.097701] Testing dynamic ftrace: .. filter failed count=0 ..FAILED!
[    1.353474] ------------[ cut here ]------------
[    1.353478] WARNING: CPU: 0 PID: 1 at kernel/trace/trace.c:1951 run_tracer_selftest+0x13c/0x1b0

Therefore enforce a minimum of 4096 bytes to make the selftest pass.

Link: https://lkml.kernel.org/r/20220214134456.1751749-1-svens@linux.ibm.com

Signed-off-by: Sven Schnelle <svens@linux.ibm.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/trace.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index bb15059020445..9b5abe11be5c0 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -1472,10 +1472,12 @@ static int __init set_buf_size(char *str)
 	if (!str)
 		return 0;
 	buf_size = memparse(str, &str);
-	/* nr_entries can not be zero */
-	if (buf_size == 0)
-		return 0;
-	trace_buf_size = buf_size;
+	/*
+	 * nr_entries can not be zero and the startup
+	 * tests require some buffer space. Therefore
+	 * ensure we have at least 4096 bytes of buffer.
+	 */
+	trace_buf_size = max(4096UL, buf_size);
 	return 1;
 }
 __setup("trace_buf_size=", set_buf_size);
-- 
2.34.1

