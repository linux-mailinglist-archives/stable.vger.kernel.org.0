Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57F8953E209
	for <lists+stable@lfdr.de>; Mon,  6 Jun 2022 10:53:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231473AbiFFHvM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Jun 2022 03:51:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231469AbiFFHvL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Jun 2022 03:51:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC29DBF11B
        for <stable@vger.kernel.org>; Mon,  6 Jun 2022 00:51:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 62C3F611BB
        for <stable@vger.kernel.org>; Mon,  6 Jun 2022 07:51:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C08BC385A9;
        Mon,  6 Jun 2022 07:51:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654501869;
        bh=fZjsj+4y0ewCLP3luSVYAWbpdhFKVL1o3vIBnKnwWDU=;
        h=Subject:To:Cc:From:Date:From;
        b=2MKVQQmUUWibLmT2LeQpnCEUZ+JEKjIb5lTTbA30g+YC97f53j8qIPBozAo+bGKBS
         5MounodDEyV9Jsy/X4atQ//n3l1nDf8yG2MwlFV3rgLTVQI/Zh0beh3MITEBsXJU6Q
         mw86c2CTeEACctQ4nJm28fwCcFswcLpgW2kmCgdU=
Subject: WTF: patch "[PATCH] selftests/landlock: Add tests for O_PATH" was seriously submitted to be applied to the 5.18-stable tree?
To:     mic@digikod.net, shuah@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 06 Jun 2022 09:51:07 +0200
Message-ID: <165450186720100@kroah.com>
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

From d1788ad990874734341b05ab8ccb6448c09c6422 Mon Sep 17 00:00:00 2001
From: =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>
Date: Fri, 6 May 2022 18:08:17 +0200
Subject: [PATCH] selftests/landlock: Add tests for O_PATH
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

The O_PATH flag is currently not handled by Landlock.  Let's make sure
this behavior will remain consistent with the same ruleset over time.

Cc: Shuah Khan <shuah@kernel.org>
Link: https://lore.kernel.org/r/20220506160820.524344-8-mic@digikod.net
Cc: stable@vger.kernel.org
Signed-off-by: Mickaël Salaün <mic@digikod.net>

diff --git a/tools/testing/selftests/landlock/fs_test.c b/tools/testing/selftests/landlock/fs_test.c
index 9165f6adf7b9..a8f54c4462eb 100644
--- a/tools/testing/selftests/landlock/fs_test.c
+++ b/tools/testing/selftests/landlock/fs_test.c
@@ -654,17 +654,23 @@ TEST_F_FORK(layout1, effective_access)
 	enforce_ruleset(_metadata, ruleset_fd);
 	ASSERT_EQ(0, close(ruleset_fd));
 
-	/* Tests on a directory. */
+	/* Tests on a directory (with or without O_PATH). */
 	ASSERT_EQ(EACCES, test_open("/", O_RDONLY));
+	ASSERT_EQ(0, test_open("/", O_RDONLY | O_PATH));
 	ASSERT_EQ(EACCES, test_open(dir_s1d1, O_RDONLY));
+	ASSERT_EQ(0, test_open(dir_s1d1, O_RDONLY | O_PATH));
 	ASSERT_EQ(EACCES, test_open(file1_s1d1, O_RDONLY));
+	ASSERT_EQ(0, test_open(file1_s1d1, O_RDONLY | O_PATH));
+
 	ASSERT_EQ(0, test_open(dir_s1d2, O_RDONLY));
 	ASSERT_EQ(0, test_open(file1_s1d2, O_RDONLY));
 	ASSERT_EQ(0, test_open(dir_s1d3, O_RDONLY));
 	ASSERT_EQ(0, test_open(file1_s1d3, O_RDONLY));
 
-	/* Tests on a file. */
+	/* Tests on a file (with or without O_PATH). */
 	ASSERT_EQ(EACCES, test_open(dir_s2d2, O_RDONLY));
+	ASSERT_EQ(0, test_open(dir_s2d2, O_RDONLY | O_PATH));
+
 	ASSERT_EQ(0, test_open(file1_s2d2, O_RDONLY));
 
 	/* Checks effective read and write actions. */

