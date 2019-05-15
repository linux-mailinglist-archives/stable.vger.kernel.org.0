Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9240C1EF33
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 13:31:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732335AbfEOLbK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 07:31:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:42832 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732853AbfEOLbI (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 07:31:08 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ADC9B20818;
        Wed, 15 May 2019 11:31:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557919868;
        bh=HPW5qmyRt0MdAlds3D8UJxzus/kCZ4tCYnDPQSWmvT0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pxOo5PDkOIZwuRvt2KQf2RRKwy6gcW3GL+Mm2mRu2jcVuallK7aat1nEQVHZBsOds
         nSvvBb+84MujqwYbehSCHytW9mZLQNfIJaMcspTkSRhIfamxyOzNT134xrMwvwLAjs
         ZEty/yZQGpMMC+0BUHCkSZgnv0A/9Do/BH/EVwJ8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Will Deacon <will.deacon@arm.com>,
        dann frazier <dann.frazier@canonical.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.0 080/137] arm64/module: ftrace: deal with place relative nature of PLTs
Date:   Wed, 15 May 2019 12:56:01 +0200
Message-Id: <20190515090659.277259384@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190515090651.633556783@linuxfoundation.org>
References: <20190515090651.633556783@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 4e69ecf4da1ee0b2ac735e1f1bb13935acd5a38d ]

Another bodge for the ftrace PLT code: plt_entries_equal() now takes
the place relative nature of the ADRP/ADD based PLT entries into
account, which means that a struct trampoline instance on the stack
is no longer equal to the same set of opcodes in the module struct,
given that they don't point to the same place in memory anymore.

Work around this by using memcmp() in the ftrace PLT handling code.

Acked-by: Will Deacon <will.deacon@arm.com>
Tested-by: dann frazier <dann.frazier@canonical.com>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kernel/ftrace.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kernel/ftrace.c b/arch/arm64/kernel/ftrace.c
index 07b2981201820..65a51331088eb 100644
--- a/arch/arm64/kernel/ftrace.c
+++ b/arch/arm64/kernel/ftrace.c
@@ -103,10 +103,15 @@ int ftrace_make_call(struct dyn_ftrace *rec, unsigned long addr)
 		 * to be revisited if support for multiple ftrace entry points
 		 * is added in the future, but for now, the pr_err() below
 		 * deals with a theoretical issue only.
+		 *
+		 * Note that PLTs are place relative, and plt_entries_equal()
+		 * checks whether they point to the same target. Here, we need
+		 * to check if the actual opcodes are in fact identical,
+		 * regardless of the offset in memory so use memcmp() instead.
 		 */
 		trampoline = get_plt_entry(addr, mod->arch.ftrace_trampoline);
-		if (!plt_entries_equal(mod->arch.ftrace_trampoline,
-				       &trampoline)) {
+		if (memcmp(mod->arch.ftrace_trampoline, &trampoline,
+			   sizeof(trampoline))) {
 			if (plt_entry_is_initialized(mod->arch.ftrace_trampoline)) {
 				pr_err("ftrace: far branches to multiple entry points unsupported inside a single module\n");
 				return -EINVAL;
-- 
2.20.1



