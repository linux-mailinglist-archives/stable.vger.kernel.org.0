Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A1486D9EE7
	for <lists+stable@lfdr.de>; Thu, 17 Oct 2019 00:04:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392039AbfJPWDX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Oct 2019 18:03:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:54254 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2438509AbfJPV71 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 16 Oct 2019 17:59:27 -0400
Received: from localhost (unknown [192.55.54.58])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5B577222C4;
        Wed, 16 Oct 2019 21:59:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571263166;
        bh=jphSXo0H1nebo1iEBpk4uSYr10SEphXsBJeMQa/Sj7Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eGjPv8ORLePAQGE8i7hsA5SEdvSP6KpHcPpvCAmjihe+6bfJt3jzEhNIQ0Ys7onqj
         OsFm1XUZ/f7PgyTV3Zbynpx9M4lJisCwNhsW54IyjiC7ZCB8pc5/cmpR/5HkbR80gu
         6LLqB7NUCnQlIHUZT/X5M6BCBGpmTBAPLlKGC5Io=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jeremy Linton <jeremy.linton@arm.com>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Robert Richter <rrichter@marvell.com>,
        Will Deacon <will@kernel.org>,
        John Garry <john.garry@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 094/112] arm64: topology: Use PPTT to determine if PE is a thread
Date:   Wed, 16 Oct 2019 14:51:26 -0700
Message-Id: <20191016214905.788832630@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191016214844.038848564@linuxfoundation.org>
References: <20191016214844.038848564@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jeremy Linton <jeremy.linton@arm.com>

Commit 98dc19902a0b2e5348e43d6a2c39a0a7d0fc639e upstream.

ACPI 6.3 adds a thread flag to represent if a CPU/PE is
actually a thread. Given that the MPIDR_MT bit may not
represent this information consistently on homogeneous machines
we should prefer the PPTT flag if its available.

Signed-off-by: Jeremy Linton <jeremy.linton@arm.com>
Reviewed-by: Sudeep Holla <sudeep.holla@arm.com>
Reviewed-by: Robert Richter <rrichter@marvell.com>
[will: made acpi_cpu_is_threaded() return 'bool']
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: John Garry <john.garry@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kernel/topology.c | 19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kernel/topology.c b/arch/arm64/kernel/topology.c
index 0825c4a856e33..6106c49f84bc8 100644
--- a/arch/arm64/kernel/topology.c
+++ b/arch/arm64/kernel/topology.c
@@ -340,17 +340,28 @@ void remove_cpu_topology(unsigned int cpu)
 }
 
 #ifdef CONFIG_ACPI
+static bool __init acpi_cpu_is_threaded(int cpu)
+{
+	int is_threaded = acpi_pptt_cpu_is_thread(cpu);
+
+	/*
+	 * if the PPTT doesn't have thread information, assume a homogeneous
+	 * machine and return the current CPU's thread state.
+	 */
+	if (is_threaded < 0)
+		is_threaded = read_cpuid_mpidr() & MPIDR_MT_BITMASK;
+
+	return !!is_threaded;
+}
+
 /*
  * Propagate the topology information of the processor_topology_node tree to the
  * cpu_topology array.
  */
 static int __init parse_acpi_topology(void)
 {
-	bool is_threaded;
 	int cpu, topology_id;
 
-	is_threaded = read_cpuid_mpidr() & MPIDR_MT_BITMASK;
-
 	for_each_possible_cpu(cpu) {
 		int i, cache_id;
 
@@ -358,7 +369,7 @@ static int __init parse_acpi_topology(void)
 		if (topology_id < 0)
 			return topology_id;
 
-		if (is_threaded) {
+		if (acpi_cpu_is_threaded(cpu)) {
 			cpu_topology[cpu].thread_id = topology_id;
 			topology_id = find_acpi_cpu_topology(cpu, 1);
 			cpu_topology[cpu].core_id   = topology_id;
-- 
2.20.1



