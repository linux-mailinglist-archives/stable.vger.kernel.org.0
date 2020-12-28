Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 877EA2E3A2D
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 14:34:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390290AbgL1NdF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:33:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:33044 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387827AbgL1NdA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:33:00 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 78D712072C;
        Mon, 28 Dec 2020 13:32:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609162365;
        bh=DqaDuenVWDuPim+nlw0OQY6Pd9PF9YPO0SjC34NwOXQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Cg5M/3qgGwQk3VSCX1dDwtD8wJ7hdQiSo+Ae/W/U87PBeI59XHg6H/5hwSwQdtIEK
         yvx3MLzycv2ugSDf/3102MMNde1YeJ/6sV09wtgGdWhd1FkKTqg1TJUIlgC2ChNZSW
         /CCnNbG7HxrkZU3LSXFVOyWAZNcfaDSVFDMf5OJE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Heiko Carstens <hca@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>, stable@kernel.org
Subject: [PATCH 4.19 279/346] s390/smp: perform initial CPU reset also for SMT siblings
Date:   Mon, 28 Dec 2020 13:49:58 +0100
Message-Id: <20201228124933.267704720@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124919.745526410@linuxfoundation.org>
References: <20201228124919.745526410@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sven Schnelle <svens@linux.ibm.com>

commit b5e438ebd7e808d1d2435159ac4742e01a94b8da upstream.

Not resetting the SMT siblings might leave them in unpredictable
state. One of the observed problems was that the CPU timer wasn't
reset and therefore large system time values where accounted during
CPU bringup.

Cc: <stable@kernel.org> # 4.0
Fixes: 10ad34bc76dfb ("s390: add SMT support")
Reviewed-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Sven Schnelle <svens@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/s390/kernel/smp.c |   18 +++---------------
 1 file changed, 3 insertions(+), 15 deletions(-)

--- a/arch/s390/kernel/smp.c
+++ b/arch/s390/kernel/smp.c
@@ -863,24 +863,12 @@ static void smp_start_secondary(void *cp
 /* Upping and downing of CPUs */
 int __cpu_up(unsigned int cpu, struct task_struct *tidle)
 {
-	struct pcpu *pcpu;
-	int base, i, rc;
+	struct pcpu *pcpu = pcpu_devices + cpu;
+	int rc;
 
-	pcpu = pcpu_devices + cpu;
 	if (pcpu->state != CPU_STATE_CONFIGURED)
 		return -EIO;
-	base = smp_get_base_cpu(cpu);
-	for (i = 0; i <= smp_cpu_mtid; i++) {
-		if (base + i < nr_cpu_ids)
-			if (cpu_online(base + i))
-				break;
-	}
-	/*
-	 * If this is the first CPU of the core to get online
-	 * do an initial CPU reset.
-	 */
-	if (i > smp_cpu_mtid &&
-	    pcpu_sigp_retry(pcpu_devices + base, SIGP_INITIAL_CPU_RESET, 0) !=
+	if (pcpu_sigp_retry(pcpu, SIGP_INITIAL_CPU_RESET, 0) !=
 	    SIGP_CC_ORDER_CODE_ACCEPTED)
 		return -EIO;
 


