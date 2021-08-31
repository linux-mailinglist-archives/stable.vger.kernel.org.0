Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F7DA3FC71B
	for <lists+stable@lfdr.de>; Tue, 31 Aug 2021 14:29:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234483AbhHaMMP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Aug 2021 08:12:15 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:58280 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239629AbhHaMIp (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 31 Aug 2021 08:08:45 -0400
Date:   Tue, 31 Aug 2021 12:07:45 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1630411666;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kUInUiJyV2VceqALcQZLx8XXBfc3E+4Yz0n5TT9SbDI=;
        b=t80k70LVxdTMBjontC9RapIFPMtIqauYqZBxWxOXvrlFimEl5f+QAYcaUPUGAexwkYFq1V
        nUUQfC7Qrn19fvel9XohgsO4gyF00mz/ob0+kVJ/DD1+4xn2LQ9+Z2RwqRoj/sq93Zf/HW
        LczTG8uHUWDBnS4UcLo7xCVVwlJwj4EydDLe6lFyWkl5qMPSvMnWII9+o88fwiialsYcgW
        ZQuH0Epg/BQx7Q+NngCF6w88MldBQeQxj8DNXsPXJtne6K+wYdqMEK2+UwR7BQVTnbiHvd
        Cgf+vvtOg1sZON9xJJeNfd0n5ZhGFwjn3B6JIITkUMIFyztRFCDJSUFHOJYdQA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1630411666;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kUInUiJyV2VceqALcQZLx8XXBfc3E+4Yz0n5TT9SbDI=;
        b=qed5JuyV0tDQcI0co72O0oYMsQQixyCL6roPgdcPFnuakqjbOWZCdO9xK9TQ+hq7nr49sf
        yeMibC4ETWSVCWDg==
From:   "tip-bot2 for Kan Liang" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: perf/core] perf/x86/intel/uncore: Support extra IMC channel on
 Ice Lake server
Cc:     Kan Liang <kan.liang@linux.intel.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Andi Kleen <ak@linux.intel.com>, stable@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <1629991963-102621-2-git-send-email-kan.liang@linux.intel.com>
References: <1629991963-102621-2-git-send-email-kan.liang@linux.intel.com>
MIME-Version: 1.0
Message-ID: <163041166578.25758.7789165084888949942.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the perf/core branch of tip:

Commit-ID:     496a18f09374ad89b3ab4366019bc3975db90234
Gitweb:        https://git.kernel.org/tip/496a18f09374ad89b3ab4366019bc3975db90234
Author:        Kan Liang <kan.liang@linux.intel.com>
AuthorDate:    Thu, 26 Aug 2021 08:32:37 -07:00
Committer:     Peter Zijlstra <peterz@infradead.org>
CommitterDate: Tue, 31 Aug 2021 13:59:35 +02:00

perf/x86/intel/uncore: Support extra IMC channel on Ice Lake server

There are three channels on a Ice Lake server, but only two channels
will ever be active. Current perf only enables two channels.

Support the extra IMC channel, which may be activated on some Ice Lake
machines. For a non-activated channel, the SW can still access it. The
write will be ignored by the HW. 0 is always returned for the reading.

Fixes: 2b3b76b5ec67 ("perf/x86/intel/uncore: Add Ice Lake server uncore support")
Signed-off-by: Kan Liang <kan.liang@linux.intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Andi Kleen <ak@linux.intel.com>
Cc: stable@vger.kernel.org
Link: https://lkml.kernel.org/r/1629991963-102621-2-git-send-email-kan.liang@linux.intel.com
---
 arch/x86/events/intel/uncore_snbep.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/events/intel/uncore_snbep.c b/arch/x86/events/intel/uncore_snbep.c
index 5ddc0f3..ea29e89 100644
--- a/arch/x86/events/intel/uncore_snbep.c
+++ b/arch/x86/events/intel/uncore_snbep.c
@@ -452,7 +452,7 @@
 #define ICX_M3UPI_PCI_PMON_BOX_CTL		0xa0
 
 /* ICX IMC */
-#define ICX_NUMBER_IMC_CHN			2
+#define ICX_NUMBER_IMC_CHN			3
 #define ICX_IMC_MEM_STRIDE			0x4
 
 /* SPR */
@@ -5463,7 +5463,7 @@ static struct intel_uncore_ops icx_uncore_mmio_ops = {
 static struct intel_uncore_type icx_uncore_imc = {
 	.name		= "imc",
 	.num_counters   = 4,
-	.num_boxes	= 8,
+	.num_boxes	= 12,
 	.perf_ctr_bits	= 48,
 	.fixed_ctr_bits	= 48,
 	.fixed_ctr	= SNR_IMC_MMIO_PMON_FIXED_CTR,
