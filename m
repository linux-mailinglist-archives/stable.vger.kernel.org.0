Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CC604624FF
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 23:31:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232355AbhK2Wdo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 17:33:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232372AbhK2WdP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 17:33:15 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA18BC048F6A;
        Mon, 29 Nov 2021 10:40:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B16EAB815DB;
        Mon, 29 Nov 2021 18:40:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E51BCC53FAD;
        Mon, 29 Nov 2021 18:40:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638211253;
        bh=CuoBtfr8sSu/ICuzhSj+5tqagpByUgHCditnFKpAqvU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0XBcThr5Jl5r3z3jiFFYQT5hXTf3glCTFtx56mC8auns6HNy6Bm/oATH696/6Nlro
         h0VzL8SdbSDNjkwJcT3WRQRyXYTenxFVc0XcCteHQKhrn/QtRezT82Zpq4pkzdnXBw
         cFMJIaKj+9D0Tkaa5OQEsGpJ+6U9nJysVhoMV9qc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Adamos Ttofari <attofari@amazon.de>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 125/179] cpufreq: intel_pstate: Add Ice Lake server to out-of-band IDs
Date:   Mon, 29 Nov 2021 19:18:39 +0100
Message-Id: <20211129181723.073804824@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211129181718.913038547@linuxfoundation.org>
References: <20211129181718.913038547@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Adamos Ttofari <attofari@amazon.de>

[ Upstream commit cd23f02f166892603eb9f2d488152b975872b682 ]

Commit fbdc21e9b038 ("cpufreq: intel_pstate: Add Icelake servers
support in no-HWP mode") enabled the use of Intel P-State driver
for Ice Lake servers.

But it doesn't cover the case when OS can't control P-States.

Therefore, for Ice Lake server, if MSR_MISC_PWR_MGMT bits 8 or 18
are enabled, then the Intel P-State driver should exit as OS can't
control P-States.

Fixes: fbdc21e9b038 ("cpufreq: intel_pstate: Add Icelake servers support in no-HWP mode")
Signed-off-by: Adamos Ttofari <attofari@amazon.de>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/intel_pstate.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/cpufreq/intel_pstate.c b/drivers/cpufreq/intel_pstate.c
index 3e56a4a1d1d3a..e15c3bc17a55c 100644
--- a/drivers/cpufreq/intel_pstate.c
+++ b/drivers/cpufreq/intel_pstate.c
@@ -2255,6 +2255,7 @@ static const struct x86_cpu_id intel_pstate_cpu_oob_ids[] __initconst = {
 	X86_MATCH(BROADWELL_D,		core_funcs),
 	X86_MATCH(BROADWELL_X,		core_funcs),
 	X86_MATCH(SKYLAKE_X,		core_funcs),
+	X86_MATCH(ICELAKE_X,		core_funcs),
 	{}
 };
 
-- 
2.33.0



