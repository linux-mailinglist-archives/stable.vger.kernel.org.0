Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51A544521D7
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 02:04:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352060AbhKPBHE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 20:07:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:44640 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232852AbhKOTUS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:20:18 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 250636334A;
        Mon, 15 Nov 2021 18:33:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637001205;
        bh=Ad1HfrWZE2wvZQIdZBdlb/IcGyWLTaBmcq8k8RbNJbI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cOQnBY80DY3zZwuvJgtmTN99TmWSMSQFVhgiMeOywLURSW+2cttwwv20DzsP/P9L/
         kh6KRPLVK9IXGiREHN7ZApQQJ7L5l2AmBhatzZgykIjNj9Xn3IBctXmXYSEu0hMSFM
         57bDcEoRZCTlpV0O6QP3Az9NrJyCAhgALNCc2fs8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kan Liang <kan.liang@linux.intel.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 5.15 102/917] perf/x86/intel/uncore: Support extra IMC channel on Ice Lake server
Date:   Mon, 15 Nov 2021 17:53:17 +0100
Message-Id: <20211115165432.216701852@linuxfoundation.org>
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

From: Kan Liang <kan.liang@linux.intel.com>

commit 496a18f09374ad89b3ab4366019bc3975db90234 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/events/intel/uncore_snbep.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/x86/events/intel/uncore_snbep.c
+++ b/arch/x86/events/intel/uncore_snbep.c
@@ -452,7 +452,7 @@
 #define ICX_M3UPI_PCI_PMON_BOX_CTL		0xa0
 
 /* ICX IMC */
-#define ICX_NUMBER_IMC_CHN			2
+#define ICX_NUMBER_IMC_CHN			3
 #define ICX_IMC_MEM_STRIDE			0x4
 
 /* SPR */
@@ -5463,7 +5463,7 @@ static struct intel_uncore_ops icx_uncor
 static struct intel_uncore_type icx_uncore_imc = {
 	.name		= "imc",
 	.num_counters   = 4,
-	.num_boxes	= 8,
+	.num_boxes	= 12,
 	.perf_ctr_bits	= 48,
 	.fixed_ctr_bits	= 48,
 	.fixed_ctr	= SNR_IMC_MMIO_PMON_FIXED_CTR,


