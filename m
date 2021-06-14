Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C46903A63D1
	for <lists+stable@lfdr.de>; Mon, 14 Jun 2021 13:15:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235603AbhFNLRa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Jun 2021 07:17:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:45866 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234688AbhFNLPV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Jun 2021 07:15:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3E0AD613F1;
        Mon, 14 Jun 2021 10:49:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623667774;
        bh=QprP99+5fmUex3Ytks9Sulz/04gs2honyf/nOSYgr0Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qGzl31+HgaVXxXi3Qz/HlN2WAc/fPRRpJfDUU5BmA6cDksocw0DuGa4F/MYbGrM3Q
         VMAnkyOu+Pu3XEk2R0morK1ZI8DrBm8fvFgBk6rSwVM1xq5WOosZ//szHXFqhP2Bog
         DoaGQ6lMivBEtq74vwGyq+0Nm9kg2XGUxmIiFlwM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jin Yao <yao.jin@linux.intel.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>
Subject: [PATCH 5.12 062/173] perf/x86/intel/uncore: Fix M2M event umask for Ice Lake server
Date:   Mon, 14 Jun 2021 12:26:34 +0200
Message-Id: <20210614102700.229570005@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210614102658.137943264@linuxfoundation.org>
References: <20210614102658.137943264@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kan Liang <kan.liang@linux.intel.com>

commit 848ff3768684701a4ce73a2ec0e5d438d4e2b0da upstream.

Perf tool errors out with the latest event list for the Ice Lake server.

event syntax error: 'unc_m2m_imc_reads.to_pmm'
                           \___ value too big for format, maximum is 255

The same as the Snow Ridge server, the M2M uncore unit in the Ice Lake
server has the unit mask extension field as well.

Fixes: 2b3b76b5ec67 ("perf/x86/intel/uncore: Add Ice Lake server uncore support")
Reported-by: Jin Yao <yao.jin@linux.intel.com>
Signed-off-by: Kan Liang <kan.liang@linux.intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: stable@vger.kernel.org
Link: https://lkml.kernel.org/r/1622552943-119174-1-git-send-email-kan.liang@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/events/intel/uncore_snbep.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/arch/x86/events/intel/uncore_snbep.c
+++ b/arch/x86/events/intel/uncore_snbep.c
@@ -5103,9 +5103,10 @@ static struct intel_uncore_type icx_unco
 	.perf_ctr	= SNR_M2M_PCI_PMON_CTR0,
 	.event_ctl	= SNR_M2M_PCI_PMON_CTL0,
 	.event_mask	= SNBEP_PMON_RAW_EVENT_MASK,
+	.event_mask_ext	= SNR_M2M_PCI_PMON_UMASK_EXT,
 	.box_ctl	= SNR_M2M_PCI_PMON_BOX_CTL,
 	.ops		= &snr_m2m_uncore_pci_ops,
-	.format_group	= &skx_uncore_format_group,
+	.format_group	= &snr_m2m_uncore_format_group,
 };
 
 static struct attribute *icx_upi_uncore_formats_attr[] = {


