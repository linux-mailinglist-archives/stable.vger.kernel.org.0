Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FCD93974E9
	for <lists+stable@lfdr.de>; Tue,  1 Jun 2021 16:04:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234189AbhFAOGj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Jun 2021 10:06:39 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:33142 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234166AbhFAOGh (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Jun 2021 10:06:37 -0400
Date:   Tue, 01 Jun 2021 14:04:52 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1622556293;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xAa/sriNXmsB9CTfTHo+BJPpCraBW6KNndKIik3v31E=;
        b=1HmF/kbnO5ZQkZl6xkGAVtPTSzHu4Id/o7vb6GAoC7MUfHKOWYkpTKDz4BO2gtiTbllaIc
        VXrOMfyOdjRdrmrKN+Ceur0j0jPJOg5UpduRBe7zlCkAc0p9BPOmsv9qIb0nd11MqsyOMX
        XdIpA6vLVQ9ZNWRqkReZ6q9v7G3RGBQzF7XCxeslvSfsjE+DjDdDL6niuNK/o8QwD2yuVD
        cyN8A+9RsGsDstDjTCLnLtCw9TmrWTFcu2xkYfOh5saMuh3YbbpIxWh4vcgIedwOcCGpzY
        QJ2F8LMIN1GPypC9kh4+wbYcDny+rBkq86Su0hsuNDkG1qVKhDGZI5zuA97dBA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1622556293;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xAa/sriNXmsB9CTfTHo+BJPpCraBW6KNndKIik3v31E=;
        b=ww+UziM5Mr97V8AwRzGEdaJkmg8jh61eus6t0KWZ+AHf5SmbhcRGf0fvp2k8/1kgc9yNMj
        dOHb1TkE7ccn+BDg==
From:   "tip-bot2 for Kan Liang" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: perf/urgent] perf/x86/intel/uncore: Fix M2M event umask for Ice
 Lake server
Cc:     Jin Yao <yao.jin@linux.intel.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        stable@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <1622552943-119174-1-git-send-email-kan.liang@linux.intel.com>
References: <1622552943-119174-1-git-send-email-kan.liang@linux.intel.com>
MIME-Version: 1.0
Message-ID: <162255629271.29796.7893738465861951742.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the perf/urgent branch of tip:

Commit-ID:     848ff3768684701a4ce73a2ec0e5d438d4e2b0da
Gitweb:        https://git.kernel.org/tip/848ff3768684701a4ce73a2ec0e5d438d4e2b0da
Author:        Kan Liang <kan.liang@linux.intel.com>
AuthorDate:    Tue, 01 Jun 2021 06:09:03 -07:00
Committer:     Peter Zijlstra <peterz@infradead.org>
CommitterDate: Tue, 01 Jun 2021 16:00:05 +02:00

perf/x86/intel/uncore: Fix M2M event umask for Ice Lake server

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
---
 arch/x86/events/intel/uncore_snbep.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/events/intel/uncore_snbep.c b/arch/x86/events/intel/uncore_snbep.c
index 1587d32..3a75a2c 100644
--- a/arch/x86/events/intel/uncore_snbep.c
+++ b/arch/x86/events/intel/uncore_snbep.c
@@ -5099,9 +5099,10 @@ static struct intel_uncore_type icx_uncore_m2m = {
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
