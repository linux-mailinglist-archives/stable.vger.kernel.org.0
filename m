Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89D791AC311
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 15:39:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2897451AbgDPNhZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 09:37:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:49604 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2897440AbgDPNhU (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Apr 2020 09:37:20 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 23400221EB;
        Thu, 16 Apr 2020 13:37:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587044239;
        bh=vHr6g5MwzQjKMd6VRdS/hjjFnOfpLL/Nb7slM5ESHiA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RruWCNQF5GOb2zW2bE5AGKKFQGRLsio4XazyG/CI7ZMFaYkqXGP4Qli/F6qSQ0GLe
         e9kH8+GJebY22zP18i3j9UfHn6t5cd1dhDF8989dm9LlDDx07rbkHYgGNH+a+nbfU/
         DoA80IdHW8yeRr0NvPVHhqOw2Tlvj1KWgDwaoS5g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 5.5 137/257] x86/tsc_msr: Use named struct initializers
Date:   Thu, 16 Apr 2020 15:23:08 +0200
Message-Id: <20200416131343.577957826@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200416131325.891903893@linuxfoundation.org>
References: <20200416131325.891903893@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

commit 812c2d7506fde7cdf83cb2532810a65782b51741 upstream.

Use named struct initializers for the freq_desc struct-s initialization
and change the "u8 msr_plat" to a "bool use_msr_plat" to make its meaning
more clear instead of relying on a comment to explain it.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: stable@vger.kernel.org
Link: https://lkml.kernel.org/r/20200223140610.59612-1-hdegoede@redhat.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kernel/tsc_msr.c |   28 ++++++++++++++++++----------
 1 file changed, 18 insertions(+), 10 deletions(-)

--- a/arch/x86/kernel/tsc_msr.c
+++ b/arch/x86/kernel/tsc_msr.c
@@ -22,10 +22,10 @@
  * read in MSR_PLATFORM_ID[12:8], otherwise in MSR_PERF_STAT[44:40].
  * Unfortunately some Intel Atom SoCs aren't quite compliant to this,
  * so we need manually differentiate SoC families. This is what the
- * field msr_plat does.
+ * field use_msr_plat does.
  */
 struct freq_desc {
-	u8 msr_plat;	/* 1: use MSR_PLATFORM_INFO, 0: MSR_IA32_PERF_STATUS */
+	bool use_msr_plat;
 	u32 freqs[MAX_NUM_FREQS];
 };
 
@@ -35,31 +35,39 @@ struct freq_desc {
  * by MSR based on SDM.
  */
 static const struct freq_desc freq_desc_pnw = {
-	0, { 0, 0, 0, 0, 0, 99840, 0, 83200 }
+	.use_msr_plat = false,
+	.freqs = { 0, 0, 0, 0, 0, 99840, 0, 83200 },
 };
 
 static const struct freq_desc freq_desc_clv = {
-	0, { 0, 133200, 0, 0, 0, 99840, 0, 83200 }
+	.use_msr_plat = false,
+	.freqs = { 0, 133200, 0, 0, 0, 99840, 0, 83200 },
 };
 
 static const struct freq_desc freq_desc_byt = {
-	1, { 83300, 100000, 133300, 116700, 80000, 0, 0, 0 }
+	.use_msr_plat = true,
+	.freqs = { 83300, 100000, 133300, 116700, 80000, 0, 0, 0 },
 };
 
 static const struct freq_desc freq_desc_cht = {
-	1, { 83300, 100000, 133300, 116700, 80000, 93300, 90000, 88900, 87500 }
+	.use_msr_plat = true,
+	.freqs = { 83300, 100000, 133300, 116700, 80000, 93300, 90000,
+		   88900, 87500 },
 };
 
 static const struct freq_desc freq_desc_tng = {
-	1, { 0, 100000, 133300, 0, 0, 0, 0, 0 }
+	.use_msr_plat = true,
+	.freqs = { 0, 100000, 133300, 0, 0, 0, 0, 0 },
 };
 
 static const struct freq_desc freq_desc_ann = {
-	1, { 83300, 100000, 133300, 100000, 0, 0, 0, 0 }
+	.use_msr_plat = true,
+	.freqs = { 83300, 100000, 133300, 100000, 0, 0, 0, 0 },
 };
 
 static const struct freq_desc freq_desc_lgm = {
-	1, { 78000, 78000, 78000, 78000, 78000, 78000, 78000, 78000 }
+	.use_msr_plat = true,
+	.freqs = { 78000, 78000, 78000, 78000, 78000, 78000, 78000, 78000 },
 };
 
 static const struct x86_cpu_id tsc_msr_cpu_ids[] = {
@@ -91,7 +99,7 @@ unsigned long cpu_khz_from_msr(void)
 		return 0;
 
 	freq_desc = (struct freq_desc *)id->driver_data;
-	if (freq_desc->msr_plat) {
+	if (freq_desc->use_msr_plat) {
 		rdmsr(MSR_PLATFORM_INFO, lo, hi);
 		ratio = (lo >> 8) & 0xff;
 	} else {


