Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B24636812B2
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 15:24:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237676AbjA3OYL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 09:24:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236816AbjA3OXw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 09:23:52 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 071FD3CE2E
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 06:22:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9D1ECB811D6
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 14:22:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0A16C433EF;
        Mon, 30 Jan 2023 14:22:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675088564;
        bh=cdHe+udxpYgClHlqye1cFOO9CWwTQDqhBz7JE/8s0dg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wXh+Q7c0BqMc2+3Bs4/3Yu4m5+gK6RBDxE+D0y8k52Fa5QLweGffb6enfMegEIsaH
         raAnRNztOYwCR4hPPsSVsFc6otTpSdUtvGiOM3FPHpFLZ4K+3zF23xqhFlTnJ4PVfP
         SCDIuSapNaJcyVNEMyyF8Ax8CA7ikLZioDux5A58=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Max Filippov <jcmvbkbc@gmail.com>,
        Marco Elver <elver@google.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 062/143] kcsan: test: dont put the expect array on the stack
Date:   Mon, 30 Jan 2023 14:51:59 +0100
Message-Id: <20230130134309.412251750@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134306.862721518@linuxfoundation.org>
References: <20230130134306.862721518@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
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
 kernel/kcsan/kcsan-test.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/kernel/kcsan/kcsan-test.c b/kernel/kcsan/kcsan-test.c
index ebe7fd245104..8a8ccaf4f38f 100644
--- a/kernel/kcsan/kcsan-test.c
+++ b/kernel/kcsan/kcsan-test.c
@@ -149,7 +149,7 @@ static bool report_matches(const struct expect_report *r)
 	const bool is_assert = (r->access[0].type | r->access[1].type) & KCSAN_ACCESS_ASSERT;
 	bool ret = false;
 	unsigned long flags;
-	typeof(observed.lines) expect;
+	typeof(*observed.lines) *expect;
 	const char *end;
 	char *cur;
 	int i;
@@ -158,6 +158,10 @@ static bool report_matches(const struct expect_report *r)
 	if (!report_available())
 		return false;
 
+	expect = kmalloc(sizeof(observed.lines), GFP_KERNEL);
+	if (WARN_ON(!expect))
+		return false;
+
 	/* Generate expected report contents. */
 
 	/* Title */
@@ -241,6 +245,7 @@ static bool report_matches(const struct expect_report *r)
 		strstr(observed.lines[2], expect[1])));
 out:
 	spin_unlock_irqrestore(&observed.lock, flags);
+	kfree(expect);
 	return ret;
 }
 
-- 
2.39.0



