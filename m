Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D2322A54DD
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 22:15:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389083AbgKCVMu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 16:12:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:55384 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389082AbgKCVMs (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 16:12:48 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 958F421534;
        Tue,  3 Nov 2020 21:12:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604437968;
        bh=/T3SJ1buyA6YHXT6XGq5baauNt1qHSf3vwSNRPlvzJw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MDwbxkxqGr69h5NAt9GVmEb6kymrofBpM4m1QxTrgZaQM5hL3OOVhN5cNN8hilPMn
         FarXa8q5uQB5RbGI6WcJQq3s6H4FAoacXasjJ7psJwR/rMHIBfWVimz5yPtL/FVuLa
         zTO5TpIbbeXp0SDle26/BHcp/UC6RRNvseyuCc7c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wei Huang <wei.huang2@amd.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 4.14 070/125] acpi-cpufreq: Honor _PSD table setting on new AMD CPUs
Date:   Tue,  3 Nov 2020 21:37:27 +0100
Message-Id: <20201103203207.027912350@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203156.372184213@linuxfoundation.org>
References: <20201103203156.372184213@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wei Huang <wei.huang2@amd.com>

commit 5368512abe08a28525d9b24abbfc2a72493e8dba upstream.

acpi-cpufreq has a old quirk that overrides the _PSD table supplied by
BIOS on AMD CPUs. However the _PSD table of new AMD CPUs (Family 19h+)
now accurately reports the P-state dependency of CPU cores. Hence this
quirk needs to be fixed in order to support new CPUs' frequency control.

Fixes: acd316248205 ("acpi-cpufreq: Add quirk to disable _PSD usage on all AMD CPUs")
Signed-off-by: Wei Huang <wei.huang2@amd.com>
[ rjw: Subject edit ]
Cc: 3.10+ <stable@vger.kernel.org> # 3.10+
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/cpufreq/acpi-cpufreq.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/cpufreq/acpi-cpufreq.c
+++ b/drivers/cpufreq/acpi-cpufreq.c
@@ -701,7 +701,8 @@ static int acpi_cpufreq_cpu_init(struct
 		cpumask_copy(policy->cpus, topology_core_cpumask(cpu));
 	}
 
-	if (check_amd_hwpstate_cpu(cpu) && !acpi_pstate_strict) {
+	if (check_amd_hwpstate_cpu(cpu) && boot_cpu_data.x86 < 0x19 &&
+	    !acpi_pstate_strict) {
 		cpumask_clear(policy->cpus);
 		cpumask_set_cpu(cpu, policy->cpus);
 		cpumask_copy(data->freqdomain_cpus,


