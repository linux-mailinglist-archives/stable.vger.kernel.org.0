Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C4F32E3DD2
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:22:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437757AbgL1OUX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:20:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:55172 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2437755AbgL1OUV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:20:21 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4E8BB221F0;
        Mon, 28 Dec 2020 14:20:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609165205;
        bh=xpHZPIlrxN9j9CZiMSV1kepGwClOp78JERWUjLLzxp8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bV7WVkXwYcswjwQs3tp4+cCmafo/8MqlfP3TNWJoFibj9tzHfQlZVks9QFAy4tg4X
         GTRsp1UQ4dW7IJaHuu4jSsMs39l4tVyo04cVyZauSTwZowZARKNFCVPxUZd+3NTDgV
         i4zovk6iVCLuKNHKKOzzmNNOXLP7xcq8+UGmTlSo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Madhavan Srinivasan <maddy@linux.ibm.com>,
        Athira Rajeev <atrajeev@linux.vnet.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 442/717] powerpc/perf: Fix Threshold Event Counter Multiplier width for P10
Date:   Mon, 28 Dec 2020 13:47:20 +0100
Message-Id: <20201228125042.145791882@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Madhavan Srinivasan <maddy@linux.ibm.com>

[ Upstream commit ef0e3b650f8ddc54bb70868852f50642ee3ae765 ]

Threshold Event Counter Multiplier (TECM) is part of Monitor Mode
Control Register A (MMCRA). This field along with Threshold Event
Counter Exponent (TECE) is used to get threshould counter value.
In Power10, this is a 8bit field, so patch fixes the
current code to modify the MMCRA[TECM] extraction macro to
handle this change. ISA v3.1 says this is a 7 bit field but
POWER10 it's actually 8 bits which will hopefully be fixed
in ISA v3.1 update.

Fixes: 170a315f41c6 ("powerpc/perf: Support to export MMCRA[TEC*] field to userspace")
Signed-off-by: Madhavan Srinivasan <maddy@linux.ibm.com>
Signed-off-by: Athira Rajeev <atrajeev@linux.vnet.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/1608022578-1532-1-git-send-email-atrajeev@linux.vnet.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/perf/isa207-common.c | 3 +++
 arch/powerpc/perf/isa207-common.h | 4 ++++
 2 files changed, 7 insertions(+)

diff --git a/arch/powerpc/perf/isa207-common.c b/arch/powerpc/perf/isa207-common.c
index 0f4983ef41036..e1a21d34c6e49 100644
--- a/arch/powerpc/perf/isa207-common.c
+++ b/arch/powerpc/perf/isa207-common.c
@@ -247,6 +247,9 @@ void isa207_get_mem_weight(u64 *weight)
 	u64 sier = mfspr(SPRN_SIER);
 	u64 val = (sier & ISA207_SIER_TYPE_MASK) >> ISA207_SIER_TYPE_SHIFT;
 
+	if (cpu_has_feature(CPU_FTR_ARCH_31))
+		mantissa = P10_MMCRA_THR_CTR_MANT(mmcra);
+
 	if (val == 0 || val == 7)
 		*weight = 0;
 	else
diff --git a/arch/powerpc/perf/isa207-common.h b/arch/powerpc/perf/isa207-common.h
index 42087643c3331..454b32c314406 100644
--- a/arch/powerpc/perf/isa207-common.h
+++ b/arch/powerpc/perf/isa207-common.h
@@ -231,6 +231,10 @@
 #define MMCRA_THR_CTR_EXP(v)		(((v) >> MMCRA_THR_CTR_EXP_SHIFT) &\
 						MMCRA_THR_CTR_EXP_MASK)
 
+#define P10_MMCRA_THR_CTR_MANT_MASK	0xFFul
+#define P10_MMCRA_THR_CTR_MANT(v)	(((v) >> MMCRA_THR_CTR_MANT_SHIFT) &\
+						P10_MMCRA_THR_CTR_MANT_MASK)
+
 /* MMCRA Threshold Compare bit constant for power9 */
 #define p9_MMCRA_THR_CMP_SHIFT	45
 
-- 
2.27.0



