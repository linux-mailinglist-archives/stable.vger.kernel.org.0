Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE384200D4A
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 16:57:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389974AbgFSOzb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 10:55:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:50180 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388909AbgFSOzV (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 10:55:21 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 708262168B;
        Fri, 19 Jun 2020 14:55:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592578521;
        bh=BS4vnzAaUT4xzsYKuDAQsvC3CguCsCQrniL6bIM7OmA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YtQrh2UPzvZYZAjEFlWMjMtDVZvy0ZC3krOitVd8uTBW7VTUvB+VKRnT8JZJImmq1
         p/Jb+Dfqiezm1GnNYRdCC8SDqtK17d3sP/OrM5nhJXtgsCHnUekoKLadCtWT0nmSiq
         xTCoHsy42OFeJWy9/8cpBeAQbA4++49O9I12OX7I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrew Cooper <andrew.cooper3@citrix.com>,
        Kim Phillips <kim.phillips@amd.com>,
        Borislav Petkov <bp@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 023/267] x86/cpu/amd: Make erratum #1054 a legacy erratum
Date:   Fri, 19 Jun 2020 16:30:08 +0200
Message-Id: <20200619141649.984307863@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141648.840376470@linuxfoundation.org>
References: <20200619141648.840376470@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kim Phillips <kim.phillips@amd.com>

[ Upstream commit e2abfc0448a46d8a137505aa180caf14070ec535 ]

Commit

  21b5ee59ef18 ("x86/cpu/amd: Enable the fixed Instructions Retired
		 counter IRPERF")

mistakenly added erratum #1054 as an OS Visible Workaround (OSVW) ID 0.
Erratum #1054 is not OSVW ID 0 [1], so make it a legacy erratum.

There would never have been a false positive on older hardware that
has OSVW bit 0 set, since the IRPERF feature was not available.

However, save a couple of RDMSR executions per thread, on modern
system configurations that correctly set non-zero values in their
OSVW_ID_Length MSRs.

[1] Revision Guide for AMD Family 17h Models 00h-0Fh Processors. The
revision guide is available from the bugzilla link below.

Fixes: 21b5ee59ef18 ("x86/cpu/amd: Enable the fixed Instructions Retired counter IRPERF")
Reported-by: Andrew Cooper <andrew.cooper3@citrix.com>
Signed-off-by: Kim Phillips <kim.phillips@amd.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Link: https://lkml.kernel.org/r/20200417143356.26054-1-kim.phillips@amd.com
Link: https://bugzilla.kernel.org/show_bug.cgi?id=206537
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/cpu/amd.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index 120769955687..de69090ca142 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -1122,8 +1122,7 @@ static const int amd_erratum_383[] =
 
 /* #1054: Instructions Retired Performance Counter May Be Inaccurate */
 static const int amd_erratum_1054[] =
-	AMD_OSVW_ERRATUM(0, AMD_MODEL_RANGE(0x17, 0, 0, 0x2f, 0xf));
-
+	AMD_LEGACY_ERRATUM(AMD_MODEL_RANGE(0x17, 0, 0, 0x2f, 0xf));
 
 static bool cpu_has_amd_erratum(struct cpuinfo_x86 *cpu, const int *erratum)
 {
-- 
2.25.1



