Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B09166C0B4
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 15:03:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231565AbjAPOD4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 09:03:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231684AbjAPODB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 09:03:01 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59650227AC;
        Mon, 16 Jan 2023 06:02:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 87BB260FD7;
        Mon, 16 Jan 2023 14:02:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BC7AC433F0;
        Mon, 16 Jan 2023 14:02:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673877759;
        bh=9mCMPJuQWsCAgIALkJ6Rgbr4wr6MpIz6mnv2eanaGA4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ej3odWh4l5sskHVJPdVRkneA6AB9ABdtSlBXj0k1RxYDt6kqQBzbdt275V13/fpqK
         UTsHzcepP86SzgDGh+uLLHH0E1EHSwnzfo0oIZ0I/9pV3HKlU42nBcsEPrP2gD8RI8
         fcNsHp9qSk2+jdjUD3YdlP+WjQYwJQI9K4CvlqsSl6O6yNoLd02WtfKMcveQow8bgj
         fVDyNVXC1o4kid4cGglN7TlIsNdvxHuyUFVwhMXAHfW32MWp9NNwjcLz97DmGgAbgZ
         6mtehOV+JBIzU4GGfMHPJ/rAoO0rsNQ23zrz7fzqwc+2VqBvEFcw6aM3tjDnKqSVfV
         fDiibBuHUNehw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Max Filippov <jcmvbkbc@gmail.com>, Marco Elver <elver@google.com>,
        Sasha Levin <sashal@kernel.org>, kasan-dev@googlegroups.com
Subject: [PATCH AUTOSEL 6.1 13/53] kcsan: test: don't put the expect array on the stack
Date:   Mon, 16 Jan 2023 09:01:13 -0500
Message-Id: <20230116140154.114951-13-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20230116140154.114951-1-sashal@kernel.org>
References: <20230116140154.114951-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Max Filippov <jcmvbkbc@gmail.com>

[ Upstream commit 5b24ac2dfd3eb3e36f794af3aa7f2828b19035bd ]

Size of the 'expect' array in the __report_matches is 1536 bytes, which
is exactly the default frame size warning limit of the xtensa
architecture.
As a result allmodconfig xtensa kernel builds with the gcc that does not
support the compiler plugins (which otherwise would push the said
warning limit to 2K) fail with the following message:

  kernel/kcsan/kcsan_test.c:257:1: error: the frame size of 1680 bytes
    is larger than 1536 bytes

Fix it by dynamically allocating the 'expect' array.

Signed-off-by: Max Filippov <jcmvbkbc@gmail.com>
Reviewed-by: Marco Elver <elver@google.com>
Tested-by: Marco Elver <elver@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/kcsan/kcsan_test.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/kernel/kcsan/kcsan_test.c b/kernel/kcsan/kcsan_test.c
index dcec1b743c69..a60c561724be 100644
--- a/kernel/kcsan/kcsan_test.c
+++ b/kernel/kcsan/kcsan_test.c
@@ -159,7 +159,7 @@ static bool __report_matches(const struct expect_report *r)
 	const bool is_assert = (r->access[0].type | r->access[1].type) & KCSAN_ACCESS_ASSERT;
 	bool ret = false;
 	unsigned long flags;
-	typeof(observed.lines) expect;
+	typeof(*observed.lines) *expect;
 	const char *end;
 	char *cur;
 	int i;
@@ -168,6 +168,10 @@ static bool __report_matches(const struct expect_report *r)
 	if (!report_available())
 		return false;
 
+	expect = kmalloc(sizeof(observed.lines), GFP_KERNEL);
+	if (WARN_ON(!expect))
+		return false;
+
 	/* Generate expected report contents. */
 
 	/* Title */
@@ -253,6 +257,7 @@ static bool __report_matches(const struct expect_report *r)
 		strstr(observed.lines[2], expect[1])));
 out:
 	spin_unlock_irqrestore(&observed.lock, flags);
+	kfree(expect);
 	return ret;
 }
 
-- 
2.35.1

