Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7B2429C429
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 18:54:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1822857AbgJ0RxZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 13:53:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:48352 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1758762AbgJ0OX3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:23:29 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1B38A20780;
        Tue, 27 Oct 2020 14:23:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603808608;
        bh=IKyiJ3lCslC3+7ALfUq8DNyGwsGCWxoU5t3/yQCsvH4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r5Gb1YxpugMoE51WCLvWokDTTdT3Y5yUIpKhM8/mSY5/x8kohxkQla+YIQciCXcdP
         v2f2TH8Z6PUb+HyIY+VPRtYXF8A3RjB22jyRK4/aYbGs2IYOEqO09gX0H7bXGDiS/M
         nwjehGTCLrtBVoisYCA33JyIi3JZ66nVJdtorbaM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Athira Rajeev <atrajeev@linux.vnet.ibm.com>,
        Madhavan Srinivasan <maddy@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 157/264] powerpc/perf: Exclude pmc5/6 from the irrelevant PMU group constraints
Date:   Tue, 27 Oct 2020 14:53:35 +0100
Message-Id: <20201027135438.055852209@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135430.632029009@linuxfoundation.org>
References: <20201027135430.632029009@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Athira Rajeev <atrajeev@linux.vnet.ibm.com>

[ Upstream commit 3b6c3adbb2fa42749c3d38cfc4d4d0b7e096bb7b ]

PMU counter support functions enforces event constraints for group of
events to check if all events in a group can be monitored. Incase of
event codes using PMC5 and PMC6 ( 500fa and 600f4 respectively ), not
all constraints are applicable, say the threshold or sample bits. But
current code includes pmc5 and pmc6 in some group constraints (like
IC_DC Qualifier bits) which is actually not applicable and hence
results in those events not getting counted when scheduled along with
group of other events. Patch fixes this by excluding PMC5/6 from
constraints which are not relevant for it.

Fixes: 7ffd948 ("powerpc/perf: factor out power8 pmu functions")
Signed-off-by: Athira Rajeev <atrajeev@linux.vnet.ibm.com>
Reviewed-by: Madhavan Srinivasan <maddy@linux.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/1600672204-1610-1-git-send-email-atrajeev@linux.vnet.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/perf/isa207-common.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/powerpc/perf/isa207-common.c b/arch/powerpc/perf/isa207-common.c
index 053b8e9aa9e75..69a2dc2b16cf1 100644
--- a/arch/powerpc/perf/isa207-common.c
+++ b/arch/powerpc/perf/isa207-common.c
@@ -273,6 +273,15 @@ int isa207_get_constraint(u64 event, unsigned long *maskp, unsigned long *valp)
 
 		mask  |= CNST_PMC_MASK(pmc);
 		value |= CNST_PMC_VAL(pmc);
+
+		/*
+		 * PMC5 and PMC6 are used to count cycles and instructions and
+		 * they do not support most of the constraint bits. Add a check
+		 * to exclude PMC5/6 from most of the constraints except for
+		 * EBB/BHRB.
+		 */
+		if (pmc >= 5)
+			goto ebb_bhrb;
 	}
 
 	if (pmc <= 4) {
@@ -331,6 +340,7 @@ int isa207_get_constraint(u64 event, unsigned long *maskp, unsigned long *valp)
 		}
 	}
 
+ebb_bhrb:
 	if (!pmc && ebb)
 		/* EBB events must specify the PMC */
 		return -1;
-- 
2.25.1



