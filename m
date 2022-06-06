Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C32853E1CB
	for <lists+stable@lfdr.de>; Mon,  6 Jun 2022 10:53:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231476AbiFFHuu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Jun 2022 03:50:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231501AbiFFHut (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Jun 2022 03:50:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45E22BBCC2
        for <stable@vger.kernel.org>; Mon,  6 Jun 2022 00:50:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E69FAB811CE
        for <stable@vger.kernel.org>; Mon,  6 Jun 2022 07:50:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5920CC385A9;
        Mon,  6 Jun 2022 07:50:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654501843;
        bh=cj8eJIeeKY9GyixLt2jkU+b2lumKM/pVVq3Ex1qw7ZA=;
        h=Subject:To:Cc:From:Date:From;
        b=1B/R6u42eLSnXx6ySc9drdFlqR+D9AJHumWyXHb1C9RRpBq0oe21nVc/mpD1Iw2N7
         FG/BCEUbic3pwvDCdrk3iahRaZdCsWtpvIaq1LpjfULWoDCVdlDGwF8V2tcBZBSjuq
         JiKhnWhsRxNaoa3LjjopD5PEhQ+bBV1LEnzmgcEQ=
Subject: WTF: patch "[PATCH] selftests/landlock: Add tests for unknown access rights" was seriously submitted to be applied to the 5.18-stable tree?
To:     mic@digikod.net, shuah@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 06 Jun 2022 09:50:33 +0200
Message-ID: <1654501833201@kroah.com>
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

From c56b3bf566da5a0dd3b58ad97a614b0928b06ebf Mon Sep 17 00:00:00 2001
From: =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>
Date: Fri, 6 May 2022 18:08:14 +0200
Subject: [PATCH] selftests/landlock: Add tests for unknown access rights
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Make sure that trying to use unknown access rights returns an error.

Cc: Shuah Khan <shuah@kernel.org>
Link: https://lore.kernel.org/r/20220506160820.524344-5-mic@digikod.net
Cc: stable@vger.kernel.org
Signed-off-by: Mickaël Salaün <mic@digikod.net>

diff --git a/tools/testing/selftests/landlock/fs_test.c b/tools/testing/selftests/landlock/fs_test.c
index cc7fa7b17578..f293b7e2a1a7 100644
--- a/tools/testing/selftests/landlock/fs_test.c
+++ b/tools/testing/selftests/landlock/fs_test.c
@@ -448,6 +448,22 @@ TEST_F_FORK(layout1, file_access_rights)
 	ASSERT_EQ(0, close(path_beneath.parent_fd));
 }
 
+TEST_F_FORK(layout1, unknown_access_rights)
+{
+	__u64 access_mask;
+
+	for (access_mask = 1ULL << 63; access_mask != ACCESS_LAST;
+	     access_mask >>= 1) {
+		struct landlock_ruleset_attr ruleset_attr = {
+			.handled_access_fs = access_mask,
+		};
+
+		ASSERT_EQ(-1, landlock_create_ruleset(&ruleset_attr,
+						      sizeof(ruleset_attr), 0));
+		ASSERT_EQ(EINVAL, errno);
+	}
+}
+
 static void add_path_beneath(struct __test_metadata *const _metadata,
 			     const int ruleset_fd, const __u64 allowed_access,
 			     const char *const path)

