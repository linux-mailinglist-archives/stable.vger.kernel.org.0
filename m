Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B0B2658464
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:57:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232511AbiL1Q5F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:57:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235233AbiL1Q4M (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:56:12 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58D23BE1
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:51:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E8B23B8188B
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:51:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C044C433F0;
        Wed, 28 Dec 2022 16:51:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672246289;
        bh=Y7kbWXuDOj+hzcAssOqgpvYiCnNRoXh9Wx+/4unqG7g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VZxO19oN9j9/mXFOhMcMrS0g7BrhUo+Xk/dOo8GUTfq5bnEQHudx3JlXF0woT6mu0
         TJ8Q6ZqQcH83k7couDwwLyVG7hkcFYIne6PlB2FJe5/7jusPFpd/Z3sbu2C4TTE785
         XnBB6CFiWyTnYrdHpfRyph5Rm3+OZDz9VoZA4I5g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Nathan Chancellor <nathan@kernel.org>,
        Kees Cook <keescook@chromium.org>
Subject: [PATCH 6.0 1045/1073] security: Restrict CONFIG_ZERO_CALL_USED_REGS to gcc or clang > 15.0.6
Date:   Wed, 28 Dec 2022 15:43:53 +0100
Message-Id: <20221228144356.584366121@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
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

From: Nathan Chancellor <nathan@kernel.org>

commit d6a9fb87e9d18f3394a9845546bbe868efdccfd2 upstream.

A bad bug in clang's implementation of -fzero-call-used-regs can result
in NULL pointer dereferences (see the links above the check for more
information). Restrict CONFIG_CC_HAS_ZERO_CALL_USED_REGS to either a
supported GCC version or a clang newer than 15.0.6, which will catch
both a theoretical 15.0.7 and the upcoming 16.0.0, which will both have
the bug fixed.

Cc: stable@vger.kernel.org # v5.15+
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Kees Cook <keescook@chromium.org>
Link: https://lore.kernel.org/r/20221214232602.4118147-1-nathan@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 security/Kconfig.hardening |    3 +++
 1 file changed, 3 insertions(+)

--- a/security/Kconfig.hardening
+++ b/security/Kconfig.hardening
@@ -253,6 +253,9 @@ config INIT_ON_FREE_DEFAULT_ON
 
 config CC_HAS_ZERO_CALL_USED_REGS
 	def_bool $(cc-option,-fzero-call-used-regs=used-gpr)
+	# https://github.com/ClangBuiltLinux/linux/issues/1766
+	# https://github.com/llvm/llvm-project/issues/59242
+	depends on !CC_IS_CLANG || CLANG_VERSION > 150006
 
 config ZERO_CALL_USED_REGS
 	bool "Enable register zeroing on function exit"


