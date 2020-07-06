Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A171215614
	for <lists+stable@lfdr.de>; Mon,  6 Jul 2020 13:05:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728881AbgGFLFg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Jul 2020 07:05:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:57736 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728852AbgGFLFg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 6 Jul 2020 07:05:36 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 585DA2074F;
        Mon,  6 Jul 2020 11:05:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594033535;
        bh=ne2J8vyCp/Y6iHEupXhOGaq1tyGoUY8NAoyklBzAMhM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gPPxbLScSuxO7A2wjgyIbzKcQNeXJSz7yTshFMQ9vlr6Z6nZzYOYKk+BJg9PfjFGm
         eOnJqfq5bxQjvKclByrRhsPRDJ2UvQE9+AuWGEYUTVE07SJJrf57N57oSDAl9ObR4/
         1DSaK4Nes8BjHR4r6ocF1k4OZp62TXVD7JNMevso=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1jsOwH-009Qgb-Pg; Mon, 06 Jul 2020 12:05:34 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Andrew Scull <ascull@google.com>,
        Andrew Murray <amurray@thegoodpenguin.co.uk>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org, stable@vger.kernel.org
Subject: [PATCH 2/2] KVM: arm64: Stop clobbering x0 for HVC_SOFT_RESTART
Date:   Mon,  6 Jul 2020 12:05:21 +0100
Message-Id: <20200706110521.1615794-3-maz@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200706110521.1615794-1-maz@kernel.org>
References: <20200706110521.1615794-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, ascull@google.com, amurray@thegoodpenguin.co.uk, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, stable@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrew Scull <ascull@google.com>

HVC_SOFT_RESTART is given values for x0-2 that it should installed
before exiting to the new address so should not set x0 to stub HVC
success or failure code.

Fixes: af42f20480bf1 ("arm64: hyp-stub: Zero x0 on successful stub handling")
Cc: stable@vger.kernel.org
Signed-off-by: Andrew Scull <ascull@google.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20200706095259.1338221-1-ascull@google.com
---
 arch/arm64/kvm/hyp-init.S | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/hyp-init.S b/arch/arm64/kvm/hyp-init.S
index 6e6ed5581eed..e76c0e89d48e 100644
--- a/arch/arm64/kvm/hyp-init.S
+++ b/arch/arm64/kvm/hyp-init.S
@@ -136,11 +136,15 @@ SYM_CODE_START(__kvm_handle_stub_hvc)
 
 1:	cmp	x0, #HVC_RESET_VECTORS
 	b.ne	1f
-reset:
+
 	/*
-	 * Reset kvm back to the hyp stub. Do not clobber x0-x4 in
-	 * case we coming via HVC_SOFT_RESTART.
+	 * Set the HVC_RESET_VECTORS return code before entering the common
+	 * path so that we do not clobber x0-x2 in case we are coming via
+	 * HVC_SOFT_RESTART.
 	 */
+	mov	x0, xzr
+reset:
+	/* Reset kvm back to the hyp stub. */
 	mrs	x5, sctlr_el2
 	mov_q	x6, SCTLR_ELx_FLAGS
 	bic	x5, x5, x6		// Clear SCTL_M and etc
@@ -151,7 +155,6 @@ reset:
 	/* Install stub vectors */
 	adr_l	x5, __hyp_stub_vectors
 	msr	vbar_el2, x5
-	mov	x0, xzr
 	eret
 
 1:	/* Bad stub call */
-- 
2.27.0

