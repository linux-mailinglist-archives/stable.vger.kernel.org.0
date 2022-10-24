Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B046A60AD6C
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 16:23:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236881AbiJXOXc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 10:23:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235759AbiJXOV7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 10:21:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5117080519;
        Mon, 24 Oct 2022 05:58:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 386EB61015;
        Mon, 24 Oct 2022 12:56:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 220C3C433D6;
        Mon, 24 Oct 2022 12:56:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666616164;
        bh=sUyZyrMqUPyGGk4Pxe7Uud2xJwua8SWCHH2vysEuE+E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fAPLpfU5Vu5/U/LvP8s4zbpyD/XXfCL8qPH+IEzcAxHQAwkRvSpBj5f0Znxc9ueLZ
         kr1zI36chkkM76Y+NyHg6iUmR9uy8dv2HAda20GQA8PNO5Ej5sWjDnerPAziakytZ6
         mWXO5oLL4Cs2+piZH1cGczg+W/HnATaAYnvYQ0f8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Masahiro Yamada <masahiroy@kernel.org>,
        Nathan Chancellor <nathan@kernel.org>
Subject: [PATCH 5.15 524/530] Kconfig.debug: simplify the dependency of DEBUG_INFO_DWARF4/5
Date:   Mon, 24 Oct 2022 13:34:28 +0200
Message-Id: <20221024113108.713732127@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113044.976326639@linuxfoundation.org>
References: <20221024113044.976326639@linuxfoundation.org>
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

From: Masahiro Yamada <masahiroy@kernel.org>

commit 4f001a21080ff2e2f0e1c3692f5e119aedbb3bc1 upstream.

Commit c0a5c81ca9be ("Kconfig.debug: drop GCC 5+ version check for
DWARF5") could have cleaned up the code a bit more.

"CC_IS_CLANG &&" is unneeded. No functional change is intended.

Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Reviewed-by: Nathan Chancellor <nathan@kernel.org>
[nathan: Only apply to DWARF5, as 5.15 does not have 32ef9e5054ec032]
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 lib/Kconfig.debug |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -295,7 +295,7 @@ config DEBUG_INFO_DWARF4
 
 config DEBUG_INFO_DWARF5
 	bool "Generate DWARF Version 5 debuginfo"
-	depends on !CC_IS_CLANG || (CC_IS_CLANG && (AS_IS_LLVM || (AS_IS_GNU && AS_VERSION >= 23502)))
+	depends on !CC_IS_CLANG || AS_IS_LLVM || (AS_IS_GNU && AS_VERSION >= 23502)
 	depends on !DEBUG_INFO_BTF
 	help
 	  Generate DWARF v5 debug info. Requires binutils 2.35.2, gcc 5.0+ (gcc


