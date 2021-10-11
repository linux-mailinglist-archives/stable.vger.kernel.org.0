Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65CD5429114
	for <lists+stable@lfdr.de>; Mon, 11 Oct 2021 16:13:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244401AbhJKOPd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Oct 2021 10:15:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:33824 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243893AbhJKON1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Oct 2021 10:13:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3A11F611ED;
        Mon, 11 Oct 2021 14:04:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633961061;
        bh=ggH7GQurVOeiMLFk9ni1YWA/jbFlF6TZe4TriG+O3EU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EnytXYeLAbgpoDY0woQssaWYzilnFdTUbvS8/pMMcpFRDAHieDawqQu7I76rJJUEO
         EZwL6db0x983CtIsg/4AX4npJ/bo8TAfduGiwPNtcNdxR22hgFiYbpcY/nLxzy2Bkq
         6j4iPOoXi1FTdJcwkt4Th9GMmnwEcSlxOSSeRpx4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>,
        Lukas Bulwahn <lukas.bulwahn@gmail.com>,
        Borislav Petkov <bp@suse.de>
Subject: [PATCH 5.14 148/151] x86/entry: Correct reference to intended CONFIG_64_BIT
Date:   Mon, 11 Oct 2021 15:47:00 +0200
Message-Id: <20211011134522.612820816@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211011134517.833565002@linuxfoundation.org>
References: <20211011134517.833565002@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lukas Bulwahn <lukas.bulwahn@gmail.com>

commit 2c861f2b859385e9eaa6e464a8a7435b5a6bf564 upstream.

Commit in Fixes adds a condition with IS_ENABLED(CONFIG_64_BIT),
but the intended config item is called CONFIG_64BIT, as defined in
arch/x86/Kconfig.

Fortunately, scripts/checkkconfigsymbols.py warns:

64_BIT
Referencing files: arch/x86/include/asm/entry-common.h

Correct the reference to the intended config symbol.

Fixes: 662a0221893a ("x86/entry: Fix AC assertion")
Suggested-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Cc: <stable@vger.kernel.org>
Link: https://lkml.kernel.org/r/20210803113531.30720-2-lukas.bulwahn@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/entry-common.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/include/asm/entry-common.h
+++ b/arch/x86/include/asm/entry-common.h
@@ -25,7 +25,7 @@ static __always_inline void arch_check_u
 		 * For !SMAP hardware we patch out CLAC on entry.
 		 */
 		if (boot_cpu_has(X86_FEATURE_SMAP) ||
-		    (IS_ENABLED(CONFIG_64_BIT) && boot_cpu_has(X86_FEATURE_XENPV)))
+		    (IS_ENABLED(CONFIG_64BIT) && boot_cpu_has(X86_FEATURE_XENPV)))
 			mask |= X86_EFLAGS_AC;
 
 		WARN_ON_ONCE(flags & mask);


