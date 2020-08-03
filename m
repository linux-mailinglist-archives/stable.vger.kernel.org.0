Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A14223A56F
	for <lists+stable@lfdr.de>; Mon,  3 Aug 2020 14:37:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729240AbgHCMfF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Aug 2020 08:35:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:35380 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729233AbgHCMfE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Aug 2020 08:35:04 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EE3C32076B;
        Mon,  3 Aug 2020 12:35:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596458103;
        bh=ciS47U5g58lQh8uM1yhReoh4Xilmw9i+QaZmMFcwVEc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kRkmwt1nQHc+g/NqXfGCHdVT0LeMwMegiyctu7T8ePucyfxApSDRXYgxJZfYMQHuq
         Psh6tY7HVQVvS82qOPd7DG5ApyG9tp97wJZcJTCH/kQrRHDBUsqtv0C2Y+sw11lo2J
         TyEZ+aRnArF1iHDmAX5qVnu9oJGo5deVEqR5U8BQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sami Tolvanen <samitolvanen@google.com>,
        Will Deacon <will@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 39/51] arm64/alternatives: move length validation inside the subsection
Date:   Mon,  3 Aug 2020 14:20:24 +0200
Message-Id: <20200803121851.455895323@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200803121849.488233135@linuxfoundation.org>
References: <20200803121849.488233135@linuxfoundation.org>
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
index 1824768fb1ee9..3abb2dacb43f4 100644
--- a/arch/arm64/include/asm/alternative.h
+++ b/arch/arm64/include/asm/alternative.h
@@ -72,9 +72,9 @@ void apply_alternatives(void *start, size_t length);
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



