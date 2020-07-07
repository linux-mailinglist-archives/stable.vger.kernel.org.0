Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC23F217195
	for <lists+stable@lfdr.de>; Tue,  7 Jul 2020 17:42:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729814AbgGGPWN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jul 2020 11:22:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:34662 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729802AbgGGPWM (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jul 2020 11:22:12 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A49E2206F6;
        Tue,  7 Jul 2020 15:22:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594135332;
        bh=YkPX7C835u0Pj/MOlkpss0mapDUcaO+iKRlRfbVBS50=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Evx2kGZ4IS/fZ/ZHJoVJaGQq+8877rw4GlNiXDvhn9i4eEe4AZIBDK1IGdAKdjawm
         hWjCBRPdpl92J8Y4Dh8rrYn1KnTjwG8E5DHNnXRvseWss+aN+XQ/88cXpkHtgzWJb4
         AhtuNKmGehyBScTJYm5vU+PE5sqWXKfG2S7g0ejU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Babu Moger <babu.moger@amd.com>,
        Borislav Petkov <bp@suse.de>
Subject: [PATCH 5.4 63/65] x86/resctrl: Fix memory bandwidth counter width for AMD
Date:   Tue,  7 Jul 2020 17:17:42 +0200
Message-Id: <20200707145755.516964685@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200707145752.417212219@linuxfoundation.org>
References: <20200707145752.417212219@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Babu Moger <babu.moger@amd.com>

commit 2c18bd525c47f882f033b0a813ecd09c93e1ecdf upstream.

Memory bandwidth is calculated reading the monitoring counter
at two intervals and calculating the delta. It is the software’s
responsibility to read the count often enough to avoid having
the count roll over _twice_ between reads.

The current code hardcodes the bandwidth monitoring counter's width
to 24 bits for AMD. This is due to default base counter width which
is 24. Currently, AMD does not implement the CPUID 0xF.[ECX=1]:EAX
to adjust the counter width. But, the AMD hardware supports much
wider bandwidth counter with the default width of 44 bits.

Kernel reads these monitoring counters every 1 second and adjusts the
counter value for overflow. With 24 bits and scale value of 64 for AMD,
it can only measure up to 1GB/s without overflowing. For the rates
above 1GB/s this will fail to measure the bandwidth.

Fix the issue setting the default width to 44 bits by adjusting the
offset.

AMD future products will implement CPUID 0xF.[ECX=1]:EAX.

 [ bp: Let the line stick out and drop {}-brackets around a single
   statement. ]

Fixes: 4d05bf71f157 ("x86/resctrl: Introduce AMD QOS feature")
Signed-off-by: Babu Moger <babu.moger@amd.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Link: https://lkml.kernel.org/r/159129975546.62538.5656031125604254041.stgit@naples-babu.amd.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>


---
 arch/x86/kernel/cpu/resctrl/core.c     |    2 ++
 arch/x86/kernel/cpu/resctrl/internal.h |    3 +++
 arch/x86/kernel/cpu/resctrl/monitor.c  |    3 ++-
 3 files changed, 7 insertions(+), 1 deletion(-)

--- a/arch/x86/kernel/cpu/resctrl/core.c
+++ b/arch/x86/kernel/cpu/resctrl/core.c
@@ -260,6 +260,7 @@ static bool __get_mem_config_intel(struc
 	r->num_closid = edx.split.cos_max + 1;
 	r->membw.max_delay = eax.split.max_delay + 1;
 	r->default_ctrl = MAX_MBA_BW;
+	r->membw.mbm_width = MBM_CNTR_WIDTH;
 	if (ecx & MBA_IS_LINEAR) {
 		r->membw.delay_linear = true;
 		r->membw.min_bw = MAX_MBA_BW - r->membw.max_delay;
@@ -289,6 +290,7 @@ static bool __rdt_get_mem_config_amd(str
 	/* AMD does not use delay */
 	r->membw.delay_linear = false;
 
+	r->membw.mbm_width = MBM_CNTR_WIDTH_AMD;
 	r->membw.min_bw = 0;
 	r->membw.bw_gran = 1;
 	/* Max value is 2048, Data width should be 4 in decimal */
--- a/arch/x86/kernel/cpu/resctrl/internal.h
+++ b/arch/x86/kernel/cpu/resctrl/internal.h
@@ -32,6 +32,7 @@
 #define CQM_LIMBOCHECK_INTERVAL	1000
 
 #define MBM_CNTR_WIDTH			24
+#define MBM_CNTR_WIDTH_AMD		44
 #define MBM_OVERFLOW_INTERVAL		1000
 #define MAX_MBA_BW			100u
 #define MBA_IS_LINEAR			0x4
@@ -368,6 +369,7 @@ struct rdt_cache {
  * @min_bw:		Minimum memory bandwidth percentage user can request
  * @bw_gran:		Granularity at which the memory bandwidth is allocated
  * @delay_linear:	True if memory B/W delay is in linear scale
+ * @mbm_width:		memory B/W monitor counter width
  * @mba_sc:		True if MBA software controller(mba_sc) is enabled
  * @mb_map:		Mapping of memory B/W percentage to memory B/W delay
  */
@@ -376,6 +378,7 @@ struct rdt_membw {
 	u32		min_bw;
 	u32		bw_gran;
 	u32		delay_linear;
+	u32		mbm_width;
 	bool		mba_sc;
 	u32		*mb_map;
 };
--- a/arch/x86/kernel/cpu/resctrl/monitor.c
+++ b/arch/x86/kernel/cpu/resctrl/monitor.c
@@ -216,8 +216,9 @@ void free_rmid(u32 rmid)
 
 static u64 mbm_overflow_count(u64 prev_msr, u64 cur_msr)
 {
-	u64 shift = 64 - MBM_CNTR_WIDTH, chunks;
+	u64 shift, chunks;
 
+	shift = 64 - rdt_resources_all[RDT_RESOURCE_MBA].membw.mbm_width;
 	chunks = (cur_msr << shift) - (prev_msr << shift);
 	return chunks >>= shift;
 }


