Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8824E23A5C0
	for <lists+stable@lfdr.de>; Mon,  3 Aug 2020 14:42:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727088AbgHCMcd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Aug 2020 08:32:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:60472 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729319AbgHCMca (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Aug 2020 08:32:30 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 442922054F;
        Mon,  3 Aug 2020 12:32:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596457949;
        bh=3jz3EdWVTWUgnoW/sHst9pS+pz7RHP5OQQhYlSCBmTU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rNFhhibi6XM6+mQ1iOj8Hdd8qqSD9ZOzDJyTqpUtOHTbet8k+kfezAu+gFf+YaIVK
         NGS+BHup5LCkGStRbSy9/OkmxcjwGnGrrd/fL7WW+0+9wYs8MoF8AG+REq2UCkRoAw
         DxO+cUrTPxDKE1EN7r39mxmXQOLwYoBesELIibnU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sami Tolvanen <samitolvanen@google.com>,
        Will Deacon <will@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 41/56] arm64/alternatives: move length validation inside the subsection
Date:   Mon,  3 Aug 2020 14:19:56 +0200
Message-Id: <20200803121852.321902247@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200803121850.306734207@linuxfoundation.org>
References: <20200803121850.306734207@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sami Tolvanen <samitolvanen@google.com>

[ Upstream commit 966a0acce2fca776391823381dba95c40e03c339 ]

Commit f7b93d42945c ("arm64/alternatives: use subsections for replacement
sequences") breaks LLVM's integrated assembler, because due to its
one-pass design, it cannot compute instruction sequence lengths before the
layout for the subsection has been finalized. This change fixes the build
by moving the .org directives inside the subsection, so they are processed
after the subsection layout is known.

Fixes: f7b93d42945c ("arm64/alternatives: use subsections for replacement sequences")
Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
Link: https://github.com/ClangBuiltLinux/linux/issues/1078
Link: https://lore.kernel.org/r/20200730153701.3892953-1-samitolvanen@google.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/include/asm/alternative.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/alternative.h b/arch/arm64/include/asm/alternative.h
index 849d891c60a81..844f05b23115a 100644
--- a/arch/arm64/include/asm/alternative.h
+++ b/arch/arm64/include/asm/alternative.h
@@ -77,9 +77,9 @@ static inline void apply_alternatives_module(void *start, size_t length) { }
 	"663:\n\t"							\
 	newinstr "\n"							\
 	"664:\n\t"							\
-	".previous\n\t"							\
 	".org	. - (664b-663b) + (662b-661b)\n\t"			\
-	".org	. - (662b-661b) + (664b-663b)\n"			\
+	".org	. - (662b-661b) + (664b-663b)\n\t"			\
+	".previous\n"							\
 	".endif\n"
 
 #define __ALTERNATIVE_CFG_CB(oldinstr, feature, cfg_enabled, cb)	\
-- 
2.25.1



