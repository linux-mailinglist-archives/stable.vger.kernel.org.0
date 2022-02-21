Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 008774BE092
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 18:52:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344064AbiBUJDv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 04:03:51 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:57952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348062AbiBUJCR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 04:02:17 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B380222BEE;
        Mon, 21 Feb 2022 00:57:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1810EB80EBA;
        Mon, 21 Feb 2022 08:57:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36564C340E9;
        Mon, 21 Feb 2022 08:57:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645433847;
        bh=r+bNCJC5D6dgqgospRgsdedmZ0Hcm+1d/jSHPYZYSUE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Dy0KwiqiXpyFY3MwuFBj2Ebtfk+Nj7QRC85coKOYM8eGD80BrFtBEVQu3e4d6YYvN
         4IL4GcG45n3GSIqNs5o9rqy0Cut/J+TtfgQDL9Gi+tEr5UAxoLFfmMI6x4d++qaLuN
         SfJYlxCZFWaC+AEOXqilMgWGW6gaZi3UVQTmzAGY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, JaeSang Yoo <jsyoo5b@gmail.com>,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 56/58] tracing: Fix tp_printk option related with tp_printk_stop_on_boot
Date:   Mon, 21 Feb 2022 09:49:49 +0100
Message-Id: <20220221084913.683951906@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220221084911.895146879@linuxfoundation.org>
References: <20220221084911.895146879@linuxfoundation.org>
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
index 17e337a22c239..19a6b088f1e72 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -232,6 +232,10 @@ __setup("trace_clock=", set_trace_boot_clock);
 
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



