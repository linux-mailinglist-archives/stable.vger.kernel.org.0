Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B1455948F6
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 02:10:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245309AbiHOXL7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 19:11:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353283AbiHOXLJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 19:11:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84E3AE0;
        Mon, 15 Aug 2022 13:00:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A6B8E6068D;
        Mon, 15 Aug 2022 20:00:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B525EC433C1;
        Mon, 15 Aug 2022 20:00:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660593613;
        bh=h1lAwXEzOBwnzyaZlWPDLYxbCPN2BU7bW/+B5CVB0Bs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J0u4ShBk6kw+GRja3stKOs2gEriAfq0Q098M8COs0H/kG1vIed7vPrbvUOW8xllfj
         8kcWKxYRb9Qu3O3vBXy6v0Ki6Us0OvU77NeSzwzWo6VZJwrr9CF4lmk3V/POzE/3Qm
         Z69SO6qjA9qkizLOfyRIq2fuIFHTywFKmtLo6qd0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, YiFei Zhu <zhuyifei@google.com>,
        Kees Cook <keescook@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0296/1157] selftests/seccomp: Fix compile warning when CC=clang
Date:   Mon, 15 Aug 2022 19:54:12 +0200
Message-Id: <20220815180451.485989045@linuxfoundation.org>
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

From: YiFei Zhu <zhuyifei@google.com>

[ Upstream commit 3ce4b78f73e8e00fb86bad67ee7f6fe12019707e ]

clang has -Wconstant-conversion by default, and the constant 0xAAAAAAAAA
(9 As) being converted to an int, which is generally 32 bits, results
in the compile warning:

  clang -Wl,-no-as-needed -Wall -isystem ../../../../usr/include/  -lpthread  seccomp_bpf.c -lcap -o seccomp_bpf
  seccomp_bpf.c:812:67: warning: implicit conversion from 'long' to 'int' changes value from 45812984490 to -1431655766 [-Wconstant-conversion]
          int kill = kill_how == KILL_PROCESS ? SECCOMP_RET_KILL_PROCESS : 0xAAAAAAAAA;
              ~~~~                                                         ^~~~~~~~~~~
  1 warning generated.

-1431655766 is the expected truncation, 0xAAAAAAAA (8 As), so use
this directly in the code to avoid the warning.

Fixes: 3932fcecd962 ("selftests/seccomp: Add test for unknown SECCOMP_RET kill behavior")
Signed-off-by: YiFei Zhu <zhuyifei@google.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
Link: https://lore.kernel.org/r/20220526223407.1686936-1-zhuyifei@google.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/seccomp/seccomp_bpf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/seccomp/seccomp_bpf.c b/tools/testing/selftests/seccomp/seccomp_bpf.c
index 136df5b76319..4ae6c8991307 100644
--- a/tools/testing/selftests/seccomp/seccomp_bpf.c
+++ b/tools/testing/selftests/seccomp/seccomp_bpf.c
@@ -809,7 +809,7 @@ void kill_thread_or_group(struct __test_metadata *_metadata,
 		.len = (unsigned short)ARRAY_SIZE(filter_thread),
 		.filter = filter_thread,
 	};
-	int kill = kill_how == KILL_PROCESS ? SECCOMP_RET_KILL_PROCESS : 0xAAAAAAAAA;
+	int kill = kill_how == KILL_PROCESS ? SECCOMP_RET_KILL_PROCESS : 0xAAAAAAAA;
 	struct sock_filter filter_process[] = {
 		BPF_STMT(BPF_LD|BPF_W|BPF_ABS,
 			offsetof(struct seccomp_data, nr)),
-- 
2.35.1



