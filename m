Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2DCB59D977
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 12:07:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236710AbiHWJWP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 05:22:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350011AbiHWJVY (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 05:21:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11F5F8B99B;
        Tue, 23 Aug 2022 01:34:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 53C5DB81C29;
        Tue, 23 Aug 2022 08:33:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD894C433B5;
        Tue, 23 Aug 2022 08:33:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661243611;
        bh=lFI0+KLWRHDwjEi/LS3WyQnU8XrSg5yvyMJoMLq3Zbg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0YghMQJSLr2xWSDFThmXLMYHzs0GJ2cvN3/BijrmLstPkyKnT6SnhldoaNoLQ0wPc
         tNnEwk+/SD/+Q3ZkkFr1S6fE5Ne1ExEt+stzHdPpUXUp5QtamzMSP8wYjkTSeokL0I
         g2f2om4XSnEGUvP9T1aNwmgVj2NTetnJ3rF7mOhY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Sudeep Holla <sudeep.holla@arm.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 302/365] ACPI: PPTT: Leave the table mapped for the runtime usage
Date:   Tue, 23 Aug 2022 10:03:23 +0200
Message-Id: <20220823080130.818824528@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080118.128342613@linuxfoundation.org>
References: <20220823080118.128342613@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sudeep Holla <sudeep.holla@arm.com>

[ Upstream commit 0c80f9e165f8f9cca743d7b6cbdb54362da297e0 ]

Currently, everytime an information needs to be fetched from the PPTT,
the table is mapped via acpi_get_table() and unmapped after the use via
acpi_put_table() which is fine. However we do this at runtime especially
when the CPU is hotplugged out and plugged in back since we re-populate
the cache topology and other information.

However, with the support to fetch LLC information from the PPTT in the
cpuhotplug path which is executed in the atomic context, it is preferred
to avoid mapping and unmapping of the PPTT for every single use as the
acpi_get_table() might sleep waiting for a mutex.

In order to avoid the same, the table is needs to just mapped once on
the boot CPU and is never unmapped allowing it to be used at runtime
with out the hassle of mapping and unmapping the table.

Reported-by: Guenter Roeck <linux@roeck-us.net>
Cc: Rafael J. Wysocki <rafael@kernel.org>
Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>

--

Hi Rafael,

Sorry to bother you again on this PPTT changes. Guenter reported an issue
with lockdep enabled in -next that include my cacheinfo/arch_topology changes
to utilise LLC from PPTT in the CPU hotplug path.

Please ack the change once you are happy so that I can get it merged with
other fixes via Greg's tree.

Regards,
Sudeep

Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Link: https://lore.kernel.org/r/20220720-arch_topo_fixes-v3-2-43d696288e84@arm.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/pptt.c | 102 ++++++++++++++++++++------------------------
 1 file changed, 47 insertions(+), 55 deletions(-)

diff --git a/drivers/acpi/pptt.c b/drivers/acpi/pptt.c
index 701f61c01359..3ad2823eb6f8 100644
--- a/drivers/acpi/pptt.c
+++ b/drivers/acpi/pptt.c
@@ -532,21 +532,37 @@ static int topology_get_acpi_cpu_tag(struct acpi_table_header *table,
 	return -ENOENT;
 }
 
+
+static struct acpi_table_header *acpi_get_pptt(void)
+{
+	static struct acpi_table_header *pptt;
+	acpi_status status;
+
+	/*
+	 * PPTT will be used at runtime on every CPU hotplug in path, so we
+	 * don't need to call acpi_put_table() to release the table mapping.
+	 */
+	if (!pptt) {
+		status = acpi_get_table(ACPI_SIG_PPTT, 0, &pptt);
+		if (ACPI_FAILURE(status))
+			acpi_pptt_warn_missing();
+	}
+
+	return pptt;
+}
+
 static int find_acpi_cpu_topology_tag(unsigned int cpu, int level, int flag)
 {
 	struct acpi_table_header *table;
-	acpi_status status;
 	int retval;
 
-	status = acpi_get_table(ACPI_SIG_PPTT, 0, &table);
-	if (ACPI_FAILURE(status)) {
-		acpi_pptt_warn_missing();
+	table = acpi_get_pptt();
+	if (!table)
 		return -ENOENT;
-	}
+
 	retval = topology_get_acpi_cpu_tag(table, cpu, level, flag);
 	pr_debug("Topology Setup ACPI CPU %d, level %d ret = %d\n",
 		 cpu, level, retval);
-	acpi_put_table(table);
 
 	return retval;
 }
