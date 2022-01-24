Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A737C499FEA
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 00:24:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1842367AbiAXXBo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 18:01:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1839748AbiAXWvx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 17:51:53 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9396C09D9F7;
        Mon, 24 Jan 2022 13:08:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 71B50B81057;
        Mon, 24 Jan 2022 21:08:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1ECFC340E5;
        Mon, 24 Jan 2022 21:07:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643058479;
        bh=485Pel/umrmGTI7pbf0TizhUtAcoT/WJdPbsQcA5Gb0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=viZIaBjaN+YzeMo/jKDS89p2LZG23lpMRVS/nn9k4XoShFJDDnatlkTlDPCgL6gsF
         qYrLWJLRpqGKxY7YGEjHRsKm6uZhLe3mvoJYbzlU5ibqo/UP2nL327ascOqDJaEZMO
         /Y7/dnw3Oi1QvvSc2Z+Tm3vNdvMXBzzsvFgpAFCE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Anders Roxell <anders.roxell@linaro.org>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0269/1039] selftests: clone3: clone3: add case CLONE3_ARGS_NO_TEST
Date:   Mon, 24 Jan 2022 19:34:18 +0100
Message-Id: <20220124184134.343027218@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Anders Roxell <anders.roxell@linaro.org>

[ Upstream commit a531b0c23c0fc68ad758cc31a74cf612a4dafeb0 ]

Building selftests/clone3 with clang warns about enumeration not handled
in switch case:

clone3.c:54:10: warning: enumeration value 'CLONE3_ARGS_NO_TEST' not handled in switch [-Wswitch]
        switch (test_mode) {
                ^

Add the missing switch case with a comment.

Fixes: 17a810699c18 ("selftests: add tests for clone3()")
Signed-off-by: Anders Roxell <anders.roxell@linaro.org>
Acked-by: Christian Brauner <christian.brauner@ubuntu.com>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/clone3/clone3.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/tools/testing/selftests/clone3/clone3.c b/tools/testing/selftests/clone3/clone3.c
index 42be3b9258301..076cf4325f783 100644
--- a/tools/testing/selftests/clone3/clone3.c
+++ b/tools/testing/selftests/clone3/clone3.c
@@ -52,6 +52,12 @@ static int call_clone3(uint64_t flags, size_t size, enum test_mode test_mode)
 		size = sizeof(struct __clone_args);
 
 	switch (test_mode) {
+	case CLONE3_ARGS_NO_TEST:
+		/*
+		 * Uses default 'flags' and 'SIGCHLD'
+		 * assignment.
+		 */
+		break;
 	case CLONE3_ARGS_ALL_0:
 		args.flags = 0;
 		args.exit_signal = 0;
-- 
2.34.1



