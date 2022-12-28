Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE1196584EA
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 18:03:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234440AbiL1RDz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 12:03:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235270AbiL1RDc (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 12:03:32 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFCF11DDDF
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:57:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 79106B8171E
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:57:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C49EEC433D2;
        Wed, 28 Dec 2022 16:57:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672246663;
        bh=ykql0l1NolxZGhQz+NQUitFMFHuFP7ycSFzjIlFWXcs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J/rAdAeD9c/Qo+DuvKhobLkcxkIpJz1fNWOng6WZJq0u/Yfb2FtMCD0RI8tNtm+ye
         BosKoArX5okL8HR3tlP5PI3bcEvwD2OYWLEoCMEiwvhStaOq/gbKGkS0cgzgnmgGQF
         UIuibEZndZjxxt64uFmPaUGDFkdfRAgzAlaK68Fw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Nathan Chancellor <nathan@kernel.org>,
        Kees Cook <keescook@chromium.org>
Subject: [PATCH 6.1 1117/1146] security: Restrict CONFIG_ZERO_CALL_USED_REGS to gcc or clang > 15.0.6
Date:   Wed, 28 Dec 2022 15:44:16 +0100
Message-Id: <20221228144400.489916162@linuxfoundation.org>
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
@@ -257,6 +257,9 @@ config INIT_ON_FREE_DEFAULT_ON
 
 config CC_HAS_ZERO_CALL_USED_REGS
 	def_bool $(cc-option,-fzero-call-used-regs=used-gpr)
+	# https://github.com/ClangBuiltLinux/linux/issues/1766
+	# https://github.com/llvm/llvm-project/issues/59242
+	depends on !CC_IS_CLANG || CLANG_VERSION > 150006
 
 config ZERO_CALL_USED_REGS
 	bool "Enable register zeroing on function exit"


