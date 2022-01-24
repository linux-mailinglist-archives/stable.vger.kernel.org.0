Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9861249A3D2
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 03:04:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2368853AbiAYAAQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 19:00:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1846539AbiAXXQT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 18:16:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAAA2C09425A;
        Mon, 24 Jan 2022 11:48:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 86A4F61523;
        Mon, 24 Jan 2022 19:48:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C56EC340E5;
        Mon, 24 Jan 2022 19:48:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643053708;
        bh=Y/PntOGbeKcLkcguD4MJEGdYfgJmLyuZlGDpwaQ0Bg0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WSWoQNzauf1IPAHuR7RiWReDobLQ/HuT+ZXPaFUp2EVIABorKWJqSkja3IIEwAquS
         +jyNLl66GY8WCkLzTmCla1WZSMzznHzNYYgzFADVUnqp4r97oay4PK6LdLNJ1Qsxj1
         GVFuhi3+gdVoy5xtRH8vqZ8LYJT0e2hdZRp+MhIQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 152/563] selftests: harness: avoid false negatives if test has no ASSERTs
Date:   Mon, 24 Jan 2022 19:38:37 +0100
Message-Id: <20220124184029.661119362@linuxfoundation.org>
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

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit 3abedf4646fdc0036fcb8ebbc3b600667167fafe ]

Test can fail either immediately when ASSERT() failed or at the
end if one or more EXPECT() was not met. The exact return code
is decided based on the number of successful ASSERT()s.

If test has no ASSERT()s, however, the return code will be 0,
as if the test did not fail. Start counting ASSERT()s from 1.

Fixes: 369130b63178 ("selftests: Enhance kselftest_harness.h to print which assert failed")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/kselftest_harness.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kselftest_harness.h b/tools/testing/selftests/kselftest_harness.h
index edce85420d193..5ecb9718e1616 100644
--- a/tools/testing/selftests/kselftest_harness.h
+++ b/tools/testing/selftests/kselftest_harness.h
@@ -965,7 +965,7 @@ void __run_test(struct __fixture_metadata *f,
 	t->passed = 1;
 	t->skip = 0;
 	t->trigger = 0;
-	t->step = 0;
+	t->step = 1;
 	t->no_print = 0;
 	memset(t->results->reason, 0, sizeof(t->results->reason));
 
-- 
2.34.1



