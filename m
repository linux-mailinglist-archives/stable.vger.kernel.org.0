Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69D876D48B3
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 16:31:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233459AbjDCObI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 10:31:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233460AbjDCObH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 10:31:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4AD935020
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 07:31:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4092C61E05
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 14:31:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56DFDC433EF;
        Mon,  3 Apr 2023 14:31:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680532265;
        bh=N7oIYTYSX41R1e4ayN5+sCIljqt4QsteV2O2OTwmmlQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VxKu6lCVlTo44OBkOuqGL6aXx9VCur2sH0MdA9dYTK/dBj1zcVLw/9Wj/LNGYf0n2
         gnnL6DbcPURjzpElSlPj0+kGJzAXz7FtUCl+kT4al/kmRzJsWRGRyNTHXAE46WXq1Y
         eWJGXnDTRvFFaS+pMDHzRaWRLrGh7VYPV2HSt4Cc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Marco Elver <elver@google.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Alexander Potapenko <glider@google.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 05/99] kcsan: avoid passing -g for test
Date:   Mon,  3 Apr 2023 16:08:28 +0200
Message-Id: <20230403140356.266222209@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140356.079638751@linuxfoundation.org>
References: <20230403140356.079638751@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marco Elver <elver@google.com>

[ Upstream commit 5eb39cde1e2487ba5ec1802dc5e58a77e700d99e ]

Nathan reported that when building with GNU as and a version of clang that
defaults to DWARF5, the assembler will complain with:

  Error: non-constant .uleb128 is not supported

This is because `-g` defaults to the compiler debug info default. If the
assembler does not support some of the directives used, the above errors
occur. To fix, remove the explicit passing of `-g`.

All the test wants is that stack traces print valid function names, and
debug info is not required for that. (I currently cannot recall why I
added the explicit `-g`.)

Link: https://lkml.kernel.org/r/20230316224705.709984-2-elver@google.com
Fixes: 1fe84fd4a402 ("kcsan: Add test suite")
Signed-off-by: Marco Elver <elver@google.com>
Reported-by: Nathan Chancellor <nathan@kernel.org>
Cc: Alexander Potapenko <glider@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/kcsan/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/kcsan/Makefile b/kernel/kcsan/Makefile
index 5936288ee938b..c4ddd189f3e07 100644
--- a/kernel/kcsan/Makefile
+++ b/kernel/kcsan/Makefile
@@ -13,6 +13,6 @@ CFLAGS_core.o := $(call cc-option,-fno-conserve-stack) \
 obj-y := core.o debugfs.o report.o
 obj-$(CONFIG_KCSAN_SELFTEST) += selftest.o
 
-CFLAGS_kcsan_test.o := $(CFLAGS_KCSAN) -g -fno-omit-frame-pointer
+CFLAGS_kcsan_test.o := $(CFLAGS_KCSAN) -fno-omit-frame-pointer
 CFLAGS_kcsan_test.o += $(DISABLE_STRUCTLEAK_PLUGIN)
 obj-$(CONFIG_KCSAN_KUNIT_TEST) += kcsan_test.o
-- 
2.39.2



