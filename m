Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC3624D8348
	for <lists+stable@lfdr.de>; Mon, 14 Mar 2022 13:14:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240707AbiCNMMi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Mar 2022 08:12:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240793AbiCNMHy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Mar 2022 08:07:54 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D47B26136;
        Mon, 14 Mar 2022 05:03:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E3E8EB80DF4;
        Mon, 14 Mar 2022 12:03:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED1C6C340EC;
        Mon, 14 Mar 2022 12:03:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647259432;
        bh=jq/4X7WKx712Z4Nd1+z1ahSG13+/Eajwrc24FqKSEoQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kFtfXU8LOAGNzoUfoPT3aUMyGfEcFUlRP5TBtDFB4NRq5/PrZZIZzi0tBcAxdWeXd
         OPziOI8MXaQ652QTudKdpXsUcYfSAormMdBqn3frXUt6N2YeU5u7dgJrxqvLaYoOuk
         HavQNQ0kzHy0zW1gqW3BpsIVCBbA2dO3t0nhqrSI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sven Schnelle <svens@linux.ibm.com>,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 46/71] tracing: Ensure trace buffer is at least 4096 bytes large
Date:   Mon, 14 Mar 2022 12:53:39 +0100
Message-Id: <20220314112739.219829427@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220314112737.929694832@linuxfoundation.org>
References: <20220314112737.929694832@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
index 71ed0616d83b..953dd9568dd7 100644
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



