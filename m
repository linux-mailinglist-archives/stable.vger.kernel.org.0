Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AD7C22EF84
	for <lists+stable@lfdr.de>; Mon, 27 Jul 2020 16:17:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730376AbgG0ORC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jul 2020 10:17:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:44202 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730987AbgG0ORC (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Jul 2020 10:17:02 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 776602177B;
        Mon, 27 Jul 2020 14:17:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595859422;
        bh=kB41gXh/gK69Ub+thQTzV8vVMeVaJNEl8ZZLFyl95ZQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N1dJV1cJw8MRG0U+1IaNdHybmeYpXJSrop5ojdXEKdsvlquQRV2OMJYIR1cNHRXNV
         d/Pp42VSd5/Pu5yn5jmRW+bzxnrHG5sYjmC8i0L9nTUQ4WSiN7Qcc46cjcVxyXjQ1d
         ToZj/B4Z7oJ6uobwnx7Ci6TdbcdEzG1t5WZB3b4U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 100/138] x86: math-emu: Fix up cmp insn for clang ias
Date:   Mon, 27 Jul 2020 16:04:55 +0200
Message-Id: <20200727134930.369651374@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200727134925.228313570@linuxfoundation.org>
References: <20200727134925.228313570@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 81e96851ea32deb2c921c870eecabf335f598aeb ]

The clang integrated assembler requires the 'cmp' instruction to
have a length prefix here:

arch/x86/math-emu/wm_sqrt.S:212:2: error: ambiguous instructions require an explicit suffix (could be 'cmpb', 'cmpw', or 'cmpl')
 cmp $0xffffffff,-24(%ebp)
 ^

Make this a 32-bit comparison, which it was clearly meant to be.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Link: https://lkml.kernel.org/r/20200527135352.1198078-1-arnd@arndb.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/math-emu/wm_sqrt.S | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/math-emu/wm_sqrt.S b/arch/x86/math-emu/wm_sqrt.S
index f031c0e193565..515cdee90df72 100644
--- a/arch/x86/math-emu/wm_sqrt.S
+++ b/arch/x86/math-emu/wm_sqrt.S
@@ -209,7 +209,7 @@ sqrt_stage_2_finish:
 
 #ifdef PARANOID
 /* It should be possible to get here only if the arg is ffff....ffff */
-	cmp	$0xffffffff,FPU_fsqrt_arg_1
+	cmpl	$0xffffffff,FPU_fsqrt_arg_1
 	jnz	sqrt_stage_2_error
 #endif /* PARANOID */
 
-- 
2.25.1



