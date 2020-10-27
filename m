Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8995529B3C0
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 15:56:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1780435AbgJ0Oyo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 10:54:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:51230 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1773324AbgJ0Ovy (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:51:54 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D5D6520773;
        Tue, 27 Oct 2020 14:51:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603810313;
        bh=17ltTOW3xQWlwxsBLOzWUTr6vVf5JXXPWiafs6S0IyM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uN7WV3IurYmwNE3aCraxYPCAb8jlz9pWq4E1J93aXsbg0QYSyu2Owq/OWI/lP/DtB
         lfusBbPAH6/Kn6ptmXS7gKzbLvpjlKT8e7xa2ZxLoS+5Si1CBd2vxjhDKyslm6SjMV
         pHriC/G4GgL8/OYcanFqLUgDDNcaDp9riWVbcypY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kan Liang <kan.liang@linux.intel.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 095/633] perf/x86/intel/uncore: Fix the scale of the IMC free-running events
Date:   Tue, 27 Oct 2020 14:47:18 +0100
Message-Id: <20201027135527.160654738@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135522.655719020@linuxfoundation.org>
References: <20201027135522.655719020@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kan Liang <kan.liang@linux.intel.com>

[ Upstream commit 8191016a026b8dfbb14dea64efc8e723ee99fe65 ]

The "MiB" result of the IMC free-running bandwidth events,
uncore_imc_free_running/read/ and uncore_imc_free_running/write/ are 16
times too small.

The "MiB" value equals the raw IMC free-running bandwidth counter value
times a "scale" which is inaccurate.

The IMC free-running bandwidth events should be incremented per 64B
cache line, not DWs (4 bytes). The "scale" should be 6.103515625e-5.
Fix the "scale" for both Snow Ridge and Ice Lake.

Fixes: 2b3b76b5ec67 ("perf/x86/intel/uncore: Add Ice Lake server uncore support")
Fixes: ee49532b38dd ("perf/x86/intel/uncore: Add IMC uncore support for Snow Ridge")
Signed-off-by: Kan Liang <kan.liang@linux.intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lkml.kernel.org/r/20200928133240.12977-1-kan.liang@linux.intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/events/intel/uncore_snbep.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/x86/events/intel/uncore_snbep.c b/arch/x86/events/intel/uncore_snbep.c
index 07652fa20ebbe..6a03fe8054a81 100644
--- a/arch/x86/events/intel/uncore_snbep.c
+++ b/arch/x86/events/intel/uncore_snbep.c
@@ -4550,10 +4550,10 @@ static struct uncore_event_desc snr_uncore_imc_freerunning_events[] = {
 	INTEL_UNCORE_EVENT_DESC(dclk,		"event=0xff,umask=0x10"),
 
 	INTEL_UNCORE_EVENT_DESC(read,		"event=0xff,umask=0x20"),
-	INTEL_UNCORE_EVENT_DESC(read.scale,	"3.814697266e-6"),
+	INTEL_UNCORE_EVENT_DESC(read.scale,	"6.103515625e-5"),
 	INTEL_UNCORE_EVENT_DESC(read.unit,	"MiB"),
 	INTEL_UNCORE_EVENT_DESC(write,		"event=0xff,umask=0x21"),
-	INTEL_UNCORE_EVENT_DESC(write.scale,	"3.814697266e-6"),
+	INTEL_UNCORE_EVENT_DESC(write.scale,	"6.103515625e-5"),
 	INTEL_UNCORE_EVENT_DESC(write.unit,	"MiB"),
 	{ /* end: all zeroes */ },
 };
@@ -5009,17 +5009,17 @@ static struct uncore_event_desc icx_uncore_imc_freerunning_events[] = {
 	INTEL_UNCORE_EVENT_DESC(dclk,			"event=0xff,umask=0x10"),
 
 	INTEL_UNCORE_EVENT_DESC(read,			"event=0xff,umask=0x20"),
-	INTEL_UNCORE_EVENT_DESC(read.scale,		"3.814697266e-6"),
+	INTEL_UNCORE_EVENT_DESC(read.scale,		"6.103515625e-5"),
 	INTEL_UNCORE_EVENT_DESC(read.unit,		"MiB"),
 	INTEL_UNCORE_EVENT_DESC(write,			"event=0xff,umask=0x21"),
-	INTEL_UNCORE_EVENT_DESC(write.scale,		"3.814697266e-6"),
+	INTEL_UNCORE_EVENT_DESC(write.scale,		"6.103515625e-5"),
 	INTEL_UNCORE_EVENT_DESC(write.unit,		"MiB"),
 
 	INTEL_UNCORE_EVENT_DESC(ddrt_read,		"event=0xff,umask=0x30"),
-	INTEL_UNCORE_EVENT_DESC(ddrt_read.scale,	"3.814697266e-6"),
+	INTEL_UNCORE_EVENT_DESC(ddrt_read.scale,	"6.103515625e-5"),
 	INTEL_UNCORE_EVENT_DESC(ddrt_read.unit,		"MiB"),
 	INTEL_UNCORE_EVENT_DESC(ddrt_write,		"event=0xff,umask=0x31"),
-	INTEL_UNCORE_EVENT_DESC(ddrt_write.scale,	"3.814697266e-6"),
+	INTEL_UNCORE_EVENT_DESC(ddrt_write.scale,	"6.103515625e-5"),
 	INTEL_UNCORE_EVENT_DESC(ddrt_write.unit,	"MiB"),
 	{ /* end: all zeroes */ },
 };
-- 
2.25.1



