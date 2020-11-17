Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B7042B62AC
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:32:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731903AbgKQNa1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:30:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:39416 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731897AbgKQNaU (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:30:20 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A70DD20781;
        Tue, 17 Nov 2020 13:30:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605619819;
        bh=nECDTW9Gsyp5TZueA0mi+UCbEXsRS/LDaGHshSpYZ+s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o5nAfaxIP/Ix1eHKIbYhoPlfMAFfMLeBF3zm5K7UXJ8Tp+NojnrS69E6UiFIXIMPB
         vlO9X18Uke+TKPQUovkwf90YsczA7NZc43O/Y5TeW0Rph9r59GuUJDUI/F+wPpg1w6
         /RzaGmdaoDG9ON6JPTEPplZgW+OnzBcMKoYCT3m4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Brendan Higgins <brendanhiggins@google.com>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 015/255] kunit: Dont fail test suites if one of them is empty
Date:   Tue, 17 Nov 2020 14:02:35 +0100
Message-Id: <20201117122139.684457668@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122138.925150709@linuxfoundation.org>
References: <20201117122138.925150709@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit 3fc48259d5250f7a3ee021ad0492b604c428c564 ]

Empty test suite is okay test suite.

Don't fail the rest of the test suites if one of them is empty.

Fixes: 6ebf5866f2e8 ("kunit: tool: add Python wrappers for running KUnit tests")
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reviewed-by: Brendan Higgins <brendanhiggins@google.com>
Tested-by: Brendan Higgins <brendanhiggins@google.com>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/kunit/kunit_parser.py | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/kunit/kunit_parser.py b/tools/testing/kunit/kunit_parser.py
index 62a0848699671..91036d5d51cf6 100644
--- a/tools/testing/kunit/kunit_parser.py
+++ b/tools/testing/kunit/kunit_parser.py
@@ -232,7 +232,7 @@ def parse_test_suite(lines: List[str]) -> TestSuite:
 		return None
 	test_suite.name = name
 	expected_test_case_num = parse_subtest_plan(lines)
-	if not expected_test_case_num:
+	if expected_test_case_num is None:
 		return None
 	while expected_test_case_num > 0:
 		test_case = parse_test_case(lines)
-- 
2.27.0



