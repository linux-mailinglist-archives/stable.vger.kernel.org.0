Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0071645265
	for <lists+stable@lfdr.de>; Fri, 14 Jun 2019 05:12:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725972AbfFNDMN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jun 2019 23:12:13 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:44892 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725819AbfFNDMN (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Jun 2019 23:12:13 -0400
Received: by mail-pl1-f193.google.com with SMTP id t7so365351plr.11
        for <stable@vger.kernel.org>; Thu, 13 Jun 2019 20:12:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=1IdhsUs/fdllTh2EJ+ScRqWrO1uX9GsPUvP6PugnTR0=;
        b=CeEm6Q1HCBNewplA3EEpKwApVIKTpTNllAdvcpIQe77l+53e3CBoti53KWIeaNe0AV
         uR33V/xqt5i78jkGXLw5r7hKp87D8o3XXeTj2CX3c6eW5pbdE4O8M/DEhUuVcvJLyCue
         J/HxOYccIDOdOn0PgfLpjg1ooi2feDWeCRsPH41MC/6U3E11V3hs/g6YcluMAoJclkf0
         RYrOLVM24b3kdzMeos5tsXRAFN9RPr1E5Ixv5qsOkkQyxTPZ6qhPRWOb4NWe8ELnZbqq
         Cz7MO6TMue7XovkrPAocu+1P2xG1vLWIb0lKRAT9tTf8MVYN0fsM1/hYKglqWz5WgZbA
         fArQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1IdhsUs/fdllTh2EJ+ScRqWrO1uX9GsPUvP6PugnTR0=;
        b=Ke5+qV1bwiABdoybUq98LRMZLo5pahd8OFYmVXETUnEQu3ItLvy2IOOPBDijdGmC/K
         JJN9461ZohaOpGQL3YdA18Jr4+kcINZqUJ0MSjYkSiH4qSTH8S38LI5GKXbWwfcDjXpU
         VCySwFatxeh5krODcSdoUBI8+F3CsYZIi7q4HHvUr28IPrfyv/DC7WsplfW0B9FtfBo5
         cn3/vtef3eYjzns3HwDtCqOG5gtxiVaA/vGEJNkCxGWcjhYFAlSvLmZsTubraWIGAfB0
         b9D7PMjiIx3rPbvPjyAg0MguptqCNnDJRSCPnY4BXLUyNMQpm4r29alieomUOO+xwUM7
         a8dg==
X-Gm-Message-State: APjAAAV24BispjBf8m9x4gMa/F937OMfg7sWx+BdmTBU9XBgllxFF6Ws
        WQIwnNYdO2tlWfdjkf4cekzaCA==
X-Google-Smtp-Source: APXvYqxZaE1F8d9DJY74Bh26I9mrpSGzX/LNmvHBq/ilBx736pFGlQUSrt6qWsqrIVuHCyJRaPUq7w==
X-Received: by 2002:a17:902:b94a:: with SMTP id h10mr91088007pls.265.1560481932763;
        Thu, 13 Jun 2019 20:12:12 -0700 (PDT)
Received: from localhost ([122.172.66.84])
        by smtp.gmail.com with ESMTPSA id e184sm1047863pfa.169.2019.06.13.20.12.11
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 13 Jun 2019 20:12:12 -0700 (PDT)
From:   Viresh Kumar <viresh.kumar@linaro.org>
To:     linux-arm-kernel@lists.infradead.org,
        Julien Thierry <Julien.Thierry@arm.com>
Cc:     Viresh Kumar <viresh.kumar@linaro.org>, stable@vger.kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        mark.brown@arm.com
Subject: [PATCH v4.4 07/45] arm64: entry: Ensure branch through syscall table is bounded under speculation
Date:   Fri, 14 Jun 2019 08:37:50 +0530
Message-Id: <ee036f503b414d84b1491e2fb0c6ffbd4e770d18.1560480942.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 2.21.0.rc0.269.g1a574e7a288b
In-Reply-To: <cover.1560480942.git.viresh.kumar@linaro.org>
References: <cover.1560480942.git.viresh.kumar@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Will Deacon <will.deacon@arm.com>

commit 6314d90e64936c584f300a52ef173603fb2461b5 upstream.

In a similar manner to array_index_mask_nospec, this patch introduces an
assembly macro (mask_nospec64) which can be used to bound a value under
speculation. This macro is then used to ensure that the indirect branch
through the syscall table is bounded under speculation, with out-of-range
addresses speculating as calls to sys_io_setup (0).

Reviewed-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
[ v4.4: use existing scno & sc_nr definitions ]
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 arch/arm64/include/asm/assembler.h | 11 +++++++++++
 arch/arm64/kernel/entry.S          |  1 +
 2 files changed, 12 insertions(+)

diff --git a/arch/arm64/include/asm/assembler.h b/arch/arm64/include/asm/assembler.h
index 683c2875278f..2b30363a3a89 100644
--- a/arch/arm64/include/asm/assembler.h
+++ b/arch/arm64/include/asm/assembler.h
@@ -102,6 +102,17 @@
 	hint	#20
 	.endm
 
+/*
+ * Sanitise a 64-bit bounded index wrt speculation, returning zero if out
+ * of bounds.
+ */
+	.macro	mask_nospec64, idx, limit, tmp
+	sub	\tmp, \idx, \limit
+	bic	\tmp, \tmp, \idx
+	and	\idx, \idx, \tmp, asr #63
+	csdb
+	.endm
+
 #define USER(l, x...)				\
 9999:	x;					\
 	.section __ex_table,"a";		\
diff --git a/arch/arm64/kernel/entry.S b/arch/arm64/kernel/entry.S
index 4c5013b09dcb..e6aec982dea9 100644
--- a/arch/arm64/kernel/entry.S
+++ b/arch/arm64/kernel/entry.S
@@ -697,6 +697,7 @@ el0_svc_naked:					// compat entry point
 	b.ne	__sys_trace
 	cmp     scno, sc_nr                     // check upper syscall limit
 	b.hs	ni_sys
+	mask_nospec64 scno, sc_nr, x19	// enforce bounds for syscall number
 	ldr	x16, [stbl, scno, lsl #3]	// address in the syscall table
 	blr	x16				// call sys_* routine
 	b	ret_fast_syscall
-- 
2.21.0.rc0.269.g1a574e7a288b

