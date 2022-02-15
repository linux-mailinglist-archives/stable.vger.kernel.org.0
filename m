Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8A964B721F
	for <lists+stable@lfdr.de>; Tue, 15 Feb 2022 17:41:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240633AbiBOPho (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Feb 2022 10:37:44 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:43346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240970AbiBOPf5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Feb 2022 10:35:57 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 932512BC1;
        Tue, 15 Feb 2022 07:31:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EA60DB81A9A;
        Tue, 15 Feb 2022 15:31:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6216C36AE7;
        Tue, 15 Feb 2022 15:31:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644939094;
        bh=syQWK8Fa21Z9X3TB1XCLJKCrUUi3bRur2cc+H/3WTxw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JBxtIl+zbCr8ALT8FFpcZnGcIX1NZlzcM1svqTBnPaQ06aOnVGQf2RVIAMm25Qqk3
         Z8S0vBF0En4DIbczao1Lyc1tukSDMgSt6w9K7XL8M3s8rfxZSEhx7SeVK0IIUyMsBY
         OtFtDcmJWslsyHIbJPhRxzPIFz45yI4exGW4aWwgpiiW87U6yVX/Ej10IeHaMyQ5Ig
         g8nxcEcs5hSjf5ehwdnb+3VksgWNSJ0/XzTtLMKfAP8g6RxOPTCm3XQTkGKCgzz2D+
         5aFOdsB6cr6FbOk/uWCO5AoyL5Cb726lVsCaUbmZAlX6rK88lgorD4cQlvlqn/G53c
         u5Sly4YbYxeCw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     JaeSang Yoo <js.yoo.5b@gmail.com>, JaeSang Yoo <jsyoo5b@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Sasha Levin <sashal@kernel.org>, mingo@redhat.com
Subject: [PATCH AUTOSEL 4.9 2/3] tracing: Fix tp_printk option related with tp_printk_stop_on_boot
Date:   Tue, 15 Feb 2022 10:31:29 -0500
Message-Id: <20220215153131.582008-2-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220215153131.582008-1-sashal@kernel.org>
References: <20220215153131.582008-1-sashal@kernel.org>
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
index 01c646a1d9e76..12bee7043be6f 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -228,6 +228,10 @@ __setup("trace_clock=", set_trace_boot_clock);
 
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

