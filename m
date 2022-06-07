Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1EB8C54191F
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 23:19:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359344AbiFGVSs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 17:18:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380455AbiFGVQU (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 17:16:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8927F21CBE3;
        Tue,  7 Jun 2022 11:55:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EBF83612F2;
        Tue,  7 Jun 2022 18:55:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06A10C385A2;
        Tue,  7 Jun 2022 18:55:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654628102;
        bh=tO43DjKucU72pP0RHq0rgcL4dGdhO7HahM+k57aUjI0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=05YYQWxlMZdE/e51i1W7QvRYMTIy4XPv8B6BBQQ+61nCuKqgext0e96Dlj8EtYuvX
         jc460Fsr8T9SlYaR9AGjJaTazkJGULiZ7isCvj54DYEtFti/yA9vE9waiTRSuxZv67
         7t9wTzDA4F8bK8rMfn8pJuQbRWGhcvsxNCKXl6cQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Latypov <dlatypov@google.com>,
        Brendan Higgins <brendanhiggins@google.com>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 208/879] kunit: fix executor OOM error handling logic on non-UML
Date:   Tue,  7 Jun 2022 18:55:26 +0200
Message-Id: <20220607165008.887415960@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
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

From: Daniel Latypov <dlatypov@google.com>

[ Upstream commit 1b11063d32d7e11366e48be64215ff517ce32217 ]

The existing logic happens to work fine on UML, but is not correct when
running on other arches.

1. We didn't initialize `int err`, and kunit_filter_suites() doesn't
   explicitly set it to 0 on success. So we had false "failures".
   Note: it doesn't happen on UML, causing this to get overlooked.
2. If we error out, we do not call kunit_handle_shutdown().
   This makes kunit.py timeout when using a non-UML arch, since the QEMU
   process doesn't ever exit.

Fixes: a02353f49162 ("kunit: bail out of test filtering logic quicker if OOM")
Signed-off-by: Daniel Latypov <dlatypov@google.com>
Reviewed-by: Brendan Higgins <brendanhiggins@google.com>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/kunit/executor.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/lib/kunit/executor.c b/lib/kunit/executor.c
index 2f73a6a35a7e..96f96e42ce06 100644
--- a/lib/kunit/executor.c
+++ b/lib/kunit/executor.c
@@ -247,13 +247,13 @@ int kunit_run_all_tests(void)
 		.start = __kunit_suites_start,
 		.end = __kunit_suites_end,
 	};
-	int err;
+	int err = 0;
 
 	if (filter_glob_param) {
 		suite_set = kunit_filter_suites(&suite_set, filter_glob_param, &err);
 		if (err) {
 			pr_err("kunit executor: error filtering suites: %d\n", err);
-			return err;
+			goto out;
 		}
 	}
 
@@ -268,9 +268,10 @@ int kunit_run_all_tests(void)
 		kunit_free_suite_set(suite_set);
 	}
 
-	kunit_handle_shutdown();
 
-	return 0;
+out:
+	kunit_handle_shutdown();
+	return err;
 }
 
 #if IS_BUILTIN(CONFIG_KUNIT_TEST)
-- 
2.35.1



