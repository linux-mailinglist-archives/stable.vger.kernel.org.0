Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F1692A5333
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 21:58:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731363AbgKCU6q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 15:58:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:33338 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733002AbgKCU6p (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 15:58:45 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2651A223C6;
        Tue,  3 Nov 2020 20:58:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604437123;
        bh=BNGxJlU3JN8csNigCSCLdPHYC1HlCwrdWfew4bNAczk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HBPaxF+P0vm4WTVyQlOJ1+8+8sX2FmcsONRUgNP7nnSj8FPnNeWqeLJ/7iHo+o80R
         qGvOH59Ys4+oplYuQo5pMFNgUOsfexufq1UAWjH5bwlFr8flITq30+UknXMl04qiXC
         kgIoZ1oM+4WC8NIPwmhZN7NUBrXgZRJAUZRZu0+k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wei Huang <wei.huang2@amd.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 5.4 117/214] acpi-cpufreq: Honor _PSD table setting on new AMD CPUs
Date:   Tue,  3 Nov 2020 21:36:05 +0100
Message-Id: <20201103203301.847395803@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203249.448706377@linuxfoundation.org>
References: <20201103203249.448706377@linuxfoundation.org>
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
@@ -688,7 +688,8 @@ static int acpi_cpufreq_cpu_init(struct
 		cpumask_copy(policy->cpus, topology_core_cpumask(cpu));
 	}
 
-	if (check_amd_hwpstate_cpu(cpu) && !acpi_pstate_strict) {
+	if (check_amd_hwpstate_cpu(cpu) && boot_cpu_data.x86 < 0x19 &&
+	    !acpi_pstate_strict) {
 		cpumask_clear(policy->cpus);
 		cpumask_set_cpu(cpu, policy->cpus);
 		cpumask_copy(data->freqdomain_cpus,


