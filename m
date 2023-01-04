Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8CB165D8DD
	for <lists+stable@lfdr.de>; Wed,  4 Jan 2023 17:19:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239930AbjADQTG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Jan 2023 11:19:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239938AbjADQTD (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Jan 2023 11:19:03 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F8605FBB
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 08:19:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0A514617A9
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 16:19:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1748CC433D2;
        Wed,  4 Jan 2023 16:19:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672849141;
        bh=VXnpT57LO7V8ngBoyGmLg/BPvjwAqSab65QuIKs9udo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a6BN/cMvb88xCO2+d4Z8Moo/16SVYLcAp5TKwKrsROpmjjpDIfWurHwORWqpagHuV
         zQLP1l+V+wzi75BdPA1tJaGG8k2xYlp4j1kDelh+pzN30gSNJff+3VHD7LU9OaX4RN
         iamsTGdxOvenINnY6WgFUhP8rxDfePDWyvPyg8Ss=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Li Hua <hucool.lihua@huawei.com>,
        "Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Subject: [PATCH 6.1 141/207] test_kprobes: Fix implicit declaration error of test_kprobes
Date:   Wed,  4 Jan 2023 17:06:39 +0100
Message-Id: <20230104160516.389991695@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230104160511.905925875@linuxfoundation.org>
References: <20230104160511.905925875@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Li Hua <hucool.lihua@huawei.com>

commit 63a4dc0a0bb0e9bfeb2c88ccda81abdde4cdd6b8 upstream.

If KPROBES_SANITY_TEST and ARCH_CORRECT_STACKTRACE_ON_KRETPROBE is enabled, but
STACKTRACE is not set. Build failed as below:

lib/test_kprobes.c: In function ‘stacktrace_return_handler’:
lib/test_kprobes.c:228:8: error: implicit declaration of function ‘stack_trace_save’; did you mean ‘stacktrace_driver’? [-Werror=implicit-function-declaration]
  ret = stack_trace_save(stack_buf, STACK_BUF_SIZE, 0);
        ^~~~~~~~~~~~~~~~
        stacktrace_driver
cc1: all warnings being treated as errors
scripts/Makefile.build:250: recipe for target 'lib/test_kprobes.o' failed
make[2]: *** [lib/test_kprobes.o] Error 1

To fix this error, Select STACKTRACE if ARCH_CORRECT_STACKTRACE_ON_KRETPROBE is enabled.

Link: https://lore.kernel.org/all/20221121030620.63181-1-hucool.lihua@huawei.com/

Fixes: 1f6d3a8f5e39 ("kprobes: Add a test case for stacktrace from kretprobe handler")
Cc: stable@vger.kernel.org
Signed-off-by: Li Hua <hucool.lihua@huawei.com>
Acked-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 lib/Kconfig.debug |    1 +
 1 file changed, 1 insertion(+)

--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -2092,6 +2092,7 @@ config TEST_MIN_HEAP
 config TEST_SORT
 	tristate "Array-based sort test" if !KUNIT_ALL_TESTS
 	depends on KUNIT
+	select STACKTRACE if ARCH_CORRECT_STACKTRACE_ON_KRETPROBE
 	default KUNIT_ALL_TESTS
 	help
 	  This option enables the self-test function of 'sort()' at boot,


