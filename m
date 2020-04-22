Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8ACC31B4166
	for <lists+stable@lfdr.de>; Wed, 22 Apr 2020 12:52:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729078AbgDVKKr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Apr 2020 06:10:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:41118 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728533AbgDVKKq (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Apr 2020 06:10:46 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 98B532071E;
        Wed, 22 Apr 2020 10:10:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587550246;
        bh=jjGhZd1676gM1faEzaRyv70Uy8sPoRRPSl6ORlKF1AQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VefO1/OQiqXosLSb0P/Nw+oaIfNc9v3tyTZnIsJ6UlLuhYHfv2PBjOvbdQp/YE7Ea
         yimFnMgIB4iD4vI2Zk1wlsYYZ8SC4o/E3GRgZY81P0j+0Ni5U8bA7JkdF9DmouMXFb
         VrYU9zm28O3KeQI0AVIN2stwgRbWk4wMBFUyZ900=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhenzhong Duan <zhenzhong.duan@oracle.com>,
        Thomas Gleixner <tglx@linutronix.de>, konrad.wilk@oracle.com,
        dwmw@amazon.co.uk, bp@suse.de, srinivas.eeda@oracle.com,
        peterz@infradead.org, hpa@zytor.com,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 4.14 069/199] x86/speculation: Remove redundant arch_smt_update() invocation
Date:   Wed, 22 Apr 2020 11:56:35 +0200
Message-Id: <20200422095105.093919891@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200422095057.806111593@linuxfoundation.org>
References: <20200422095057.806111593@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhenzhong Duan <zhenzhong.duan@oracle.com>

commit 34d66caf251df91ff27b24a3a786810d29989eca upstream.

With commit a74cfffb03b7 ("x86/speculation: Rework SMT state change"),
arch_smt_update() is invoked from each individual CPU hotplug function.

Therefore the extra arch_smt_update() call in the sysfs SMT control is
redundant.

Fixes: a74cfffb03b7 ("x86/speculation: Rework SMT state change")
Signed-off-by: Zhenzhong Duan <zhenzhong.duan@oracle.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: <konrad.wilk@oracle.com>
Cc: <dwmw@amazon.co.uk>
Cc: <bp@suse.de>
Cc: <srinivas.eeda@oracle.com>
Cc: <peterz@infradead.org>
Cc: <hpa@zytor.com>
Link: https://lkml.kernel.org/r/e2e064f2-e8ef-42ca-bf4f-76b612964752@default
Cc: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/cpu.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -2089,10 +2089,8 @@ int cpuhp_smt_disable(enum cpuhp_smt_con
 		 */
 		cpuhp_offline_cpu_device(cpu);
 	}
-	if (!ret) {
+	if (!ret)
 		cpu_smt_control = ctrlval;
-		arch_smt_update();
-	}
 	cpu_maps_update_done();
 	return ret;
 }
@@ -2103,7 +2101,6 @@ int cpuhp_smt_enable(void)
 
 	cpu_maps_update_begin();
 	cpu_smt_control = CPU_SMT_ENABLED;
-	arch_smt_update();
 	for_each_present_cpu(cpu) {
 		/* Skip online CPUs and CPUs on offline nodes */
 		if (cpu_online(cpu) || !node_online(cpu_to_node(cpu)))


