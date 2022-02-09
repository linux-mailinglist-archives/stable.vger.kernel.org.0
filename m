Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 340024AFA45
	for <lists+stable@lfdr.de>; Wed,  9 Feb 2022 19:36:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239504AbiBISfk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Feb 2022 13:35:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239577AbiBISf2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Feb 2022 13:35:28 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B928BC050CC2;
        Wed,  9 Feb 2022 10:35:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 222AA61B86;
        Wed,  9 Feb 2022 18:35:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 724F6C340E7;
        Wed,  9 Feb 2022 18:35:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644431729;
        bh=oHwyv9i4nomRFDXyb1ov4PujWD+EPAnMLWxspRvR/Dw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=q604vlDu20mFSxovfa4Ae5Son1TZwyPKhoNQhBNwsZJUQL3MsfSJmo1glg/Pix1ar
         N8XDbF5yepEtMKv3PoHyGziW0TJ2bDhR0G+QkWHwZJ0rDkcs1A+G4yutY/siHl+dYe
         TwweeMWEl3Q3OMHhLi9doNR7bY7VQ3bQo+taG0q4vZScYanvhHwkitw2H887LFq2pN
         VZGgLCjnWnOCXxoKK6O2ZsYZaitCdAh+WWLEXSbdbLMIDWTXSI/ZyeQjTEkJuFi7MQ
         ImnFgFJ+KqnDrHIwKrCQSNzlIz62iDf1tiBu2za8wdKtc8VD10WA901fMMTMIlHtWF
         RKuR8ivp5MyKA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Cristian Marussi <cristian.marussi@arm.com>,
        Aleksa Sarai <cyphar@cyphar.com>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, shuah@kernel.org,
        brauner@kernel.org, rgb@redhat.com, baolin.wang@linux.alibaba.com,
        linux-kselftest@vger.kernel.org
Subject: [PATCH AUTOSEL 5.16 16/42] selftests: openat2: Skip testcases that fail with EOPNOTSUPP
Date:   Wed,  9 Feb 2022 13:32:48 -0500
Message-Id: <20220209183335.46545-16-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220209183335.46545-1-sashal@kernel.org>
References: <20220209183335.46545-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Cristian Marussi <cristian.marussi@arm.com>

[ Upstream commit ac9e0a250bb155078601a5b999aab05f2a04d1ab ]

Skip testcases that fail since the requested valid flags combination is not
supported by the underlying filesystem.

Cc: Aleksa Sarai <cyphar@cyphar.com>
Signed-off-by: Cristian Marussi <cristian.marussi@arm.com>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/openat2/openat2_test.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/openat2/openat2_test.c b/tools/testing/selftests/openat2/openat2_test.c
index 1bddbe934204c..7fb902099de45 100644
--- a/tools/testing/selftests/openat2/openat2_test.c
+++ b/tools/testing/selftests/openat2/openat2_test.c
@@ -259,6 +259,16 @@ void test_openat2_flags(void)
 		unlink(path);
 
 		fd = sys_openat2(AT_FDCWD, path, &test->how);
+		if (fd < 0 && fd == -EOPNOTSUPP) {
+			/*
+			 * Skip the testcase if it failed because not supported
+			 * by FS. (e.g. a valid O_TMPFILE combination on NFS)
+			 */
+			ksft_test_result_skip("openat2 with %s fails with %d (%s)\n",
+					      test->name, fd, strerror(-fd));
+			goto next;
+		}
+
 		if (test->err >= 0)
 			failed = (fd < 0);
 		else
@@ -303,7 +313,7 @@ void test_openat2_flags(void)
 		else
 			resultfn("openat2 with %s fails with %d (%s)\n",
 				 test->name, test->err, strerror(-test->err));
-
+next:
 		free(fdpath);
 		fflush(stdout);
 	}
-- 
2.34.1

