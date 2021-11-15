Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D05C545103C
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 19:42:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242683AbhKOSo6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 13:44:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:47396 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241860AbhKOSms (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:42:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C9851632B1;
        Mon, 15 Nov 2021 18:05:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636999520;
        bh=lpkMv/eNHWRFmJnGhEYaeuMfRWDXze1aNzpiXmhpC2E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PbDGSE0J5yqTEQVFoXJ6oHoo9Yd0Gfa2lXrc3CNfSU7B6V8/TCAOfO2U8g2Vm+u9B
         +oqZDar8oFLRl+mbrXTtzYarzkTR51NFwXzdcwmgLejyWBZThBs+MuY1LbeTF1C6Yv
         tY4bkvCT2zAN+k+bbMQ9FZQ3HjktkaXBdr2ufxnk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shuah Khan <skhan@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 328/849] selftests/core: fix conflicting types compile error for close_range()
Date:   Mon, 15 Nov 2021 17:56:51 +0100
Message-Id: <20211115165431.339632236@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
References: <20211115165419.961798833@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shuah Khan <skhan@linuxfoundation.org>

[ Upstream commit f35dcaa0a8a29188ed61083d153df1454cf89d08 ]

close_range() test type conflicts with close_range() library call in
x86_64-linux-gnu/bits/unistd_ext.h. Fix it by changing the name to
core_close_range().

gcc -g -I../../../../usr/include/    close_range_test.c  -o ../tools/testing/selftests/core/close_range_test
In file included from close_range_test.c:16:
close_range_test.c:57:6: error: conflicting types for ‘close_range’; have ‘void(struct __test_metadata *)’
   57 | TEST(close_range)
      |      ^~~~~~~~~~~
../kselftest_harness.h:181:21: note: in definition of macro ‘__TEST_IMPL’
  181 |         static void test_name(struct __test_metadata *_metadata); \
      |                     ^~~~~~~~~
close_range_test.c:57:1: note: in expansion of macro ‘TEST’
   57 | TEST(close_range)
      | ^~~~
In file included from /usr/include/unistd.h:1204,
                 from close_range_test.c:13:
/usr/include/x86_64-linux-gnu/bits/unistd_ext.h:56:12: note: previous declaration of ‘close_range’ with type ‘int(unsigned int,  unsigned int,  int)’
   56 | extern int close_range (unsigned int __fd, unsigned int __max_fd,
      |            ^~~~~~~~~~~

Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/core/close_range_test.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/core/close_range_test.c b/tools/testing/selftests/core/close_range_test.c
index 73eb29c916d1b..aa7d13d91963f 100644
--- a/tools/testing/selftests/core/close_range_test.c
+++ b/tools/testing/selftests/core/close_range_test.c
@@ -54,7 +54,7 @@ static inline int sys_close_range(unsigned int fd, unsigned int max_fd,
 #define ARRAY_SIZE(x) (sizeof(x) / sizeof((x)[0]))
 #endif
 
-TEST(close_range)
+TEST(core_close_range)
 {
 	int i, ret;
 	int open_fds[101];
-- 
2.33.0



