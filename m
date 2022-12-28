Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 466866584CE
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 18:03:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233776AbiL1RDE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 12:03:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231745AbiL1RCa (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 12:02:30 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 524FCEA3
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:56:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9BB6EB8188A
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:56:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4163C433D2;
        Wed, 28 Dec 2022 16:56:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672246582;
        bh=viAwfO3RI0U6SfdLXJO9hpCyP45/2q2Rs9X/DWs8k6M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RPRZZkydY2NLoLaanMoeNNkSCU9xMWMR9wK1C3+ZTJOWygFwOs42zJC+YUop/BiLs
         tFX7LF6Q/SU6MAAGDIZVz9vxyIqvnq+QzkoN9VViRR7qA1Y0GV4xzn77RXtDakpq0o
         /TtwbRNw6GGHRHQr6OUNH3VQ+quebpaAKIF5X2mo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Mark Rutland <mark.rutland@arm.com>,
        Sami Tolvanen <samitolvanen@google.com>,
        Kees Cook <keescook@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1089/1146] cfi: Fix CFI failure with KASAN
Date:   Wed, 28 Dec 2022 15:43:48 +0100
Message-Id: <20221228144359.766288307@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
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

From: Sami Tolvanen <samitolvanen@google.com>

[ Upstream commit cf8016408d880afe9c5dc495af40dc2932874e77 ]

When CFI_CLANG and KASAN are both enabled, LLVM doesn't generate a
CFI type hash for asan.module_ctor functions in translation units
where CFI is disabled, which leads to a CFI failure during boot when
do_ctors calls the affected constructors:

  CFI failure at do_basic_setup+0x64/0x90 (target:
  asan.module_ctor+0x0/0x28; expected type: 0xa540670c)

Specifically, this happens because CFI is disabled for
kernel/cfi.c. There's no reason to keep CFI disabled here anymore, so
fix the failure by not filtering out CC_FLAGS_CFI for the file.

Note that https://reviews.llvm.org/rG3b14862f0a96 fixed the issue
where LLVM didn't emit CFI type hashes for any sanitizer constructors,
but now type hashes are emitted correctly for TUs that use CFI.

Link: https://github.com/ClangBuiltLinux/linux/issues/1742
Fixes: 89245600941e ("cfi: Switch to -fsanitize=kcfi")
Reported-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
Link: https://lore.kernel.org/r/20221222225747.3538676-1-samitolvanen@google.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/Makefile | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/kernel/Makefile b/kernel/Makefile
index d754e0be1176..ebc692242b68 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -41,9 +41,6 @@ UBSAN_SANITIZE_kcov.o := n
 KMSAN_SANITIZE_kcov.o := n
 CFLAGS_kcov.o := $(call cc-option, -fno-conserve-stack) -fno-stack-protector
 
-# Don't instrument error handlers
-CFLAGS_REMOVE_cfi.o := $(CC_FLAGS_CFI)
-
 obj-y += sched/
 obj-y += locking/
 obj-y += power/
-- 
2.35.1



