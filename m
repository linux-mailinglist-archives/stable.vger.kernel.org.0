Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE923540F46
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 21:07:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353590AbiFGTHA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 15:07:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354331AbiFGTFt (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 15:05:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8530318FF35;
        Tue,  7 Jun 2022 11:05:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 89482617A5;
        Tue,  7 Jun 2022 18:05:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 948A7C385A5;
        Tue,  7 Jun 2022 18:05:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654625129;
        bh=a6TL4JGMCf1l+ghTXObmrd74SYUyO4vsE8A7pjANyUU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uHWbzh4tg0QUUjmaL+B/h884BfqqyU0wPo24ww2JXcrP7Wf1V8qHhDRQqceg6AIr3
         J0ny2YxqxtHc53XiOwMNk7YsvK7XMfKLXtfanSOPB2CGQvf9222cjLCuSaZGKQz8Ab
         lBs82Lk7+DQKJL0QHrRlha32smEBaBp+6ZXaRdYE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shuah Khan <shuah@kernel.org>,
        =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>
Subject: [PATCH 5.15 577/667] selftests/landlock: Add tests for unknown access rights
Date:   Tue,  7 Jun 2022 19:04:02 +0200
Message-Id: <20220607164951.996604451@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164934.766888869@linuxfoundation.org>
References: <20220607164934.766888869@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Mickaël Salaün <mic@digikod.net>

commit c56b3bf566da5a0dd3b58ad97a614b0928b06ebf upstream.

Make sure that trying to use unknown access rights returns an error.

Cc: Shuah Khan <shuah@kernel.org>
Link: https://lore.kernel.org/r/20220506160820.524344-5-mic@digikod.net
Cc: stable@vger.kernel.org
Signed-off-by: Mickaël Salaün <mic@digikod.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/landlock/fs_test.c |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

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


