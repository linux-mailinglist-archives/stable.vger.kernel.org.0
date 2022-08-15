Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDB265949FF
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 02:16:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354698AbiHOXzG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 19:55:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355336AbiHOXvz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 19:51:55 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1961292F44;
        Mon, 15 Aug 2022 13:16:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B6BFDB80EB1;
        Mon, 15 Aug 2022 20:16:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20BA6C433D6;
        Mon, 15 Aug 2022 20:16:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660594590;
        bh=791j+2hWy8TOd/D1gDSC01GR07M5nk56qoSUdhg5FAU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QxOkdGnxngnk3GLR8e84SPujyN9EwOECSLqRNLraA8gqW5rfs/Tf+vMTCD4Hus99L
         lpjPf0lIfYPGN/5tcbSP6y9LCWheEGV0qX22WCK3RZNmYCoQ0bWzU1oqCANg04JXXD
         c0GY9CD3+UHu80Dmq+nDMktRBKHoUicI1whK1mZY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        John Stultz <jstultz@google.com>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0496/1157] selftests: timers: valid-adjtimex: build fix for newer toolchains
Date:   Mon, 15 Aug 2022 19:57:32 +0200
Message-Id: <20220815180459.503776273@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
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



