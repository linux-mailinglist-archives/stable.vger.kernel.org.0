Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08FB24D9CB7
	for <lists+stable@lfdr.de>; Tue, 15 Mar 2022 14:57:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245621AbiCON6k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Mar 2022 09:58:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347052AbiCON6j (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Mar 2022 09:58:39 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3913553E0F;
        Tue, 15 Mar 2022 06:57:27 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 041FA1474;
        Tue, 15 Mar 2022 06:57:27 -0700 (PDT)
Received: from eglon.cambridge.arm.com (eglon.cambridge.arm.com [10.1.196.218])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 2236E3F66F;
        Tue, 15 Mar 2022 06:57:26 -0700 (PDT)
From:   James Morse <james.morse@arm.com>
To:     stable@vger.kernel.org
Cc:     gregkh@linuxfoundation.org, pavel@denx.de, catalin.marinas@arm.com,
        linux-kernel@vger.kernel.org, james.morse@arm.com
Subject: [stable:PATCH v5.10.105] arm64: kvm: Fix copy-and-paste error in bhb templates for v5.10 stable
Date:   Tue, 15 Mar 2022 13:57:20 +0000
Message-Id: <20220315135720.1302143-1-james.morse@arm.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

KVM's infrastructure for spectre mitigations in the vectors in v5.10 and
earlier is different, it uses templates which are used to build a set of
vectors at runtime.

There are two copy-and-paste errors in the templates: __spectre_bhb_loop_k24
should loop 24 times and __spectre_bhb_loop_k32 32.

Fix these.

Reported-by: Pavel Machek <pavel@denx.de>
Link: https://lore.kernel.org/all/20220310234858.GB16308@amd/
Signed-off-by: James Morse <james.morse@arm.com>
---
 arch/arm64/kvm/hyp/smccc_wa.S | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/hyp/smccc_wa.S b/arch/arm64/kvm/hyp/smccc_wa.S
index 24b281912463..533b0aa73256 100644
--- a/arch/arm64/kvm/hyp/smccc_wa.S
+++ b/arch/arm64/kvm/hyp/smccc_wa.S
@@ -68,7 +68,7 @@ SYM_DATA_START(__spectre_bhb_loop_k24)
 	esb
 	sub	sp, sp, #(8 * 2)
 	stp	x0, x1, [sp, #(8 * 0)]
-	mov	x0, #8
+	mov	x0, #24
 2:	b	. + 4
 	subs	x0, x0, #1
 	b.ne	2b
@@ -85,7 +85,7 @@ SYM_DATA_START(__spectre_bhb_loop_k32)
 	esb
 	sub	sp, sp, #(8 * 2)
 	stp	x0, x1, [sp, #(8 * 0)]
-	mov	x0, #8
+	mov	x0, #32
 2:	b	. + 4
 	subs	x0, x0, #1
 	b.ne	2b
-- 
2.30.2

