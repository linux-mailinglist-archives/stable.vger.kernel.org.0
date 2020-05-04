Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92CDF1C4382
	for <lists+stable@lfdr.de>; Mon,  4 May 2020 19:59:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730650AbgEDR7C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 May 2020 13:59:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:52092 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730646AbgEDR7C (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 May 2020 13:59:02 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9DC3F2073E;
        Mon,  4 May 2020 17:59:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588615141;
        bh=5QUy5jYKJIIMfYKDgTPoFWmg2ibHT8Qm88KIdr9mHas=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GUHlZ+oveQ0cxWndxKQLDT2iBg6ZF1v2GWRWdzfPAiVWfPE1Z+x365+W10TbATD+1
         dR1BnF0jfpTdWjArPnYVvZfWLAb/MU5W2w2RU+ni5a4po/YWoTIjfuexJjeC0rnDoe
         QlwPEqgzkX91MOGRY/XAYL8cNewOwQ4yZ8EJdoE8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Madhavan Srinivasan <maddy@linux.vnet.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 4.4 12/18] powerpc/perf: Remove PPMU_HAS_SSLOT flag for Power8
Date:   Mon,  4 May 2020 19:57:10 +0200
Message-Id: <20200504165444.020859784@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200504165441.533160703@linuxfoundation.org>
References: <20200504165441.533160703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Madhavan Srinivasan <maddy@linux.vnet.ibm.com>

commit 370f06c88528b3988fe24a372c10e1303bb94cf6 upstream.

Commit 7a7868326d77 ("powerpc/perf: Add an explict flag indicating
presence of SLOT field") introduced the PPMU_HAS_SSLOT flag to remove
the assumption that MMCRA[SLOT] was present when PPMU_ALT_SIPR was not
set.

That commit's changelog also mentions that Power8 does not support
MMCRA[SLOT]. However when the Power8 PMU support was merged, it
errnoeously included the PPMU_HAS_SSLOT flag.

So remove PPMU_HAS_SSLOT from the Power8 flags.

mpe: On systems where MMCRA[SLOT] exists, the field occupies bits 37:39
(IBM numbering). On Power8 bit 37 is reserved, and 38:39 overlap with
the high bits of the Threshold Event Counter Mantissa. I am not aware of
any published events which use the threshold counting mechanism, which
would cause the mantissa bits to be set. So in practice this bug is
unlikely to trigger.

Fixes: e05b9b9e5c10 ("powerpc/perf: Power8 PMU support")
Signed-off-by: Madhavan Srinivasan <maddy@linux.vnet.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/perf/power8-pmu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/powerpc/perf/power8-pmu.c
+++ b/arch/powerpc/perf/power8-pmu.c
@@ -816,7 +816,7 @@ static struct power_pmu power8_pmu = {
 	.get_constraint		= power8_get_constraint,
 	.get_alternatives	= power8_get_alternatives,
 	.disable_pmc		= power8_disable_pmc,
-	.flags			= PPMU_HAS_SSLOT | PPMU_HAS_SIER | PPMU_ARCH_207S,
+	.flags			= PPMU_HAS_SIER | PPMU_ARCH_207S,
 	.n_generic		= ARRAY_SIZE(power8_generic_events),
 	.generic_events		= power8_generic_events,
 	.cache_events		= &power8_cache_events,


