Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E860512B667
	for <lists+stable@lfdr.de>; Fri, 27 Dec 2019 18:42:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727887AbfL0Rmc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Dec 2019 12:42:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:39472 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727878AbfL0Rmc (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 27 Dec 2019 12:42:32 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B7C57218AC;
        Fri, 27 Dec 2019 17:42:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577468551;
        bh=OcNdbwEliGVpOYbXVJ9ALqYcB+eJC/IuXzLGPdaSWkA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K8VCd2+ym1LHUyT4IgjzPXAoydTfZcbdXIpMG/uz4BmBrRnpFrFFsiO2eSbmrHVC5
         qwnMYoFA/cyL0PNpviCSQSLCB9oBpZbiD4Xl0I9GUye+DpAMe294Ijievo9DRXj4Ig
         DUsxypKIygz67ly9zVqv/uCVb2K8bz5epMkKFyBs=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     SeongJae Park <sjpark@amazon.de>,
        Kees Cook <keescook@chromium.org>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-kselftest@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 078/187] kselftest/runner: Print new line in print of timeout log
Date:   Fri, 27 Dec 2019 12:39:06 -0500
Message-Id: <20191227174055.4923-78-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191227174055.4923-1-sashal@kernel.org>
References: <20191227174055.4923-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

