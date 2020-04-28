Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09EE21BCB34
	for <lists+stable@lfdr.de>; Tue, 28 Apr 2020 20:55:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729799AbgD1ScZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Apr 2020 14:32:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:48562 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728972AbgD1ScY (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Apr 2020 14:32:24 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3E91A20B80;
        Tue, 28 Apr 2020 18:32:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588098743;
        bh=M0xuTTD2h8wYlWdVpKOED62go8ts3J0hXhOYPDJmHsI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ee+148I5OHR5NAgvi8hb4U2AGrLrOkMGYbfQU/JHYz0N/LZrg3zdaXQLaBsEVh4qk
         uyFWRVxyG2d/abKY7mKFcikJTeZcHznvFfNVkIUmNPI5mxSpOviiYHzfZg4Tu+v8SA
         zYqJsZmIQ+/3on2ni9gerrMJrl5fbymOQikYRVJM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Nathan Chancellor <natechancellor@gmail.com>,
        James Morse <james.morse@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 007/168] arm64: Silence clang warning on mismatched value/register sizes
Date:   Tue, 28 Apr 2020 20:23:01 +0200
Message-Id: <20200428182232.589612520@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200428182231.704304409@linuxfoundation.org>
References: <20200428182231.704304409@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Catalin Marinas <catalin.marinas@arm.com>

[ Upstream commit: 27a22fbdeedd6c5c451cf5f830d51782bf50c3a2 ]

Clang reports a warning on the __tlbi(aside1is, 0) macro expansion since
the value size does not match the register size specified in the inline
asm. Construct the ASID value using the __TLBI_VADDR() macro.

Fixes: 222fc0c8503d ("arm64: compat: Workaround Neoverse-N1 #1542419 for compat user-space")
Reported-by: Nathan Chancellor <natechancellor@gmail.com>
Cc: James Morse <james.morse@arm.com>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: James Morse <james.morse@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kernel/sys_compat.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kernel/sys_compat.c b/arch/arm64/kernel/sys_compat.c
index c9fb02927d3e5..3c18c2454089b 100644
--- a/arch/arm64/kernel/sys_compat.c
+++ b/arch/arm64/kernel/sys_compat.c
@@ -37,7 +37,7 @@ __do_compat_cache_op(unsigned long start, unsigned long end)
 			 * The workaround requires an inner-shareable tlbi.
 			 * We pick the reserved-ASID to minimise the impact.
 			 */
-			__tlbi(aside1is, 0);
+			__tlbi(aside1is, __TLBI_VADDR(0, 0));
 			dsb(ish);
 		}
 
-- 
2.20.1



