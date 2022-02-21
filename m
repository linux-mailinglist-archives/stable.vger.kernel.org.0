Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4F124BE916
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 19:06:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345411AbiBUIxf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 03:53:35 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:44210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345424AbiBUIw4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 03:52:56 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35D7DE73;
        Mon, 21 Feb 2022 00:52:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C720161133;
        Mon, 21 Feb 2022 08:52:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A77A6C340E9;
        Mon, 21 Feb 2022 08:52:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645433553;
        bh=syQWK8Fa21Z9X3TB1XCLJKCrUUi3bRur2cc+H/3WTxw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fGFz1Ld1RfS11yIw7kqPJiWpOOFHfWmUiKqHASKiawyHh8akPWZLEaY8hqUJG+QHR
         1BCK8R8lLcFLeR7YHG9JLBSwoF4x0/As/V9ZXEOLZ3Oez1w7DRVjh0Ry3uzdx/RTO7
         ciEmgbNeWI8Eliq5N9l8fP0EotEyywFyZfGZMHxI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, JaeSang Yoo <jsyoo5b@gmail.com>,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 32/33] tracing: Fix tp_printk option related with tp_printk_stop_on_boot
Date:   Mon, 21 Feb 2022 09:49:25 +0100
Message-Id: <20220221084909.805410352@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220221084908.568970525@linuxfoundation.org>
References: <20220221084908.568970525@linuxfoundation.org>
User-Agent: quilt/0.66
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



