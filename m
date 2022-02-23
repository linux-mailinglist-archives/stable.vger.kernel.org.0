Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 272544C090D
	for <lists+stable@lfdr.de>; Wed, 23 Feb 2022 03:38:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237302AbiBWChR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Feb 2022 21:37:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237549AbiBWChE (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Feb 2022 21:37:04 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B476C5620F;
        Tue, 22 Feb 2022 18:32:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 598B5B81E01;
        Wed, 23 Feb 2022 02:32:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10825C36AE2;
        Wed, 23 Feb 2022 02:32:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645583538;
        bh=eqQ5mlfAkZYCCNiNrLISO3rHbCORuzSEnZRATE9OR0A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VxDu/FKfii0DBTlJWxznj7LnYUQbL7pZwRwOKPXMJVDZEy11Qf8u2294xC6cMsYvY
         Bdh/yN5+MH/3DdiKsOeT9Ze9vFOoxO27czPTokizPO3GiHZ8BnF8eKPrjqu+Z8eqc+
         Jlpq9l5K94/Ed0PQrVKwIjEKXmqtJEYPkQzhKDav09/9iQLKyIwB10AXexxGzPQ8LK
         3xxW+2ehtNG+sr4H+AD85TKcxLrgCiYgUjNspskI6G7FVL1CrzE9NDKWTAMxVO/Vci
         tcg6foIT4cZqycgo6pdZ2yOHWhYd8xEol3LsVqaIm7QPmRRIWHObqjuSS6+L1rZVIn
         3h2LdtxqBzPUQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Sasha Levin <sashal@kernel.org>, mingo@redhat.com,
        shuah@kernel.org, linux-kselftest@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 09/13] selftests/ftrace: Do not trace do_softirq because of PREEMPT_RT
Date:   Tue, 22 Feb 2022 21:31:48 -0500
Message-Id: <20220223023152.242065-9-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220223023152.242065-1-sashal@kernel.org>
References: <20220223023152.242065-1-sashal@kernel.org>
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
index 68e7a48f5828e..412e5c1f13ca6 100644
--- a/tools/testing/selftests/ftrace/test.d/ftrace/func_set_ftrace_file.tc
+++ b/tools/testing/selftests/ftrace/test.d/ftrace/func_set_ftrace_file.tc
@@ -33,7 +33,7 @@ do_reset
 
 FILTER=set_ftrace_filter
 FUNC1="schedule"
-FUNC2="do_softirq"
+FUNC2="scheduler_tick"
 
 ALL_FUNCS="#### all functions enabled ####"
 
-- 
2.34.1

