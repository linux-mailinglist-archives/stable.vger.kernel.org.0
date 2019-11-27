Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D301D10B7A2
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 21:35:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727905AbfK0Uff (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 15:35:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:36908 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727884AbfK0Uff (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 15:35:35 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 12D1120866;
        Wed, 27 Nov 2019 20:35:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574886934;
        bh=KBTbvLDdWuDQ8X00mqs8/tL1VrZWLuSyGoaJhrKpYdY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R1WYcpw9I2992YS6FVB2mZmJ37DCTKPqBHylD9Yvk90yn3w7oA26XlaSIHFwfRIPn
         nwSLc1EfmrsESJW1u927+12qOfAJ/Fo5vyom1DRvCtpxzzySDBcZFIh5VUd31hvB7q
         l7vh5uHOcmJIaT6Rlf/hX9FUFkKAViq5XORs3BOY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thomas Richter <tmricht@linux.ibm.com>,
        Hendrik Brueckner <brueckner@linux.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 049/132] s390/perf: Return error when debug_register fails
Date:   Wed, 27 Nov 2019 21:30:40 +0100
Message-Id: <20191127202946.781053509@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127202857.270233486@linuxfoundation.org>
References: <20191127202857.270233486@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Richter <tmricht@linux.ibm.com>

[ Upstream commit ec0c0bb489727de0d4dca6a00be6970ab8a3b30a ]

Return an error when the function debug_register() fails allocating
the debug handle.
Also remove the registered debug handle when the initialization fails
later on.

Signed-off-by: Thomas Richter <tmricht@linux.ibm.com>
Reviewed-by: Hendrik Brueckner <brueckner@linux.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/kernel/perf_cpum_sf.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/s390/kernel/perf_cpum_sf.c b/arch/s390/kernel/perf_cpum_sf.c
index b79d51459cf25..874762a51c546 100644
--- a/arch/s390/kernel/perf_cpum_sf.c
+++ b/arch/s390/kernel/perf_cpum_sf.c
@@ -1616,14 +1616,17 @@ static int __init init_cpum_sampling_pmu(void)
 	}
 
 	sfdbg = debug_register(KMSG_COMPONENT, 2, 1, 80);
-	if (!sfdbg)
+	if (!sfdbg) {
 		pr_err("Registering for s390dbf failed\n");
+		return -ENOMEM;
+	}
 	debug_register_view(sfdbg, &debug_sprintf_view);
 
 	err = register_external_irq(EXT_IRQ_MEASURE_ALERT,
 				    cpumf_measurement_alert);
 	if (err) {
 		pr_cpumsf_err(RS_INIT_FAILURE_ALRT);
+		debug_unregister(sfdbg);
 		goto out;
 	}
 
@@ -1632,6 +1635,7 @@ static int __init init_cpum_sampling_pmu(void)
 		pr_cpumsf_err(RS_INIT_FAILURE_PERF);
 		unregister_external_irq(EXT_IRQ_MEASURE_ALERT,
 					cpumf_measurement_alert);
+		debug_unregister(sfdbg);
 		goto out;
 	}
 	perf_cpu_notifier(cpumf_pmu_notifier);
-- 
2.20.1



