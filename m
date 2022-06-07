Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62D4E541761
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 23:03:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357659AbiFGVCd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 17:02:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376997AbiFGU7e (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 16:59:34 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A75CA20B163;
        Tue,  7 Jun 2022 11:44:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DD55CB822C0;
        Tue,  7 Jun 2022 18:44:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37FE0C385A2;
        Tue,  7 Jun 2022 18:44:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654627488;
        bh=1CltcFnzp83Lp3shBByI0qoMgoRiBqUKG72OG4ryCK8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T9efbfjyh8JxwJT9HlPIg0iKamPO9GIKqgjgsaAMYEdAouFm2QzoesJ5D52iLC9TS
         0BtP19ZEvzl58Ua2znJeComJQbLLxspIIdh3ObBXdRoDbiS+UY6+Gy7ze2d+DoSOMA
         m6bnLDUHkE5nqHX/iibUtf+nxjR2JPbOculJ9GDM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Gow <davidgow@google.com>,
        Daniel Latypov <dlatypov@google.com>,
        Brendan Higgins <brendanhiggins@google.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Shuah Khan <skhan@linuxfoundation.org>
Subject: [PATCH 5.17 758/772] list: test: Add a test for list_is_head()
Date:   Tue,  7 Jun 2022 19:05:50 +0200
Message-Id: <20220607165011.360823569@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164948.980838585@linuxfoundation.org>
References: <20220607164948.980838585@linuxfoundation.org>
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

From: David Gow <davidgow@google.com>

commit 37dc573c0a547e1aed0c9abb480fab797bd3833f upstream.

list_is_head() was added recently[1], and didn't have a KUnit test. The
implementation is trivial, so it's not a particularly exciting test, but
it'd be nice to get back to full coverage of the list functions.

[1]: https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/include/linux/list.h?id=0425473037db40d9e322631f2d4dc6ef51f97e88

Signed-off-by: David Gow <davidgow@google.com>
Acked-by: Daniel Latypov <dlatypov@google.com>
Acked-by: Brendan Higgins <brendanhiggins@google.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 lib/list-test.c |   19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

--- a/lib/list-test.c
+++ b/lib/list-test.c
@@ -234,6 +234,24 @@ static void list_test_list_bulk_move_tai
 	KUNIT_EXPECT_EQ(test, i, 2);
 }
 
+static void list_test_list_is_head(struct kunit *test)
+{
+	struct list_head a, b, c;
+
+	/* Two lists: [a] -> b, [c] */
+	INIT_LIST_HEAD(&a);
+	INIT_LIST_HEAD(&c);
+	list_add_tail(&b, &a);
+
+	KUNIT_EXPECT_TRUE_MSG(test, list_is_head(&a, &a),
+		"Head element of same list");
+	KUNIT_EXPECT_FALSE_MSG(test, list_is_head(&a, &b),
+		"Non-head element of same list");
+	KUNIT_EXPECT_FALSE_MSG(test, list_is_head(&a, &c),
+		"Head element of different list");
+}
+
+
 static void list_test_list_is_first(struct kunit *test)
 {
 	struct list_head a, b;
@@ -710,6 +728,7 @@ static struct kunit_case list_test_cases
 	KUNIT_CASE(list_test_list_move),
 	KUNIT_CASE(list_test_list_move_tail),
 	KUNIT_CASE(list_test_list_bulk_move_tail),
+	KUNIT_CASE(list_test_list_is_head),
 	KUNIT_CASE(list_test_list_is_first),
 	KUNIT_CASE(list_test_list_is_last),
 	KUNIT_CASE(list_test_list_empty),


