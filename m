Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 917456E6233
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 14:31:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231665AbjDRMa6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 08:30:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231592AbjDRMap (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 08:30:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1333B467
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 05:30:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 30B02631BF
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 12:29:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47551C433D2;
        Tue, 18 Apr 2023 12:29:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681820995;
        bh=gmW944o7DcwZ/rUiZO8Hn7nDwrDi2oWWytE3DszOy/w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Wx3X1bHsYP4PCTS16dUESzgNKqFc824Hd+D+vQnVNmfp1B9rG2qyJxIz5nuKGZ9vd
         t4S9wVJBKa8yIy+uDQ2sdVLMNMCEMfTLH0WF0tt9uQ7gw19+wqtQ8gPJRC71Q7amEM
         UR1K3akqZyYEnXNi01jz0GmFnEVDdcyHZyGdHaow=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Masami Hiramatsu <mhiramat@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        John Keeping <john@metanate.com>,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 5.4 34/92] ftrace: Mark get_lock_parent_ip() __always_inline
Date:   Tue, 18 Apr 2023 14:21:09 +0200
Message-Id: <20230418120306.041237421@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120304.658273364@linuxfoundation.org>
References: <20230418120304.658273364@linuxfoundation.org>
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

From: John Keeping <john@metanate.com>

commit ea65b41807a26495ff2a73dd8b1bab2751940887 upstream.

If the compiler decides not to inline this function then preemption
tracing will always show an IP inside the preemption disabling path and
never the function actually calling preempt_{enable,disable}.

Link: https://lore.kernel.org/linux-trace-kernel/20230327173647.1690849-1-john@metanate.com

Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: stable@vger.kernel.org
Fixes: f904f58263e1d ("sched/debug: Fix preempt_disable_ip recording for preempt_disable()")
Signed-off-by: John Keeping <john@metanate.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/ftrace.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -712,7 +712,7 @@ static inline void __ftrace_enabled_rest
 #define CALLER_ADDR5 ((unsigned long)ftrace_return_address(5))
 #define CALLER_ADDR6 ((unsigned long)ftrace_return_address(6))
 
-static inline unsigned long get_lock_parent_ip(void)
+static __always_inline unsigned long get_lock_parent_ip(void)
 {
 	unsigned long addr = CALLER_ADDR0;
 


