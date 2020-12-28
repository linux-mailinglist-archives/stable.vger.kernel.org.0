Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E8882E3E35
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:25:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503197AbgL1OZe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:25:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:33394 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2503227AbgL1OZc (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:25:32 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 75533207B2;
        Mon, 28 Dec 2020 14:24:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609165492;
        bh=Xjz8+OH5Ona2jTTT8r968UgwEppVQN3XhLZuh1uymeo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Qnlg3Wb0XznBR5sXNTzlcGc3ZYjPiNsJJzrE49vRvCYquWwdnhnApTnUalxYXurHK
         2qMcekB6KZl8j9/b/c/jXVRsSgsjBTjC4Nvp3QkTh5o2HTZV55zJodz/ZyJSlWwXhN
         Nbc00kU8qw7dnPcYtNSJXkMTjKAQ8SXUOMlSv66Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Heiko Carstens <hca@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>, stable@kernel.org
Subject: [PATCH 5.10 551/717] s390/smp: perform initial CPU reset also for SMT siblings
Date:   Mon, 28 Dec 2020 13:49:09 +0100
Message-Id: <20201228125047.332418323@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
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
@@ -896,24 +896,12 @@ static void __no_sanitize_address smp_st
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
 


