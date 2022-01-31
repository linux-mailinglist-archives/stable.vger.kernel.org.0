Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2D6B4A4267
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 12:12:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348885AbiAaLLr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 06:11:47 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:42912 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377063AbiAaLJd (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 06:09:33 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 92E8860ED0;
        Mon, 31 Jan 2022 11:09:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6018BC340E8;
        Mon, 31 Jan 2022 11:09:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643627372;
        bh=k2DtKHgtpZaa9V38EPljyP+xKLOCVtkX+3w5cWza7bc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lrYxfmT3l5vqYLOVHIv/s2jwOkuyEm0fm1JNqq2qeUNVgCricB7aH2DG7C6pYd4ni
         UT3qjSavyEitwDssMK1DYWlf0fmJOQx6zYxEvwcyX+rosyBQy3Kh7q/XUKDGhjU4N8
         IUjNHc9hChR4Qxn0rhEsMuF353JR6oeXsFN0XkGc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Zhengjun Xing <zhengjun.xing@linux.intel.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Kan Liang <kan.liang@linux.intel.com>
Subject: [PATCH 5.15 029/171] perf/x86/intel/uncore: Fix CAS_COUNT_WRITE issue for ICX
Date:   Mon, 31 Jan 2022 11:54:54 +0100
Message-Id: <20220131105231.002398524@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220131105229.959216821@linuxfoundation.org>
References: <20220131105229.959216821@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhengjun Xing <zhengjun.xing@linux.intel.com>

commit 96fd2e89fba1aaada6f4b1e5d25a9d9ecbe1943d upstream.

The user recently report a perf issue in the ICX platform, when test by
perf event “uncore_imc_x/cas_count_write”,the write bandwidth is always
very small (only 0.38MB/s), it is caused by the wrong "umask" for the
"cas_count_write" event. When double-checking, find "cas_count_read"
also is wrong.

The public document for ICX uncore:

3rd Gen Intel® Xeon® Processor Scalable Family, Codename Ice Lake,Uncore
Performance Monitoring Reference Manual, Revision 1.00, May 2021

On 2.4.7, it defines Unit Masks for CAS_COUNT:
RD b00001111
WR b00110000

So corrected both "cas_count_read" and "cas_count_write" for ICX.

Old settings:
 hswep_uncore_imc_events
	INTEL_UNCORE_EVENT_DESC(cas_count_read,  "event=0x04,umask=0x03")
	INTEL_UNCORE_EVENT_DESC(cas_count_write, "event=0x04,umask=0x0c")

New settings:
 snr_uncore_imc_events
	INTEL_UNCORE_EVENT_DESC(cas_count_read,  "event=0x04,umask=0x0f")
	INTEL_UNCORE_EVENT_DESC(cas_count_write, "event=0x04,umask=0x30")

Fixes: 2b3b76b5ec67 ("perf/x86/intel/uncore: Add Ice Lake server uncore support")
Signed-off-by: Zhengjun Xing <zhengjun.xing@linux.intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Adrian Hunter <adrian.hunter@intel.com>
Reviewed-by: Kan Liang <kan.liang@linux.intel.com>
Cc: stable@vger.kernel.org
Link: https://lkml.kernel.org/r/20211223144826.841267-1-zhengjun.xing@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/events/intel/uncore_snbep.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/events/intel/uncore_snbep.c
+++ b/arch/x86/events/intel/uncore_snbep.c
@@ -5482,7 +5482,7 @@ static struct intel_uncore_type icx_unco
 	.fixed_ctr_bits	= 48,
 	.fixed_ctr	= SNR_IMC_MMIO_PMON_FIXED_CTR,
 	.fixed_ctl	= SNR_IMC_MMIO_PMON_FIXED_CTL,
-	.event_descs	= hswep_uncore_imc_events,
+	.event_descs	= snr_uncore_imc_events,
 	.perf_ctr	= SNR_IMC_MMIO_PMON_CTR0,
 	.event_ctl	= SNR_IMC_MMIO_PMON_CTL0,
 	.event_mask	= SNBEP_PMON_RAW_EVENT_MASK,


