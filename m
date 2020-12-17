Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33B662DDA85
	for <lists+stable@lfdr.de>; Thu, 17 Dec 2020 22:04:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731672AbgLQVEh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Dec 2020 16:04:37 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:38856 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731327AbgLQVEh (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Dec 2020 16:04:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1608238991;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=LDk3al9WN9CjrSshmYFpMOAVo+EkiN7I7g+n8jNbjPU=;
        b=VovQIHkfMqk0s2CYUkWhhff5/q38XiszST8LPqYqUGT7bambBK3mffq9cHmOVDEkTrLEYW
        13QqqKH/afJKj4DqtP52yXB4vJgRdoDJxRwak6RO6u8fZRrIarpqo+Ny7m4cgGwYFoIBP/
        wNnRFq72clDtVuTnhl7c+lq6W//UxyE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-547-EHZetAnpMZisEy-Lb6axRQ-1; Thu, 17 Dec 2020 16:03:07 -0500
X-MC-Unique: EHZetAnpMZisEy-Lb6axRQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 868133E75F;
        Thu, 17 Dec 2020 21:03:05 +0000 (UTC)
Received: from dhcp16-201-106.khw1.lab.eng.bos.redhat.com (dhcp16-201-106.khw1.lab.eng.bos.redhat.com [10.16.201.106])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4C3F65D9D2;
        Thu, 17 Dec 2020 21:03:01 +0000 (UTC)
From:   Terry Bowman <tbowman@redhat.com>
To:     ahs3@redhat.com, lszubowi@redhat.com, prarit@redhat.com,
        darcari@redhat.com, WeHuang@redhat.com
Cc:     rhkernel-list@redhat.com, Wei Huang <wei.huang2@amd.com>,
        "3 . 10+" <stable@vger.kernel.org>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Terry Bowman <tbowman@redhat.com>
Subject: [RHEL8.4 bz1886943] acpi-cpufreq: Honor _PSD table setting on new AMD CPUs
Date:   Thu, 17 Dec 2020 16:01:20 -0500
Message-Id: <20201217210120.912748-1-tbowman@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Bugzilla: http://bugzilla.redhat.com/1886943
Brew: https://brewweb.engineering.redhat.com/brew/taskinfo?taskID=33761621
Upstream: 5.10-rc, https://lkml.org/lkml/2020/10/19/488
Test: Manual testing looking for PSD override in dmesg.
Using amd-daytona-01.khw1.lab.eng.bos.redhat.com, EPYC Milan

commit 5368512abe08 ("acpi-cpufreq: Honor _PSD table setting on new AMD CPUs")
Author: Wei Huang <wei.huang2@amd.com>
Date:   Sun Oct 18 22:57:41 2020 -0500

    acpi-cpufreq: Honor _PSD table setting on new AMD CPUs

    acpi-cpufreq has a old quirk that overrides the _PSD table supplied by
    BIOS on AMD CPUs. However the _PSD table of new AMD CPUs (Family 19h+)
    now accurately reports the P-state dependency of CPU cores. Hence this
    quirk needs to be fixed in order to support new CPUs' frequency
    control.

Fixes: acd316248205 ("acpi-cpufreq: Add quirk to disable _PSD usage on all AMD CPUs")
Signed-off-by: Wei Huang <wei.huang2@amd.com>
[ rjw: Subject edit ]
Cc: 3.10+ <stable@vger.kernel.org> # 3.10+
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
[ tb: reformat for checkpatch ]
Signed-off-by: Terry Bowman <tbowman@redhat.com>

Cc: Al Stone <ahs3@redhat.com> 
Cc: Lenny Szubowicz <lszubowi@redhat.com> 
Cc: Prarit Bhargava <prarit@redhat.com> 
Cc: David Arcari <darcari@redhat.com> 
---
 drivers/cpufreq/acpi-cpufreq.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/cpufreq/acpi-cpufreq.c b/drivers/cpufreq/acpi-cpufreq.c
index 2705b4c86a83..3a4efb282807 100644
--- a/drivers/cpufreq/acpi-cpufreq.c
+++ b/drivers/cpufreq/acpi-cpufreq.c
@@ -686,7 +686,8 @@ static int acpi_cpufreq_cpu_init(struct cpufreq_policy *policy)
 		cpumask_copy(policy->cpus, topology_core_cpumask(cpu));
 	}
 
-	if (check_amd_hwpstate_cpu(cpu) && !acpi_pstate_strict) {
+	if (check_amd_hwpstate_cpu(cpu) && boot_cpu_data.x86 < 0x19 &&
+	    !acpi_pstate_strict) {
 		cpumask_clear(policy->cpus);
 		cpumask_set_cpu(cpu, policy->cpus);
 		cpumask_copy(data->freqdomain_cpus,
-- 
2.27.0

