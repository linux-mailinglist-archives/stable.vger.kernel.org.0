Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF6AF137FF0
	for <lists+stable@lfdr.de>; Sat, 11 Jan 2020 11:25:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730644AbgAKKYQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Jan 2020 05:24:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:52906 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730977AbgAKKYQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Jan 2020 05:24:16 -0500
Received: from localhost (unknown [62.119.166.9])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EB422205F4;
        Sat, 11 Jan 2020 10:24:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578738255;
        bh=OcNdbwEliGVpOYbXVJ9ALqYcB+eJC/IuXzLGPdaSWkA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zdGZxuC2OjcxcnS4bBFlpWyCu9KEvbtWGT9B9fpm0sCwpDxups6LPWgLr1HJkOqW7
         mTChacN9DvfvoVx59vdIeL0S8rBYW275ek+S2l7DLIRSMvs4giNkLM5CB6dawbSoCx
         6fkq/GtqKriwAShZwgX+XrWwPWuoZSJqkMwMoSfA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, SeongJae Park <sjpark@amazon.de>,
        Kees Cook <keescook@chromium.org>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 060/165] kselftest/runner: Print new line in print of timeout log
Date:   Sat, 11 Jan 2020 10:49:39 +0100
Message-Id: <20200111094926.204891138@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200111094921.347491861@linuxfoundation.org>
References: <20200111094921.347491861@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: SeongJae Park <sjpark@amazon.de>

[ Upstream commit d187801d1a46519d2a322f879f7c8f85c685372e ]

If a timeout failure occurs, kselftest kills the test process and prints
the timeout log.  If the test process has killed while printing a log
that ends with new line, the timeout log can be printed in middle of the
test process output so that it can be seems like a comment, as below:

    # test_process_log	not ok 3 selftests: timers: nsleep-lat # TIMEOUT

This commit avoids such problem by printing one more line before the
TIMEOUT failure log.

Signed-off-by: SeongJae Park <sjpark@amazon.de>
Acked-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/kselftest/runner.sh | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/kselftest/runner.sh b/tools/testing/selftests/kselftest/runner.sh
index 84de7bc74f2c..a8d20cbb711c 100644
--- a/tools/testing/selftests/kselftest/runner.sh
+++ b/tools/testing/selftests/kselftest/runner.sh
@@ -79,6 +79,7 @@ run_one()
 		if [ $rc -eq $skip_rc ]; then	\
 			echo "not ok $test_num $TEST_HDR_MSG # SKIP"
 		elif [ $rc -eq $timeout_rc ]; then \
+			echo "#"
 			echo "not ok $test_num $TEST_HDR_MSG # TIMEOUT"
 		else
 			echo "not ok $test_num $TEST_HDR_MSG # exit=$rc"
-- 
2.20.1



