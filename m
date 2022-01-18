Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6261B492485
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 12:18:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239360AbiARLR5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Jan 2022 06:17:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239344AbiARLR4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Jan 2022 06:17:56 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAFC1C06173E;
        Tue, 18 Jan 2022 03:17:55 -0800 (PST)
Date:   Tue, 18 Jan 2022 11:17:53 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1642504674;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PaW7SLV/zkwu/CdKU07m4qvRYvngfu+HL9fRAydCr/0=;
        b=TFTaPEp/cRgrAwQr/V13GpwcqaktqGtZJua9FYunFUvsoM5dBhJR6cQJ3utzO67i120P/W
        StGK1NVRgubrqPgSqJb0aVJZv3YXqslPupdfA0d3O02Z+9g8/EJ6lXNwk9J0jiZTvsDcT/
        +DHy7pDJgTg6uRld3FStCdU07ghBTLkng7uvsLFGPbvFnEC9EmXBPVhIwx4H2LrAlKbCDf
        714HAXC3w5o2EjU7Ial4wAvEFJ4NvUsFg0KYmqRdGlL/wYmp0IXc9KxHcr+vviMba8PBdk
        OkmomaST2aB2pHO7Ql8vzhfXh7vZtl7l2ANR0EZKbCdQ6HgASsHEdcsK066xUQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1642504674;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PaW7SLV/zkwu/CdKU07m4qvRYvngfu+HL9fRAydCr/0=;
        b=9ayccppgZB5QDhM13WPT0bivqpPJe9wUlA2NAD2p9U1yNURzNFIr6VdKn9MLnlBZ4nknfp
        6YbkPE5D/9cIiMDw==
From:   "tip-bot2 for Zhengjun Xing" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: perf/urgent] perf/x86/intel/uncore: Fix CAS_COUNT_WRITE issue for ICX
Cc:     Zhengjun Xing <zhengjun.xing@linux.intel.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Kan Liang <kan.liang@linux.intel.com>, stable@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20211223144826.841267-1-zhengjun.xing@linux.intel.com>
References: <20211223144826.841267-1-zhengjun.xing@linux.intel.com>
MIME-Version: 1.0
Message-ID: <164250467331.16921.5385792639692425336.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the perf/urgent branch of tip:

Commit-ID:     96fd2e89fba1aaada6f4b1e5d25a9d9ecbe1943d
Gitweb:        https://git.kernel.org/tip/96fd2e89fba1aaada6f4b1e5d25a9d9ecbe=
1943d
Author:        Zhengjun Xing <zhengjun.xing@linux.intel.com>
AuthorDate:    Thu, 23 Dec 2021 22:48:26 +08:00
Committer:     Peter Zijlstra <peterz@infradead.org>
CommitterDate: Tue, 18 Jan 2022 12:09:48 +01:00

perf/x86/intel/uncore: Fix CAS_COUNT_WRITE issue for ICX

The user recently report a perf issue in the ICX platform, when test by
perf event =E2=80=9Cuncore_imc_x/cas_count_write=E2=80=9D,the write bandwidth=
 is always
very small (only 0.38MB/s), it is caused by the wrong "umask" for the
"cas_count_write" event. When double-checking, find "cas_count_read"
also is wrong.

The public document for ICX uncore:

3rd Gen Intel=C2=AE Xeon=C2=AE Processor Scalable Family, Codename Ice Lake,U=
ncore
Performance Monitoring Reference Manual, Revision 1.00, May 2021

On 2.4.7, it defines Unit Masks for CAS_COUNT:
RD b00001111
WR b00110000

So corrected both "cas_count_read" and "cas_count_write" for ICX.

Old settings:
 hswep_uncore_imc_events
	INTEL_UNCORE_EVENT_DESC(cas_count_read,  "event=3D0x04,umask=3D0x03")
	INTEL_UNCORE_EVENT_DESC(cas_count_write, "event=3D0x04,umask=3D0x0c")

New settings:
 snr_uncore_imc_events
	INTEL_UNCORE_EVENT_DESC(cas_count_read,  "event=3D0x04,umask=3D0x0f")
	INTEL_UNCORE_EVENT_DESC(cas_count_write, "event=3D0x04,umask=3D0x30")

Fixes: 2b3b76b5ec67 ("perf/x86/intel/uncore: Add Ice Lake server uncore suppo=
rt")
Signed-off-by: Zhengjun Xing <zhengjun.xing@linux.intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Adrian Hunter <adrian.hunter@intel.com>
Reviewed-by: Kan Liang <kan.liang@linux.intel.com>
Cc: stable@vger.kernel.org
Link: https://lkml.kernel.org/r/20211223144826.841267-1-zhengjun.xing@linux.i=
ntel.com
---
 arch/x86/events/intel/uncore_snbep.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/events/intel/uncore_snbep.c b/arch/x86/events/intel/unc=
ore_snbep.c
index 3660f69..ed86944 100644
--- a/arch/x86/events/intel/uncore_snbep.c
+++ b/arch/x86/events/intel/uncore_snbep.c
@@ -5482,7 +5482,7 @@ static struct intel_uncore_type icx_uncore_imc =3D {
 	.fixed_ctr_bits	=3D 48,
 	.fixed_ctr	=3D SNR_IMC_MMIO_PMON_FIXED_CTR,
 	.fixed_ctl	=3D SNR_IMC_MMIO_PMON_FIXED_CTL,
-	.event_descs	=3D hswep_uncore_imc_events,
+	.event_descs	=3D snr_uncore_imc_events,
 	.perf_ctr	=3D SNR_IMC_MMIO_PMON_CTR0,
 	.event_ctl	=3D SNR_IMC_MMIO_PMON_CTL0,
 	.event_mask	=3D SNBEP_PMON_RAW_EVENT_MASK,
