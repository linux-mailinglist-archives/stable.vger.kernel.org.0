Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21A654B721D
	for <lists+stable@lfdr.de>; Tue, 15 Feb 2022 17:41:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240648AbiBOPgd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Feb 2022 10:36:33 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:46158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240692AbiBOPf1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Feb 2022 10:35:27 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1770EC1155;
        Tue, 15 Feb 2022 07:31:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B82FAB81AEA;
        Tue, 15 Feb 2022 15:30:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4FB5C340F2;
        Tue, 15 Feb 2022 15:30:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644939058;
        bh=yeyqDJlMEt+4yzU6WmDQQiir8Jj+abTOVCAaaeSLr5Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sBtOEN28RenaGYYoqxiyPcQdnRGNscXxqKKd46MivWYHQqyGNoYS2ntWlo6LdUp26
         PTmLvjET0aLn+jRLdCcR2A7ynBvidTqkdmZaR5Su+CeTiAtQfi2xpafvBmBn9DSX8x
         0jr7JZ2xvLJh/Yc03v0ncN8mIdkGSEVKVWSq9pEH2hwr6R4n/dEvMFYJt2sUBzv20i
         r5oAjCKxEPPat2rg7SdDcduqXzMHxxC09cipeCvmoXu/tm4qsV9rzf7KaDF8j+YLMe
         WVwDnKGrwvV8uPezUmj42FzZ1WBVd8/OV77oTibWYO15Na+sjI7vrAwkPFAGREPKz+
         qDsmR5O7YDGhg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     JaeSang Yoo <js.yoo.5b@gmail.com>, JaeSang Yoo <jsyoo5b@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Sasha Levin <sashal@kernel.org>, mingo@redhat.com
Subject: [PATCH AUTOSEL 5.4 13/17] tracing: Fix tp_printk option related with tp_printk_stop_on_boot
Date:   Tue, 15 Feb 2022 10:30:33 -0500
Message-Id: <20220215153037.581579-13-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220215153037.581579-1-sashal@kernel.org>
References: <20220215153037.581579-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: JaeSang Yoo <js.yoo.5b@gmail.com>

[ Upstream commit 3203ce39ac0b2a57a84382ec184c7d4a0bede175 ]

The kernel parameter "tp_printk_stop_on_boot" starts with "tp_printk" which is
the same as another kernel parameter "tp_printk". If "tp_printk" setup is
called before the "tp_printk_stop_on_boot", it will override the latter
and keep it from being set.

This is similar to other kernel parameter issues, such as:
  Commit 745a600cf1a6 ("um: console: Ignore console= option")
or init/do_mounts.c:45 (setup function of "ro" kernel param)

Fix it by checking for a "_" right after the "tp_printk" and if that
exists do not process the parameter.

Link: https://lkml.kernel.org/r/20220208195421.969326-1-jsyoo5b@gmail.com

Signed-off-by: JaeSang Yoo <jsyoo5b@gmail.com>
[ Fixed up change log and added space after if condition ]
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/trace.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 5a4dfb55ba16b..615259d8fa9ad 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -236,6 +236,10 @@ __setup("trace_clock=", set_trace_boot_clock);
 
 static int __init set_tracepoint_printk(char *str)
 {
+	/* Ignore the "tp_printk_stop_on_boot" param */
+	if (*str == '_')
+		return 0;
+
 	if ((strcmp(str, "=0") != 0 && strcmp(str, "=off") != 0))
 		tracepoint_printk = 1;
 	return 1;
-- 
2.34.1

