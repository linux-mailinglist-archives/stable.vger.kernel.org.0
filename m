Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B42E54C967B
	for <lists+stable@lfdr.de>; Tue,  1 Mar 2022 21:24:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238155AbiCAUY6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Mar 2022 15:24:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238370AbiCAUXI (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Mar 2022 15:23:08 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9B5082D13;
        Tue,  1 Mar 2022 12:20:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3556E61660;
        Tue,  1 Mar 2022 20:19:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE8EFC340EE;
        Tue,  1 Mar 2022 20:19:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646165970;
        bh=g9y86bpfKIkH3K7uLLbvwjkJzO98EWg8qgZElHROMk0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Sy80IzOMAZwjZ0gFDoMuIAh5I0vOKJYgAgCOzCvn5SFixgIgMyfgeU3BOVRPgblxS
         MIbO2puNBGFEarBlYu/+91ezg/KQvdKNjFVTWUtNYeszjRTNQJoG7UMY3jeoz8xO7e
         j0ZXFbBA3SoFode++EJOn+Iu5kfXRmtBXNAv/+CajHhvLxG1o0/+0OTpAAAGOfXBNc
         T92P+IeEwBibV18e8bMw6TngSspx8mIXqG52KNdt4xMtJk47C63m2dJ1ov3Quua/0G
         dNcjEp5hVfz79CSfSlFCG2yk7EfgQGfHJVE6d+YRtXOibg2xhzKYobh9sURA36fEmT
         X+YMngPdv/RZQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sven Schnelle <svens@linux.ibm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Sasha Levin <sashal@kernel.org>, mingo@redhat.com
Subject: [PATCH AUTOSEL 5.10 12/14] tracing: Ensure trace buffer is at least 4096 bytes large
Date:   Tue,  1 Mar 2022 15:18:24 -0500
Message-Id: <20220301201833.18841-12-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220301201833.18841-1-sashal@kernel.org>
References: <20220301201833.18841-1-sashal@kernel.org>
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
index f9fad789321b0..abb89f94166c6 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -1490,10 +1490,12 @@ static int __init set_buf_size(char *str)
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

