Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC96F59A1C9
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 18:35:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351518AbiHSQLo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 12:11:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351930AbiHSQLD (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 12:11:03 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61DCD11231E;
        Fri, 19 Aug 2022 08:56:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 134B6B82819;
        Fri, 19 Aug 2022 15:56:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42FABC43140;
        Fri, 19 Aug 2022 15:56:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660924616;
        bh=/bz97d8eC9tLEAccbjF2RV+Ifl5jlUarddDXwnlxLb8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WTWly/4lAAMJp8TTX5S2Ia4+lueVyqfeeRmvZx77R6r+x14Psj1nWySpY4/a7qzix
         qa2PZXDIQbJVkjMx8av5aEG24ieLRkvJ4jJZjGIWebaqwr9sLJJB8QKDir/WigTv/T
         pqbyzWTeR+2uRND5b373mBaMINwea8P8ujsQ1EiE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        John Stultz <jstultz@google.com>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 228/545] selftests: timers: clocksource-switch: fix passing errors from child
Date:   Fri, 19 Aug 2022 17:39:58 +0200
Message-Id: <20220819153839.572434394@linuxfoundation.org>
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

[ Upstream commit 4d8f52ac5fa9eede7b7aa2f2d67c841d9eeb655f ]

The return value from system() is a waitpid-style integer. Do not return
it directly because with the implicit masking in exit() it will always
return 0. Access it with appropriate macros to really pass on errors.

Fixes: 7290ce1423c3 ("selftests/timers: Add clocksource-switch test from timetest suite")
Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Acked-by: John Stultz <jstultz@google.com>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/timers/clocksource-switch.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/timers/clocksource-switch.c b/tools/testing/selftests/timers/clocksource-switch.c
index bfc974b4572d..c18313a5f357 100644
--- a/tools/testing/selftests/timers/clocksource-switch.c
+++ b/tools/testing/selftests/timers/clocksource-switch.c
@@ -110,10 +110,10 @@ int run_tests(int secs)
 
 	sprintf(buf, "./inconsistency-check -t %i", secs);
 	ret = system(buf);
-	if (ret)
-		return ret;
+	if (WIFEXITED(ret) && WEXITSTATUS(ret))
+		return WEXITSTATUS(ret);
 	ret = system("./nanosleep");
-	return ret;
+	return WIFEXITED(ret) ? WEXITSTATUS(ret) : 0;
 }
 
 
-- 
2.35.1



