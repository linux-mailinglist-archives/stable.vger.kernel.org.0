Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AFAAA594179
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 23:50:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240000AbiHOVKM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 17:10:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348022AbiHOVH4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 17:07:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71722371A1;
        Mon, 15 Aug 2022 12:17:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 02B8E60EF0;
        Mon, 15 Aug 2022 19:17:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1C31C433D6;
        Mon, 15 Aug 2022 19:17:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660591071;
        bh=wuOSQasS4O7g9t9kdiLWCgRp6fK3GbiBlpL7zqz9SuQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cmSdyviezgaVPQu/OAadFy3pCkrSouCdpIHRAmdF2taW/uPtisTpfj4K2Ji1yw0jE
         TyuvgsDmmR7ksstz1+6XpqsqeTKVSYXnwnFbBsQSj4zQh3qrN0Hj5L426Rm9kES/hm
         7wfE/+xVCwxOcBl24oJhMHKOEJ+MxJlWCoXiE6U0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        John Stultz <jstultz@google.com>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0461/1095] selftests: timers: clocksource-switch: fix passing errors from child
Date:   Mon, 15 Aug 2022 19:57:40 +0200
Message-Id: <20220815180448.675806950@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
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
index ef8eb3604595..b57f0a9be490 100644
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



