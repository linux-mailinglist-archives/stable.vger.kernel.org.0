Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F96E4B718B
	for <lists+stable@lfdr.de>; Tue, 15 Feb 2022 17:40:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240638AbiBOPhq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Feb 2022 10:37:46 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:44994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240869AbiBOPft (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Feb 2022 10:35:49 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A3B12CCB1;
        Tue, 15 Feb 2022 07:31:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C6242B81AEF;
        Tue, 15 Feb 2022 15:31:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4191C340ED;
        Tue, 15 Feb 2022 15:31:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644939087;
        bh=2qWO6Avbojgrt1fWpiEr152G6J0nn5/72cma8ge/ihc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=q5v/z6tiVbgoSKKsvNSiMaJnuYUbf6vwKraIQ4gh85DK47oVTzp2vJbpNFsRrHvDu
         ukpQyhP+mV8EJXWjV78Sn1Q9Y+oP3Xc3fVaamQ9ukjDJgVF9puYMuPV8Q9cp56CUeB
         9QqQlPzA1aToEKfDqP1VbmeXQswztJK3JW2RHFRRFIQEVRpWQnlhTelDljhY23dMNC
         3hG4hgKvlzTyc9B8u2tG0QKgOROLahLQeHlNEF1e085CxOH4Q1p4vVbO2n4EwSQOvk
         S/79ARBsC2DoEZQATFWR2aJcL2iabNqOP6TiAigpzPK04cljjNQYPmWxEEYKVAp3VS
         9pd3Aa/5l0lPA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     JaeSang Yoo <js.yoo.5b@gmail.com>, JaeSang Yoo <jsyoo5b@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Sasha Levin <sashal@kernel.org>, mingo@redhat.com
Subject: [PATCH AUTOSEL 4.14 3/5] tracing: Fix tp_printk option related with tp_printk_stop_on_boot
Date:   Tue, 15 Feb 2022 10:31:20 -0500
Message-Id: <20220215153122.581930-3-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220215153122.581930-1-sashal@kernel.org>
References: <20220215153122.581930-1-sashal@kernel.org>
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
index fd8e1ec39c270..c1da2a4a629a1 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -230,6 +230,10 @@ __setup("trace_clock=", set_trace_boot_clock);
 
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

