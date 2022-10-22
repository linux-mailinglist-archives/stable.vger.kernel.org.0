Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61921608C6D
	for <lists+stable@lfdr.de>; Sat, 22 Oct 2022 13:16:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230308AbiJVLQy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Oct 2022 07:16:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231194AbiJVLQi (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Oct 2022 07:16:38 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5397C27FEAF;
        Sat, 22 Oct 2022 03:41:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9496CB82E1D;
        Sat, 22 Oct 2022 08:07:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECACBC433C1;
        Sat, 22 Oct 2022 08:07:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666426078;
        bh=nWENc6DvF0ptLyQFnc1HPQI6T98w4ylTIBF7MVi5LmY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1DU/QBD8c949Kk86HHVnPK4p3egAKHGnNxytTW+0XTskISS96Twq/CPEvgbQURtxK
         l+qPRfLto/R+3seIgtscz7RxyJsOXdQh2BmBmYg3+6k0xnTl5exX3halDRyi+iMQ//
         jokNGW+HipGnf/k1aKT8HmZBEaGOAD2zBrgRupKE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Masahiro Yamada <masahiroy@kernel.org>,
        Nathan Chancellor <nathan@kernel.org>
Subject: [PATCH 5.19 711/717] Kconfig.debug: add toolchain checks for DEBUG_INFO_DWARF_TOOLCHAIN_DEFAULT
Date:   Sat, 22 Oct 2022 09:29:50 +0200
Message-Id: <20221022072529.902430182@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221022072415.034382448@linuxfoundation.org>
References: <20221022072415.034382448@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masahiro Yamada <masahiroy@kernel.org>

commit bb1435f3f575b5213eaf27434efa3971f51c01de upstream.

CONFIG_DEBUG_INFO_DWARF_TOOLCHAIN_DEFAULT does not give explicit
-gdwarf-* flag. The actual DWARF version is up to the toolchain.

The combination of GCC and GAS works fine, and Clang with the integrated
assembler is good too.

The combination of Clang and GAS is tricky, but at least, the -g flag
works for Clang <=13, which defaults to DWARF v4.

Clang 14 switched its default to DWARF v5.

Now, CONFIG_DEBUG_INFO_DWARF_TOOLCHAIN_DEFAULT has the same issue as
addressed by commit 98cd6f521f10 ("Kconfig: allow explicit opt in to
DWARF v5").

CONFIG_DEBUG_INFO_DWARF_TOOLCHAIN_DEFAULT=y for Clang >= 14 and
GAS < 2.35 produces a ton of errors like follows:

  /tmp/main-c2741c.s: Assembler messages:
  /tmp/main-c2741c.s:109: Error: junk at end of line, first unrecognized character is `"'
  /tmp/main-c2741c.s:109: Error: file number less than one

Add 'depends on' to check toolchains.

Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Reviewed-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 lib/Kconfig.debug |    1 +
 1 file changed, 1 insertion(+)

--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -253,6 +253,7 @@ config DEBUG_INFO_NONE
 config DEBUG_INFO_DWARF_TOOLCHAIN_DEFAULT
 	bool "Rely on the toolchain's implicit default DWARF version"
 	select DEBUG_INFO
+	depends on !CC_IS_CLANG || AS_IS_LLVM || CLANG_VERSION < 140000 || (AS_IS_GNU && AS_VERSION >= 23502)
 	help
 	  The implicit default version of DWARF debug info produced by a
 	  toolchain changes over time.


