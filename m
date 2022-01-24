Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6818A49A8F8
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 05:18:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1321729AbiAYDTc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 22:19:32 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:45628 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347817AbiAXTs0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 14:48:26 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6F97C612E9;
        Mon, 24 Jan 2022 19:48:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57B78C340E5;
        Mon, 24 Jan 2022 19:48:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643053704;
        bh=485Pel/umrmGTI7pbf0TizhUtAcoT/WJdPbsQcA5Gb0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=w7pCNwDnkVRmKWv9J8izLv8/dX856/Axt+/B8OvTIXYtCj8t9HY0IVkbYjxlA6VRX
         ii2HxKlztTU4CRuzubEsFWwjr3vzF841HCHDV6Ul9KLcY/SjtMGEq4UjcMlIVwaNZd
         HspaySBgkNRxKFvN/WS7637AYD3yFsaLYNeL+wvg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Anders Roxell <anders.roxell@linaro.org>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 151/563] selftests: clone3: clone3: add case CLONE3_ARGS_NO_TEST
Date:   Mon, 24 Jan 2022 19:38:36 +0100
Message-Id: <20220124184029.628320367@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184024.407936072@linuxfoundation.org>
References: <20220124184024.407936072@linuxfoundation.org>
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



