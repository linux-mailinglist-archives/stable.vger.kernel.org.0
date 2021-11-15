Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D3D5451E57
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 01:33:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345945AbhKPAfq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 19:35:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:45390 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344842AbhKOTZf (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:25:35 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5FFBB636D8;
        Mon, 15 Nov 2021 19:05:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637003120;
        bh=rvAB/a7Fhc0H9CHbmuPOqTCHY1Xq2fquzOHPuTu4yeo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mNkO1Jhjt/l+SHH3QBHvMN8rdHC5q0zZwZf7jWG8j9sVoJnV5HE03ALkHbIN8BINV
         4b7BSH7CDz3g1FQkKFH+jjuMWc74dbp9F5k/fcrA7ZeqQ+tY+VQ5Y5/qiguMtAWVKu
         6gaHpyt7n5mF+ye3QV1l2THzq8pzVZJrNu/QmeTw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Reiji Watanabe <reijiw@google.com>,
        Oliver Upton <oupton@google.com>,
        Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 819/917] arm64: arm64_ftr_reg->name may not be a human-readable string
Date:   Mon, 15 Nov 2021 18:05:14 +0100
Message-Id: <20211115165456.817887679@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Reiji Watanabe <reijiw@google.com>

[ Upstream commit 9dc232a8ab18bb20f1dcb03c8e049e3607f3ed15 ]

The id argument of ARM64_FTR_REG_OVERRIDE() is used for two purposes:
one as the system register encoding (used for the sys_id field of
__ftr_reg_entry), and the other as the register name (stringified
and used for the name field of arm64_ftr_reg), which is debug
information. The id argument is supposed to be a macro that
indicates an encoding of the register (eg. SYS_ID_AA64PFR0_EL1, etc).

ARM64_FTR_REG(), which also has the same id argument,
uses ARM64_FTR_REG_OVERRIDE() and passes the id to the macro.
Since the id argument is completely macro-expanded before it is
substituted into a macro body of ARM64_FTR_REG_OVERRIDE(),
the stringified id in the body of ARM64_FTR_REG_OVERRIDE is not
a human-readable register name, but a string of numeric bitwise
operations.

Fix this so that human-readable register names are available as
debug information.

Fixes: 8f266a5d878a ("arm64: cpufeature: Add global feature override facility")
Signed-off-by: Reiji Watanabe <reijiw@google.com>
Reviewed-by: Oliver Upton <oupton@google.com>
Acked-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20211101045421.2215822-1-reijiw@google.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kernel/cpufeature.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index 6ec7036ef7e18..7553c98f379fc 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -573,15 +573,19 @@ static const struct arm64_ftr_bits ftr_raz[] = {
 	ARM64_FTR_END,
 };
 
-#define ARM64_FTR_REG_OVERRIDE(id, table, ovr) {		\
+#define __ARM64_FTR_REG_OVERRIDE(id_str, id, table, ovr) {	\
 		.sys_id = id,					\
 		.reg = 	&(struct arm64_ftr_reg){		\
-			.name = #id,				\
+			.name = id_str,				\
 			.override = (ovr),			\
 			.ftr_bits = &((table)[0]),		\
 	}}
 
-#define ARM64_FTR_REG(id, table) ARM64_FTR_REG_OVERRIDE(id, table, &no_override)
+#define ARM64_FTR_REG_OVERRIDE(id, table, ovr)	\
+	__ARM64_FTR_REG_OVERRIDE(#id, id, table, ovr)
+
+#define ARM64_FTR_REG(id, table)		\
+	__ARM64_FTR_REG_OVERRIDE(#id, id, table, &no_override)
 
 struct arm64_ftr_override __ro_after_init id_aa64mmfr1_override;
 struct arm64_ftr_override __ro_after_init id_aa64pfr1_override;
-- 
2.33.0



