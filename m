Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D44AF333DB1
	for <lists+stable@lfdr.de>; Wed, 10 Mar 2021 14:25:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232953AbhCJNYn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Mar 2021 08:24:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:45474 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232785AbhCJNYQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 10 Mar 2021 08:24:16 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 12CF164FD7;
        Wed, 10 Mar 2021 13:24:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615382656;
        bh=Nu4xHyai9ZLyH0xUkBWWw5RYeR+BlpaAgC1kr36Je0Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iOr7cSWg9oNs9TMD/5QAdr5Grm2axeNbLYMkONSTw7l+WCP1bbNX1iORMrF+KjZ2l
         9kxj5vBI3LsFWI3NNLCCnWvY6Fb437PfN+JM2AWqI4Z+002CaEy354JbMZVTZumRR+
         0J68hnRXpw75fLqBtlfgZurHlNu/4gqaVyjfFP3A=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Will Deacon <will@kernel.org>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Subject: [PATCH 5.10 05/49] arm64: Make CPU_BIG_ENDIAN depend on ld.bfd or ld.lld 13.0.0+
Date:   Wed, 10 Mar 2021 14:23:16 +0100
Message-Id: <20210310132322.127281108@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210310132321.948258062@linuxfoundation.org>
References: <20210310132321.948258062@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Nathan Chancellor <nathan@kernel.org>

commit e9c6deee00e9197e75cd6aa0d265d3d45bd7cc28 upstream

Similar to commit 28187dc8ebd9 ("ARM: 9025/1: Kconfig: CPU_BIG_ENDIAN
depends on !LD_IS_LLD"), ld.lld prior to 13.0.0 does not properly
support aarch64 big endian, leading to the following build error when
CONFIG_CPU_BIG_ENDIAN is selected:

ld.lld: error: unknown emulation: aarch64linuxb

This has been resolved in LLVM 13. To avoid errors like this, only allow
CONFIG_CPU_BIG_ENDIAN to be selected if using ld.bfd or ld.lld 13.0.0
and newer.

While we are here, the indentation of this symbol used spaces since its
introduction in commit a872013d6d03 ("arm64: kconfig: allow
CPU_BIG_ENDIAN to be selected"). Change it to tabs to be consistent with
kernel coding style.

Link: https://github.com/ClangBuiltLinux/linux/issues/380
Link: https://github.com/ClangBuiltLinux/linux/issues/1288
Link: https://github.com/llvm/llvm-project/commit/7605a9a009b5fa3bdac07e3131c8d82f6d08feb7
Link: https://github.com/llvm/llvm-project/commit/eea34aae2e74e9b6fbdd5b95f479bc7f397bf387
Reported-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Link: https://lore.kernel.org/r/20210209005719.803608-1-nathan@kernel.org
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/Kconfig |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -950,8 +950,9 @@ choice
 	  that is selected here.
 
 config CPU_BIG_ENDIAN
-       bool "Build big-endian kernel"
-       help
+	bool "Build big-endian kernel"
+	depends on !LD_IS_LLD || LLD_VERSION >= 130000
+	help
 	  Say Y if you plan on running a kernel with a big-endian userspace.
 
 config CPU_LITTLE_ENDIAN


