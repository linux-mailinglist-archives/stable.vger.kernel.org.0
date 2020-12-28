Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1495A2E3D58
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:15:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2440431AbgL1OOc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:14:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:49410 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2440427AbgL1OOb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:14:31 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D794C206D4;
        Mon, 28 Dec 2020 14:13:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609164830;
        bh=i5fxNS88Br1qWl9mj5hwz5L42n4TG47eRxy5ri6kkbQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Tz8pN6Zv471CU0/nSjn7F/XT1yuJcbeovQIaIvvaITuqvtgxt9ntoZrMjMgsrpiib
         kYQ+1y5vxvENFgyeIUxoPuMgiMIaXHL8cCgLHPz5N4FCSK5mFmgjN6uvrehFoVYn8H
         rziDLk8P9gW9RovmEiqV5gk1qc+QR9e0kbPaOoik=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Athira Rajeev <atrajeev@linux.vnet.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 283/717] powerpc/perf: Update the PMU group constraints for l2l3 events in power10
Date:   Mon, 28 Dec 2020 13:44:41 +0100
Message-Id: <20201228125034.586963923@linuxfoundation.org>
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

From: Athira Rajeev <atrajeev@linux.vnet.ibm.com>

[ Upstream commit e924be7b0b0d1f37d0509c854a92c7a71e3cdfe7 ]

In Power9, L2/L3 bus events are always available as a
"bank" of 4 events. To obtain the counts for any of the
l2/l3 bus events in a given bank, the user will have to
program PMC4 with corresponding l2/l3 bus event for that
bank.

Commit 59029136d750 ("powerpc/perf: Add constraints for power9 l2/l3 bus events")
enforced this rule in Power9. But this is not valid for
Power10, since in Power10 Monitor Mode Control Register2
(MMCR2) has bits to configure l2/l3 event bits. Hence remove
this PMC4 constraint check from power10.

Since the l2/l3 bits in MMCR2 are not per-pmc, patch handles
group constrints checks for l2/l3 bits in MMCR2.

Fixes: a64e697cef23 ("powerpc/perf: power10 Performance Monitoring support")
Signed-off-by: Athira Rajeev <atrajeev@linux.vnet.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/1606409684-1589-3-git-send-email-atrajeev@linux.vnet.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/perf/isa207-common.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/arch/powerpc/perf/isa207-common.c b/arch/powerpc/perf/isa207-common.c
index f57f54f92c10f..38ed450c78557 100644
--- a/arch/powerpc/perf/isa207-common.c
+++ b/arch/powerpc/perf/isa207-common.c
@@ -311,9 +311,11 @@ int isa207_get_constraint(u64 event, unsigned long *maskp, unsigned long *valp)
 	}
 
 	if (unit >= 6 && unit <= 9) {
-		if (cpu_has_feature(CPU_FTR_ARCH_31) && (unit == 6)) {
-			mask |= CNST_L2L3_GROUP_MASK;
-			value |= CNST_L2L3_GROUP_VAL(event >> p10_L2L3_EVENT_SHIFT);
+		if (cpu_has_feature(CPU_FTR_ARCH_31)) {
+			if (unit == 6) {
+				mask |= CNST_L2L3_GROUP_MASK;
+				value |= CNST_L2L3_GROUP_VAL(event >> p10_L2L3_EVENT_SHIFT);
+			}
 		} else if (cpu_has_feature(CPU_FTR_ARCH_300)) {
 			mask  |= CNST_CACHE_GROUP_MASK;
 			value |= CNST_CACHE_GROUP_VAL(event & 0xff);
-- 
2.27.0