@@ -567,16 +583,13 @@ static int find_acpi_cpu_topology_tag(unsigned int cpu, int level, int flag)
 static int check_acpi_cpu_flag(unsigned int cpu, int rev, u32 flag)
 {
 	struct acpi_table_header *table;
-	acpi_status status;
 	u32 acpi_cpu_id = get_acpi_id_for_cpu(cpu);
 	struct acpi_pptt_processor *cpu_node = NULL;
 	int ret = -ENOENT;
 
-	status = acpi_get_table(ACPI_SIG_PPTT, 0, &table);
-	if (ACPI_FAILURE(status)) {
-		acpi_pptt_warn_missing();
-		return ret;
-	}
+	table = acpi_get_pptt();
+	if (!table)
+		return -ENOENT;
 
 	if (table->revision >= rev)
 		cpu_node = acpi_find_processor_node(table, acpi_cpu_id);
@@ -584,8 +597,6 @@ static int check_acpi_cpu_flag(unsigned int cpu, int rev, u32 flag)
 	if (cpu_node)
 		ret = (cpu_node->flags & flag) != 0;
 
-	acpi_put_table(table);
-
 	return ret;
 }
 
@@ -604,18 +615,15 @@ int acpi_find_last_cache_level(unsigned int cpu)
 	u32 acpi_cpu_id;
 	struct acpi_table_header *table;
 	int number_of_levels = 0;
-	acpi_status status;
+
+	table = acpi_get_pptt();
+	if (!table)
+		return -ENOENT;
 
 	pr_debug("Cache Setup find last level CPU=%d\n", cpu);
 
 	acpi_cpu_id = get_acpi_id_for_cpu(cpu);
-	status = acpi_get_table(ACPI_SIG_PPTT, 0, &table);
-	if (ACPI_FAILURE(status)) {
-		acpi_pptt_warn_missing();
-	} else {
-		number_of_levels = acpi_find_cache_levels(table, acpi_cpu_id);
-		acpi_put_table(table);
-	}
+	number_of_levels = acpi_find_cache_levels(table, acpi_cpu_id);
 	pr_debug("Cache Setup find last level level=%d\n", number_of_levels);
 
 	return number_of_levels;
@@ -637,20 +645,16 @@ int acpi_find_last_cache_level(unsigned int cpu)
 int cache_setup_acpi(unsigned int cpu)
 {
 	struct acpi_table_header *table;
-	acpi_status status;
 
-	pr_debug("Cache Setup ACPI CPU %d\n", cpu);
-
-	status = acpi_get_table(ACPI_SIG_PPTT, 0, &table);
-	if (ACPI_FAILURE(status)) {
-		acpi_pptt_warn_missing();
+	table = acpi_get_pptt();
+	if (!table)
 		return -ENOENT;
-	}
+
+	pr_debug("Cache Setup ACPI CPU %d\n", cpu);
 
 	cache_setup_acpi_cpu(table, cpu);
-	acpi_put_table(table);
 
-	return status;
+	return 0;
 }
 
 /**
@@ -766,50 +770,38 @@ int find_acpi_cpu_topology_package(unsigned int cpu)
 int find_acpi_cpu_topology_cluster(unsigned int cpu)
 {
 	struct acpi_table_header *table;
-	acpi_status status;
 	struct acpi_pptt_processor *cpu_node, *cluster_node;
 	u32 acpi_cpu_id;
 	int retval;
 	int is_thread;
 
-	status = acpi_get_table(ACPI_SIG_PPTT, 0, &table);
-	if (ACPI_FAILURE(status)) {
-		acpi_pptt_warn_missing();
+	table = acpi_get_pptt();
+	if (!table)
 		return -ENOENT;
-	}
 
 	acpi_cpu_id = get_acpi_id_for_cpu(cpu);
 	cpu_node = acpi_find_processor_node(table, acpi_cpu_id);
-	if (cpu_node == NULL || !cpu_node->parent) {
-		retval = -ENOENT;
-		goto put_table;
-	}
+	if (!cpu_node || !cpu_node->parent)
+		return -ENOENT;
 
 	is_thread = cpu_node->flags & ACPI_PPTT_ACPI_PROCESSOR_IS_THREAD;
 	cluster_node = fetch_pptt_node(table, cpu_node->parent);
-	if (cluster_node == NULL) {
-		retval = -ENOENT;
-		goto put_table;
-	}
+	if (!cluster_node)
+		return -ENOENT;
+
 	if (is_thread) {
-		if (!cluster_node->parent) {
-			retval = -ENOENT;
-			goto put_table;
-		}
+		if (!cluster_node->parent)
+			return -ENOENT;
+
 		cluster_node = fetch_pptt_node(table, cluster_node->parent);
-		if (cluster_node == NULL) {
-			retval = -ENOENT;
-			goto put_table;
-		}
+		if (!cluster_node)
+			return -ENOENT;
 	}
 	if (cluster_node->flags & ACPI_PPTT_ACPI_PROCESSOR_ID_VALID)
 		retval = cluster_node->acpi_processor_id;
 	else
 		retval = ACPI_PTR_DIFF(cluster_node, table);
 
-put_table:
-	acpi_put_table(table);
-
 	return retval;
 }
 
-- 
2.35.1



