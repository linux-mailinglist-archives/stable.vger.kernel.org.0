Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23C622E40EC
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:00:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2440342AbgL1OOL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:14:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:47362 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2440333AbgL1OOI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:14:08 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AA29D205CB;
        Mon, 28 Dec 2020 14:13:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609164833;
        bh=6uS6DcEZBBgSlgBOVMDtReFI4lLMqPz3dm/DqCxaXW8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PkJhHP61BJWpN4qvrtHcxKWYrOA9h8krHf67guIoyLyAlbC3LSkgejfljLnogbrl7
         eVYsve0L1b+nRAb4T6iqiruZ7DuZ40PimPw5NSBj8bUZ+J6qwNf+N47aqQyJL0SH7w
         PnFRLgojG1eYAmurCM4IWdBykq4xyWI23TfHbatg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Athira Rajeev <atrajeev@linux.vnet.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 284/717] powerpc/perf: Fix the PMU group constraints for threshold events in power10
Date:   Mon, 28 Dec 2020 13:44:42 +0100
Message-Id: <20201228125034.635827677@linuxfoundation.org>
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

[ Upstream commit 0263bbb377af0c2d38bc8b2ad2ff147e240094de ]

The PMU group constraints mask for threshold events covers
all thresholding bits which includes threshold control value
(start/stop), select value as well as thresh_cmp value (MMCRA[9:18].
In power9, thresh_cmp bits were part of the event code. But in case
of power10, thresh_cmp bits are not part of event code due to
inclusion of MMCR3 bits. Hence thresh_cmp is not valid for
group constraints for power10.

Fix the PMU group constraints checking for threshold events in
power10 by using constraint mask and value for only threshold control
and select bits.

Fixes: a64e697cef23 ("powerpc/perf: power10 Performance Monitoring support")
Signed-off-by: Athira Rajeev <atrajeev@linux.vnet.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/1606409684-1589-4-git-send-email-atrajeev@linux.vnet.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/perf/isa207-common.c | 7 ++++++-
 arch/powerpc/perf/isa207-common.h | 3 +++
 2 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/arch/powerpc/perf/isa207-common.c b/arch/powerpc/perf/isa207-common.c
index 38ed450c78557..0f4983ef41036 100644
--- a/arch/powerpc/perf/isa207-common.c
+++ b/arch/powerpc/perf/isa207-common.c
@@ -351,7 +351,12 @@ int isa207_get_constraint(u64 event, unsigned long *maskp, unsigned long *valp)
 		value |= CNST_SAMPLE_VAL(event >> EVENT_SAMPLE_SHIFT);
 	}
 
-	if (cpu_has_feature(CPU_FTR_ARCH_300))  {
+	if (cpu_has_feature(CPU_FTR_ARCH_31)) {
+		if (event_is_threshold(event)) {
+			mask  |= CNST_THRESH_CTL_SEL_MASK;
+			value |= CNST_THRESH_CTL_SEL_VAL(event >> EVENT_THRESH_SHIFT);
+		}
+	} else if (cpu_has_feature(CPU_FTR_ARCH_300))  {
 		if (event_is_threshold(event) && is_thresh_cmp_valid(event)) {
 			mask  |= CNST_THRESH_MASK;
 			value |= CNST_THRESH_VAL(event >> EVENT_THRESH_SHIFT);
diff --git a/arch/powerpc/perf/isa207-common.h b/arch/powerpc/perf/isa207-common.h
index dc9c3d22fb38d..42087643c3331 100644
--- a/arch/powerpc/perf/isa207-common.h
+++ b/arch/powerpc/perf/isa207-common.h
@@ -149,6 +149,9 @@
 #define CNST_THRESH_VAL(v)	(((v) & EVENT_THRESH_MASK) << 32)
 #define CNST_THRESH_MASK	CNST_THRESH_VAL(EVENT_THRESH_MASK)
 
+#define CNST_THRESH_CTL_SEL_VAL(v)	(((v) & 0x7ffull) << 32)
+#define CNST_THRESH_CTL_SEL_MASK	CNST_THRESH_CTL_SEL_VAL(0x7ff)
+
 #define CNST_EBB_VAL(v)		(((v) & EVENT_EBB_MASK) << 24)
 #define CNST_EBB_MASK		CNST_EBB_VAL(EVENT_EBB_MASK)
 
-- 
2.27.0



