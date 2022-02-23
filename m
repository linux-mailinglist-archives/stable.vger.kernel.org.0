Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E5814C0849
	for <lists+stable@lfdr.de>; Wed, 23 Feb 2022 03:31:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236942AbiBWCaS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Feb 2022 21:30:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237013AbiBWCaN (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Feb 2022 21:30:13 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C8DB55768;
        Tue, 22 Feb 2022 18:29:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5715FB81DD2;
        Wed, 23 Feb 2022 02:29:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 109DEC340E8;
        Wed, 23 Feb 2022 02:29:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645583350;
        bh=bUoUjXun1H5cleJ/gc0H1qiSuKbmHGKHPKKSjZmqy6k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cp1DplHsw5DyOtknCToNaDpvoUYflRXN76/PfbR5czQPr+9OevTNviASHwFHxgi0O
         dglYcLIOMu5v+A1mmGio4nSs/sA3lCJJbhvKHRBpe/ZlGMThTZEIIJKjRF27eg/Nyd
         3BJRBlIoINKLhQLFfX4FxaB2hHawQtxtPGjJ1dNEcCnKNfbonybX0VrnyCEWcykG6e
         s4FOegnbpy+2yODXusvAvguRE6QYlObxqLQWR4HB/saV0vuxr0sOaqH7OjFV5MUJNu
         e0Vx9YaMNT37L/6e/Coj6J+V/5r789bMptHkP73LvKpF41xWTzl1Lv01iUwIRFKeLD
         LAgaSiFxQgQRA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Sasha Levin <sashal@kernel.org>, mingo@redhat.com,
        shuah@kernel.org, linux-kselftest@vger.kernel.org
Subject: [PATCH AUTOSEL 5.16 23/30] selftests/ftrace: Do not trace do_softirq because of PREEMPT_RT
Date:   Tue, 22 Feb 2022 21:28:12 -0500
Message-Id: <20220223022820.240649-23-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220223022820.240649-1-sashal@kernel.org>
References: <20220223022820.240649-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

From: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>

[ Upstream commit 6fec1ab67f8d60704cc7de64abcfd389ab131542 ]

The PREEMPT_RT patchset does not use do_softirq() function thus trying
to filter for do_softirq fails for such kernel:

  echo do_softirq
  ftracetest: 81: echo: echo: I/O error

Choose some other visible function for the test.  The function does not
have to be actually executed during the test, because it is only testing
filter API interface.

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Reviewed-by: Shuah Khan <skhan@linuxfoundation.org>
Acked-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Reviewed-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../selftests/ftrace/test.d/ftrace/func_set_ftrace_file.tc      | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/ftrace/test.d/ftrace/func_set_ftrace_file.tc b/tools/testing/selftests/ftrace/test.d/ftrace/func_set_ftrace_file.tc
index e96e279e0533a..25432b8cd5bd2 100644
--- a/tools/testing/selftests/ftrace/test.d/ftrace/func_set_ftrace_file.tc
+++ b/tools/testing/selftests/ftrace/test.d/ftrace/func_set_ftrace_file.tc
@@ -19,7 +19,7 @@ fail() { # mesg
 
 FILTER=set_ftrace_filter
 FUNC1="schedule"
-FUNC2="do_softirq"
+FUNC2="scheduler_tick"
 
 ALL_FUNCS="#### all functions enabled ####"
 
-- 
2.34.1

