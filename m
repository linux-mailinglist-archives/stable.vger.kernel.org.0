Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C10A60B44C
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 19:36:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232622AbiJXRgr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 13:36:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233156AbiJXRg0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 13:36:26 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F6001EEF28;
        Mon, 24 Oct 2022 09:11:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 31135B8119A;
        Mon, 24 Oct 2022 11:46:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FCA9C433D7;
        Mon, 24 Oct 2022 11:46:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666611969;
        bh=fUXui3hNiQJBFOrbrz2xSQ/YsqpV42/0c9IkyRDduHY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=p+TTl//keN4X9JAk7awoVUlw3mvo9VblBqD9lq46gBsEq3dYjQG8bpxwETyjt9kow
         D3TThEAmWeyGJp5yoQehAfwfDE8Z5S2OYbM4tadJTyBdYCRFQf82OHjljSoMr7raU9
         /j6P7gM6XFoQj8TDuEGDLTN8kZR8MfSZLtZPUkSI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nathan Chancellor <nathan@kernel.org>,
        Sami Tolvanen <samitolvanen@google.com>,
        Kees Cook <keescook@chromium.org>
Subject: [PATCH 4.14 020/210] Makefile.extrawarn: Move -Wcast-function-type-strict to W=1
Date:   Mon, 24 Oct 2022 13:28:57 +0200
Message-Id: <20221024112957.612369058@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024112956.797777597@linuxfoundation.org>
References: <20221024112956.797777597@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sami Tolvanen <samitolvanen@google.com>

commit 2120635108b35ecad9c59c8b44f6cbdf4f98214e upstream.

We enable -Wcast-function-type globally in the kernel to warn about
mismatching types in function pointer casts. Compilers currently
warn only about ABI incompability with this flag, but Clang 16 will
enable a stricter version of the check by default that checks for an
exact type match. This will be very noisy in the kernel, so disable
-Wcast-function-type-strict without W=1 until the new warnings have
been addressed.

Cc: stable@vger.kernel.org
Link: https://reviews.llvm.org/D134831
Link: https://github.com/ClangBuiltLinux/linux/issues/1724
Suggested-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
Link: https://lore.kernel.org/r/20220930203310.4010564-1-samitolvanen@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 scripts/Makefile.extrawarn |    1 +
 1 file changed, 1 insertion(+)

--- a/scripts/Makefile.extrawarn
+++ b/scripts/Makefile.extrawarn
@@ -74,5 +74,6 @@ KBUILD_CFLAGS += $(call cc-disable-warni
 KBUILD_CFLAGS += $(call cc-disable-warning, uninitialized)
 KBUILD_CFLAGS += $(call cc-disable-warning, pointer-to-enum-cast)
 KBUILD_CFLAGS += $(call cc-disable-warning, unaligned-access)
+KBUILD_CFLAGS += $(call cc-disable-warning, cast-function-type-strict)
 endif
 endif


