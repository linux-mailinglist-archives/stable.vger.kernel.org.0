Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A74316A096F
	for <lists+stable@lfdr.de>; Thu, 23 Feb 2023 14:05:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234309AbjBWNFz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Feb 2023 08:05:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234296AbjBWNFw (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Feb 2023 08:05:52 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D6275455D
        for <stable@vger.kernel.org>; Thu, 23 Feb 2023 05:05:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E53C8B81A16
        for <stable@vger.kernel.org>; Thu, 23 Feb 2023 13:05:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4070FC433EF;
        Thu, 23 Feb 2023 13:05:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1677157548;
        bh=aNuDsi64DQXSou422APszZ8LlYS5mmSYl2i1XbUlqUY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AEgzIfNcbd7/zyg+DSyWGEgINZnQIu826l1zZ1uADYTAhU1pi/iYZgHD7ZVybnR2T
         /d7YEj3CiI8uOXS6MVzqDlnHyDbX/V0M40u8QF258xxaaI5LvvqtopU0HTuguHzD4m
         zkzoFOhnQ7WrCg/RaXsTeP206cSOMMpvQ5RD/3h0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Eric Biggers <ebiggers@google.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Bill Wendling <morbo@google.com>,
        Kees Cook <keescook@chromium.org>
Subject: [PATCH 6.2 11/11] randstruct: disable Clang 15 support
Date:   Thu, 23 Feb 2023 14:05:05 +0100
Message-Id: <20230223130426.626952082@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230223130426.170746546@linuxfoundation.org>
References: <20230223130426.170746546@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

commit 78f7a3fd6dc66cb788c21d7705977ed13c879351 upstream.

The randstruct support released in Clang 15 is unsafe to use due to a
bug that can cause miscompilations: "-frandomize-layout-seed
inconsistently randomizes all-function-pointers structs"
(https://github.com/llvm/llvm-project/issues/60349).  It has been fixed
on the Clang 16 release branch, so add a Clang version check.

Fixes: 035f7f87b729 ("randstruct: Enable Clang support")
Cc: stable@vger.kernel.org
Signed-off-by: Eric Biggers <ebiggers@google.com>
Acked-by: Nick Desaulniers <ndesaulniers@google.com>
Reviewed-by: Nathan Chancellor <nathan@kernel.org>
Reviewed-by: Bill Wendling <morbo@google.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
Link: https://lore.kernel.org/r/20230208065133.220589-1-ebiggers@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 security/Kconfig.hardening |    3 +++
 1 file changed, 3 insertions(+)

--- a/security/Kconfig.hardening
+++ b/security/Kconfig.hardening
@@ -281,6 +281,9 @@ endmenu
 
 config CC_HAS_RANDSTRUCT
 	def_bool $(cc-option,-frandomize-layout-seed-file=/dev/null)
+	# Randstruct was first added in Clang 15, but it isn't safe to use until
+	# Clang 16 due to https://github.com/llvm/llvm-project/issues/60349
+	depends on !CC_IS_CLANG || CLANG_VERSION >= 160000
 
 choice
 	prompt "Randomize layout of sensitive kernel structures"


