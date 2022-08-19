Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53CC859A148
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 18:35:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351671AbiHSQLt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 12:11:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351810AbiHSQKj (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 12:10:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 286CD111C23;
        Fri, 19 Aug 2022 08:56:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1BEE761589;
        Fri, 19 Aug 2022 15:56:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E975C43143;
        Fri, 19 Aug 2022 15:56:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660924613;
        bh=791j+2hWy8TOd/D1gDSC01GR07M5nk56qoSUdhg5FAU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jb72wLmbeA6KM3JKw47hpss9g8TTJUBfev0N+VMrF+zxJ9OvZ0lpj3p2rrYctQO1/
         P5oPa8tcU4h+xeQWCNQBO6Sz9Opo1xD3xFhM2d5a519gRGR0jMnMuitvP4Y00mDt23
         UWfhDWj3FpVGFF7p0oDvpoacVfKGlpeoWZlWWH2s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        John Stultz <jstultz@google.com>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 227/545] selftests: timers: valid-adjtimex: build fix for newer toolchains
Date:   Fri, 19 Aug 2022 17:39:57 +0200
Message-Id: <20220819153839.532535791@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220819153829.135562864@linuxfoundation.org>
References: <20220819153829.135562864@linuxfoundation.org>
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

From: Wolfram Sang <wsa+renesas@sang-engineering.com>

[ Upstream commit 9a162977d20436be5678a8e21a8e58eb4616d86a ]

Toolchains with an include file 'sys/timex.h' based on 3.18 will have a
'clock_adjtime' definition added, so it can't be static in the code:

valid-adjtimex.c:43:12: error: static declaration of ‘clock_adjtime’ follows non-static declaration

Fixes: e03a58c320e1 ("kselftests: timers: Add adjtimex SETOFFSET validity tests")
Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Acked-by: John Stultz <jstultz@google.com>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/timers/valid-adjtimex.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/timers/valid-adjtimex.c b/tools/testing/selftests/timers/valid-adjtimex.c
index 5397de708d3c..48b9a803235a 100644
--- a/tools/testing/selftests/timers/valid-adjtimex.c
+++ b/tools/testing/selftests/timers/valid-adjtimex.c
@@ -40,7 +40,7 @@
 #define ADJ_SETOFFSET 0x0100
 
 #include <sys/syscall.h>
-static int clock_adjtime(clockid_t id, struct timex *tx)
+int clock_adjtime(clockid_t id, struct timex *tx)
 {
 	return syscall(__NR_clock_adjtime, id, tx);
 }
-- 
2.35.1



