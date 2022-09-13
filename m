Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8D5E5B6F7D
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 16:14:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232917AbiIMONa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 10:13:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232532AbiIMOMu (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 10:12:50 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E717B3A486;
        Tue, 13 Sep 2022 07:10:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9F857B80EFA;
        Tue, 13 Sep 2022 14:10:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01214C433D6;
        Tue, 13 Sep 2022 14:10:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663078201;
        bh=wri9EruwCP/tN5qJpuU0uBPSqNMLQzwCWS4jNp8ylyY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lTv+Ab9a5+EuJaq1UvInDSdbNPCVN47On1jwVTKuTB7AKPyKQLmTdn1XfQkrf7uOU
         Ate0RhWM2XCaIZJdYSxW02zIAoNlrkTTkNQWvnCN3/H5bCPthtvvk4QU99DTlYIwdx
         DeJU3iOd2zFwB7HtMluYgQiooii86KnDF3bguUUw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yipeng Zou <zouyipeng@huawei.com>,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 5.19 043/192] tracing: hold caller_addr to hardirq_{enable,disable}_ip
Date:   Tue, 13 Sep 2022 16:02:29 +0200
Message-Id: <20220913140412.067647453@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220913140410.043243217@linuxfoundation.org>
References: <20220913140410.043243217@linuxfoundation.org>
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

From: Yipeng Zou <zouyipeng@huawei.com>

commit 54c3931957f6a6194d5972eccc36d052964b2abe upstream.

Currently, The arguments passing to lockdep_hardirqs_{on,off} was fixed
in CALLER_ADDR0.
The function trace_hardirqs_on_caller should have been intended to use
caller_addr to represent the address that caller wants to be traced.

For example, lockdep log in riscv showing the last {enabled,disabled} at
__trace_hardirqs_{on,off} all the time(if called by):
[   57.853175] hardirqs last  enabled at (2519): __trace_hardirqs_on+0xc/0x14
[   57.853848] hardirqs last disabled at (2520): __trace_hardirqs_off+0xc/0x14

After use trace_hardirqs_xx_caller, we can get more effective information:
[   53.781428] hardirqs last  enabled at (2595): restore_all+0xe/0x66
[   53.782185] hardirqs last disabled at (2596): ret_from_exception+0xa/0x10

Link: https://lkml.kernel.org/r/20220901104515.135162-2-zouyipeng@huawei.com

Cc: stable@vger.kernel.org
Fixes: c3bc8fd637a96 ("tracing: Centralize preemptirq tracepoints and unify their usage")
Signed-off-by: Yipeng Zou <zouyipeng@huawei.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace_preemptirq.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/kernel/trace/trace_preemptirq.c
+++ b/kernel/trace/trace_preemptirq.c
@@ -95,14 +95,14 @@ __visible void trace_hardirqs_on_caller(
 	}
 
 	lockdep_hardirqs_on_prepare();
-	lockdep_hardirqs_on(CALLER_ADDR0);
+	lockdep_hardirqs_on(caller_addr);
 }
 EXPORT_SYMBOL(trace_hardirqs_on_caller);
 NOKPROBE_SYMBOL(trace_hardirqs_on_caller);
 
 __visible void trace_hardirqs_off_caller(unsigned long caller_addr)
 {
-	lockdep_hardirqs_off(CALLER_ADDR0);
+	lockdep_hardirqs_off(caller_addr);
 
 	if (!this_cpu_read(tracing_irq_cpu)) {
 		this_cpu_write(tracing_irq_cpu, 1);


