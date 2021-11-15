Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74609451042
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 19:42:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241859AbhKOSpP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 13:45:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:47448 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242315AbhKOSmy (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:42:54 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4B457632FC;
        Mon, 15 Nov 2021 18:05:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636999522;
        bh=NQxE+6w9fhFuXZnEWm6DbisJoOeUEicJXKlR0P3WsMg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kmQznjydQWiDkQ26qma3b8064WxvuL23gKrsg3vN2eROW8ATZmzEbUhxmsCQV/TG2
         8tt4MBXoBK6UoRs2gpzcGDSgaX1AKV3ffEpGVXrYzj2UWBa2LT7DxK7iOENsZUZH4I
         ewcOvGVWe8tesngb/7+b2l8kehNHndP4zY2vN+AA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stephane Eranian <eranian@google.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 329/849] perf/x86/intel: Fix ICL/SPR INST_RETIRED.PREC_DIST encodings
Date:   Mon, 15 Nov 2021 17:56:52 +0100
Message-Id: <20211115165431.371658911@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
References: <20211115165419.961798833@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stephane Eranian <eranian@google.com>

[ Upstream commit 2de71ee153efa93099d2ab864acffeec70a8dcd5 ]

This patch fixes the encoding for INST_RETIRED.PREC_DIST as published by Intel
(download.01.org/perfmon/) for Icelake. The official encoding
is event code 0x00 umask 0x1, a change from Skylake where it was code 0xc0
umask 0x1.

With this patch applied it is possible to run:
$ perf record -a -e cpu/event=0x00,umask=0x1/pp .....

Whereas before this would fail.

To avoid problems with tools which may use the old code, we maintain the old
encoding for Icelake.

Signed-off-by: Stephane Eranian <eranian@google.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lkml.kernel.org/r/20211014001214.2680534-1-eranian@google.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/events/intel/core.c | 5 +++--
 arch/x86/events/intel/ds.c   | 5 +++--
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/arch/x86/events/intel/core.c b/arch/x86/events/intel/core.c
index 482224444a1ee..41da78eda95ea 100644
--- a/arch/x86/events/intel/core.c
+++ b/arch/x86/events/intel/core.c
@@ -243,7 +243,8 @@ static struct extra_reg intel_skl_extra_regs[] __read_mostly = {
 
 static struct event_constraint intel_icl_event_constraints[] = {
 	FIXED_EVENT_CONSTRAINT(0x00c0, 0),	/* INST_RETIRED.ANY */
-	FIXED_EVENT_CONSTRAINT(0x01c0, 0),	/* INST_RETIRED.PREC_DIST */
+	FIXED_EVENT_CONSTRAINT(0x01c0, 0),	/* old INST_RETIRED.PREC_DIST */
+	FIXED_EVENT_CONSTRAINT(0x0100, 0),	/* INST_RETIRED.PREC_DIST */
 	FIXED_EVENT_CONSTRAINT(0x003c, 1),	/* CPU_CLK_UNHALTED.CORE */
 	FIXED_EVENT_CONSTRAINT(0x0300, 2),	/* CPU_CLK_UNHALTED.REF */
 	FIXED_EVENT_CONSTRAINT(0x0400, 3),	/* SLOTS */
@@ -288,7 +289,7 @@ static struct extra_reg intel_spr_extra_regs[] __read_mostly = {
 
 static struct event_constraint intel_spr_event_constraints[] = {
 	FIXED_EVENT_CONSTRAINT(0x00c0, 0),	/* INST_RETIRED.ANY */
-	FIXED_EVENT_CONSTRAINT(0x01c0, 0),	/* INST_RETIRED.PREC_DIST */
+	FIXED_EVENT_CONSTRAINT(0x0100, 0),	/* INST_RETIRED.PREC_DIST */
 	FIXED_EVENT_CONSTRAINT(0x003c, 1),	/* CPU_CLK_UNHALTED.CORE */
 	FIXED_EVENT_CONSTRAINT(0x0300, 2),	/* CPU_CLK_UNHALTED.REF */
 	FIXED_EVENT_CONSTRAINT(0x0400, 3),	/* SLOTS */
diff --git a/arch/x86/events/intel/ds.c b/arch/x86/events/intel/ds.c
index 8647713276a73..4dbb55a43dad2 100644
--- a/arch/x86/events/intel/ds.c
+++ b/arch/x86/events/intel/ds.c
@@ -923,7 +923,8 @@ struct event_constraint intel_skl_pebs_event_constraints[] = {
 };
 
 struct event_constraint intel_icl_pebs_event_constraints[] = {
-	INTEL_FLAGS_UEVENT_CONSTRAINT(0x1c0, 0x100000000ULL),	/* INST_RETIRED.PREC_DIST */
+	INTEL_FLAGS_UEVENT_CONSTRAINT(0x01c0, 0x100000000ULL),	/* old INST_RETIRED.PREC_DIST */
+	INTEL_FLAGS_UEVENT_CONSTRAINT(0x0100, 0x100000000ULL),	/* INST_RETIRED.PREC_DIST */
 	INTEL_FLAGS_UEVENT_CONSTRAINT(0x0400, 0x800000000ULL),	/* SLOTS */
 
 	INTEL_PLD_CONSTRAINT(0x1cd, 0xff),			/* MEM_TRANS_RETIRED.LOAD_LATENCY */
@@ -943,7 +944,7 @@ struct event_constraint intel_icl_pebs_event_constraints[] = {
 };
 
 struct event_constraint intel_spr_pebs_event_constraints[] = {
-	INTEL_FLAGS_UEVENT_CONSTRAINT(0x1c0, 0x100000000ULL),
+	INTEL_FLAGS_UEVENT_CONSTRAINT(0x100, 0x100000000ULL),	/* INST_RETIRED.PREC_DIST */
 	INTEL_FLAGS_UEVENT_CONSTRAINT(0x0400, 0x800000000ULL),
 
 	INTEL_FLAGS_EVENT_CONSTRAINT(0xc0, 0xfe),
-- 
2.33.0



