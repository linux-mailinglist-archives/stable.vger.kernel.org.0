Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35D741B3C52
	for <lists+stable@lfdr.de>; Wed, 22 Apr 2020 12:05:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728032AbgDVKEl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Apr 2020 06:04:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:55222 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726515AbgDVKEk (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Apr 2020 06:04:40 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8B3FF20776;
        Wed, 22 Apr 2020 10:04:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587549880;
        bh=xfVhNM3DhhQiAXNyN86zX53Kbc4sf7pftZqBgdUJKVM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qBHXZ3w1qBkGhI/kjrSknQksPi7RS7YXTn8NnjXolejdFuR1VRawOZAOcVs8C9MdY
         4PbCJMOfMt98wex7DaRMq8NKnrn1lTT1jBAGzGbvuv3ABYT51UppuKkp0cpf7fRdMz
         voYWQvHP+CNPnt5/Uwtjt/UefE177i48bEUlbffk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhenzhong Duan <zhenzhong.duan@oracle.com>,
        Thomas Gleixner <tglx@linutronix.de>, konrad.wilk@oracle.com,
        dwmw@amazon.co.uk, bp@suse.de, srinivas.eeda@oracle.com,
        peterz@infradead.org, hpa@zytor.com,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 4.9 043/125] x86/speculation: Remove redundant arch_smt_update() invocation
Date:   Wed, 22 Apr 2020 11:56:00 +0200
Message-Id: <20200422095040.483696912@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200422095032.909124119@linuxfoundation.org>
References: <20200422095032.909124119@linuxfoundation.org>
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
@@ -2027,10 +2027,8 @@ int cpuhp_smt_disable(enum cpuhp_smt_con
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
@@ -2041,7 +2039,6 @@ int cpuhp_smt_enable(void)
 
 	cpu_maps_update_begin();
 	cpu_smt_control = CPU_SMT_ENABLED;
-	arch_smt_update();
 	for_each_present_cpu(cpu) {
 		/* Skip online CPUs and CPUs on offline nodes */
 		if (cpu_online(cpu) || !node_online(cpu_to_node(cpu)))


