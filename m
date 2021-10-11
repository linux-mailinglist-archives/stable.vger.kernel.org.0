Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 433BA428F95
	for <lists+stable@lfdr.de>; Mon, 11 Oct 2021 15:58:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236639AbhJKN7h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Oct 2021 09:59:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:50358 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238349AbhJKN6f (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Oct 2021 09:58:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0864D61139;
        Mon, 11 Oct 2021 13:55:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633960507;
        bh=ZbsChyw+fGygR5q1mikP+KqK1FYZRyUfjelgDtPnbNg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H9KsCTCLy1Yjm4++unIpfaRe+QVQMHf4WkFbP9rjaNU+d8F/QkPLb2g0wPL5py8n+
         p1c7Hg9bDDzsVGuKyfVjlA3uavzZZngsXnoeaUNk74gfZyREHDsKkhIS8+jkhugoZM
         q1HHuDuXgiu3W96QBfKdb74X8vejtqGZQd8AkSUs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>,
        Lukas Bulwahn <lukas.bulwahn@gmail.com>,
        Borislav Petkov <bp@suse.de>
Subject: [PATCH 5.10 80/83] x86/entry: Correct reference to intended CONFIG_64_BIT
Date:   Mon, 11 Oct 2021 15:46:40 +0200
Message-Id: <20211011134511.130340692@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211011134508.362906295@linuxfoundation.org>
References: <20211011134508.362906295@linuxfoundation.org>
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
@@ -24,7 +24,7 @@ static __always_inline void arch_check_u
 		 * For !SMAP hardware we patch out CLAC on entry.
 		 */
 		if (boot_cpu_has(X86_FEATURE_SMAP) ||
-		    (IS_ENABLED(CONFIG_64_BIT) && boot_cpu_has(X86_FEATURE_XENPV)))
+		    (IS_ENABLED(CONFIG_64BIT) && boot_cpu_has(X86_FEATURE_XENPV)))
 			mask |= X86_EFLAGS_AC;
 
 		WARN_ON_ONCE(flags & mask);


