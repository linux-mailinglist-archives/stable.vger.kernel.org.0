Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E6ED073E8F
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 22:25:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389451AbfGXTjP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 15:39:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:40188 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389419AbfGXTjO (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Jul 2019 15:39:14 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DE7B322ADA;
        Wed, 24 Jul 2019 19:39:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563997153;
        bh=FQ1efTMIR9YJ2eou7CCmelxBInYOQMC+ETv6l+wCXSs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o4uXz3LORYVcYZySF0NtXt2JAzqVZie656zmz8dAqmkq97OVhqPKYa7mzmFPrjUSH
         CrG3KBbisXCq33dNSPlMdYhfILeZVmFEbL5IpegtaFMo/uh33D/6InrvxbE7mJ1gD6
         +Vl7KK1i29NDlAchs9ajPtN6shoD5m7gW/bcUrBA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Julien Thierry <julien.thierry@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH 5.2 337/413] arm64: irqflags: Add condition flags to inline asm clobber list
Date:   Wed, 24 Jul 2019 21:20:28 +0200
Message-Id: <20190724191759.928890805@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190724191735.096702571@linuxfoundation.org>
References: <20190724191735.096702571@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Julien Thierry <julien.thierry@arm.com>

commit f57065782f245ca96f1472209a485073bbc11247 upstream.

Some of the inline assembly instruction use the condition flags and need
to include "cc" in the clobber list.

Fixes: 4a503217ce37 ("arm64: irqflags: Use ICC_PMR_EL1 for interrupt masking")
Cc: <stable@vger.kernel.org> # 5.1.x-
Suggested-by: Marc Zyngier <marc.zyngier@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>
Acked-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Julien Thierry <julien.thierry@arm.com>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm64/include/asm/irqflags.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/arm64/include/asm/irqflags.h
+++ b/arch/arm64/include/asm/irqflags.h
@@ -81,7 +81,7 @@ static inline unsigned long arch_local_s
 			ARM64_HAS_IRQ_PRIO_MASKING)
 		: "=&r" (flags), "+r" (daif_bits)
 		: "r" ((unsigned long) GIC_PRIO_IRQOFF)
-		: "memory");
+		: "cc", "memory");
 
 	return flags;
 }
@@ -125,7 +125,7 @@ static inline int arch_irqs_disabled_fla
 			ARM64_HAS_IRQ_PRIO_MASKING)
 		: "=&r" (res)
 		: "r" ((int) flags)
-		: "memory");
+		: "cc", "memory");
 
 	return res;
 }


