Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA7AA499790
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:28:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1448744AbiAXVNo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:13:44 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:59782 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1446371AbiAXVIF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:08:05 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A35BDB81057;
        Mon, 24 Jan 2022 21:08:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5D10C340EB;
        Mon, 24 Jan 2022 21:08:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643058482;
        bh=qNBywZO7Q40NSzdO4zwsqXT66WdGUyNv/559Vflwzns=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l/kWXL/BG8VMaz1iVrc2MA9HIPzsyu0WB34PN2dc7gTw4UXYhRDtub7MWYeXcEGCC
         +7OxYmbabE6O7l4waKlgNBHiJY3jelKhIP5IFFY8h2dqm0jUkVnXHgaJ99cLh7A36y
         nyVusdeBXhr/uqTx1hElvzcwT0dwkd9t+trxargg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0270/1039] selftests: harness: avoid false negatives if test has no ASSERTs
Date:   Mon, 24 Jan 2022 19:34:19 +0100
Message-Id: <20220124184134.380131577@linuxfoundation.org>
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
index ae0f0f33b2a6e..79a182cfa43ad 100644
--- a/tools/testing/selftests/kselftest_harness.h
+++ b/tools/testing/selftests/kselftest_harness.h
@@ -969,7 +969,7 @@ void __run_test(struct __fixture_metadata *f,
 	t->passed = 1;
 	t->skip = 0;
 	t->trigger = 0;
-	t->step = 0;
+	t->step = 1;
 	t->no_print = 0;
 	memset(t->results->reason, 0, sizeof(t->results->reason));
 
-- 
2.34.1



