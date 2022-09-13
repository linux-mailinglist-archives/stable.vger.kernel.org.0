Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F421C5B702B
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 16:24:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233306AbiIMOUn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 10:20:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233709AbiIMOTs (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 10:19:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBE8B65555;
        Tue, 13 Sep 2022 07:14:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CE6B461497;
        Tue, 13 Sep 2022 14:12:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3D71C433D6;
        Tue, 13 Sep 2022 14:12:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663078369;
        bh=QQf0hwylFjIRj63wKXmW9XYh7DnbHSzJRNIvKsNtvDs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wBffrZ1x/ekWDQaPgGnysIJpMlb4EmeTeEehP/aZ9kqiXR2VG651RhFaAlKZDzGb0
         oIBpMypDA4nolXiUU2E9TonhaHqGTjKYYmz5CaIZp4St/zYio0Onn3/inMHyfQYrM2
         JdNi9GnIpWmLOxzXfIB/FCP/pRXI1EsyeczZwXaI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sander Vanheule <sander@svanheule.net>,
        Daniel Latypov <dlatypov@google.com>,
        Brendan Higgins <brendanhiggins@google.com>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 113/192] kunit: fix assert_type for comparison macros
Date:   Tue, 13 Sep 2022 16:03:39 +0200
Message-Id: <20220913140415.604560974@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220913140410.043243217@linuxfoundation.org>
References: <20220913140410.043243217@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Sander Vanheule <sander@svanheule.net>

[ Upstream commit aded3cad909581c60335037112c4f86bbfe90f17 ]

When replacing KUNIT_BINARY_*_MSG_ASSERTION() macros with
KUNIT_BINARY_INT_ASSERTION(), the assert_type parameter was not always
correctly transferred.  Specifically, the following errors were
introduced:
  - KUNIT_EXPECT_LE_MSG() uses KUNIT_ASSERTION
  - KUNIT_ASSERT_LT_MSG() uses KUNIT_EXPECTATION
  - KUNIT_ASSERT_GT_MSG() uses KUNIT_EXPECTATION

A failing KUNIT_EXPECT_LE_MSG() test thus prevents further tests from
running, while failing KUNIT_ASSERT_{LT,GT}_MSG() tests do not prevent
further tests from running.  This is contrary to the documentation,
which states that failing KUNIT_EXPECT_* macros allow further tests to
run, while failing KUNIT_ASSERT_* macros should prevent this.

Revert the KUNIT_{ASSERTION,EXPECTATION} switches to fix the behaviour
for the affected macros.

Fixes: 40f39777ce4f ("kunit: decrease macro layering for integer asserts")
Signed-off-by: Sander Vanheule <sander@svanheule.net>
Reviewed-by: Daniel Latypov <dlatypov@google.com>
Reviewed-by: Brendan Higgins <brendanhiggins@google.com>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/kunit/test.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/kunit/test.h b/include/kunit/test.h
index 8ffcd7de96070..648dbb00a3008 100644
--- a/include/kunit/test.h
+++ b/include/kunit/test.h
@@ -863,7 +863,7 @@ do {									       \
 
 #define KUNIT_EXPECT_LE_MSG(test, left, right, fmt, ...)		       \
 	KUNIT_BINARY_INT_ASSERTION(test,				       \
-				   KUNIT_ASSERTION,			       \
+				   KUNIT_EXPECTATION,			       \
 				   left, <=, right,			       \
 				   fmt,					       \
 				    ##__VA_ARGS__)
@@ -1153,7 +1153,7 @@ do {									       \
 
 #define KUNIT_ASSERT_LT_MSG(test, left, right, fmt, ...)		       \
 	KUNIT_BINARY_INT_ASSERTION(test,				       \
-				   KUNIT_EXPECTATION,			       \
+				   KUNIT_ASSERTION,			       \
 				   left, <, right,			       \
 				   fmt,					       \
 				    ##__VA_ARGS__)
@@ -1194,7 +1194,7 @@ do {									       \
 
 #define KUNIT_ASSERT_GT_MSG(test, left, right, fmt, ...)		       \
 	KUNIT_BINARY_INT_ASSERTION(test,				       \
-				   KUNIT_EXPECTATION,			       \
+				   KUNIT_ASSERTION,			       \
 				   left, >, right,			       \
 				   fmt,					       \
 				    ##__VA_ARGS__)
-- 
2.35.1



