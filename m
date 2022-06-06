Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0EFC253E3B6
	for <lists+stable@lfdr.de>; Mon,  6 Jun 2022 10:56:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231235AbiFFHuM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Jun 2022 03:50:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231440AbiFFHt5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Jun 2022 03:49:57 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4588B1C1B
        for <stable@vger.kernel.org>; Mon,  6 Jun 2022 00:49:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id B3DFCCE1685
        for <stable@vger.kernel.org>; Mon,  6 Jun 2022 07:49:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7683C385A9;
        Mon,  6 Jun 2022 07:49:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654501793;
        bh=/GgqjBhTughCHNbpsdF6JU6cZkEnLZm/eP9nuPnuqvs=;
        h=Subject:To:Cc:From:Date:From;
        b=uW5qulZJKUXrimVm44ejNtNgKeRcaHkk+prljF6V4eUsqzEGx3XQ6C17SgPIEN7p5
         DF3LxpMserUFTDuFE1q0F6oz4OzYj7AQLmxpH6onM0kM0JDWkreHo2OgVLdv9egQe/
         bpjpRhWXaJz9R8wjMftceDBQBknpLHCzeirk+25Y=
Subject: WTF: patch "[PATCH] selftests/landlock: Extend tests for minimal valid attribute" was seriously submitted to be applied to the 5.18-stable tree?
To:     mic@digikod.net, shuah@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 06 Jun 2022 09:49:42 +0200
Message-ID: <1654501782106129@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The patch below was submitted to be applied to the 5.18-stable tree.

I fail to see how this patch meets the stable kernel rules as found at
Documentation/process/stable-kernel-rules.rst.

I could be totally wrong, and if so, please respond to 
<stable@vger.kernel.org> and let me know why this patch should be
applied.  Otherwise, it is now dropped from my patch queues, never to be
seen again.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 291865bd7e8bb4b4033d341fa02dafa728e6378c Mon Sep 17 00:00:00 2001
From: =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>
Date: Fri, 6 May 2022 18:08:13 +0200
Subject: [PATCH] selftests/landlock: Extend tests for minimal valid attribute
 size
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This might be useful when the struct landlock_ruleset_attr will get more
fields.

Cc: Shuah Khan <shuah@kernel.org>
Link: https://lore.kernel.org/r/20220506160820.524344-4-mic@digikod.net
Cc: stable@vger.kernel.org
Signed-off-by: Mickaël Salaün <mic@digikod.net>

diff --git a/tools/testing/selftests/landlock/base_test.c b/tools/testing/selftests/landlock/base_test.c
index 3faeae4233a4..be9b937256ac 100644
--- a/tools/testing/selftests/landlock/base_test.c
+++ b/tools/testing/selftests/landlock/base_test.c
@@ -35,6 +35,8 @@ TEST(inconsistent_attr)
 	ASSERT_EQ(EINVAL, errno);
 	ASSERT_EQ(-1, landlock_create_ruleset(ruleset_attr, 1, 0));
 	ASSERT_EQ(EINVAL, errno);
+	ASSERT_EQ(-1, landlock_create_ruleset(ruleset_attr, 7, 0));
+	ASSERT_EQ(EINVAL, errno);
 
 	ASSERT_EQ(-1, landlock_create_ruleset(NULL, 1, 0));
 	/* The size if less than sizeof(struct landlock_attr_enforce). */
@@ -47,6 +49,9 @@ TEST(inconsistent_attr)
 	ASSERT_EQ(-1, landlock_create_ruleset(ruleset_attr, page_size + 1, 0));
 	ASSERT_EQ(E2BIG, errno);
 
+	/* Checks minimal valid attribute size. */
+	ASSERT_EQ(-1, landlock_create_ruleset(ruleset_attr, 8, 0));
+	ASSERT_EQ(ENOMSG, errno);
 	ASSERT_EQ(-1, landlock_create_ruleset(
 			      ruleset_attr,
 			      sizeof(struct landlock_ruleset_attr), 0));

