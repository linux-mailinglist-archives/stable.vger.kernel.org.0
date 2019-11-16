Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 562C0FED45
	for <lists+stable@lfdr.de>; Sat, 16 Nov 2019 16:45:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728497AbfKPPmx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 16 Nov 2019 10:42:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:46626 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728477AbfKPPmv (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 16 Nov 2019 10:42:51 -0500
Received: from sasha-vm.mshome.net (unknown [50.234.116.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2658620740;
        Sat, 16 Nov 2019 15:42:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573918970;
        bh=gjuzvXyhWRsXKjSOSgKr4qFWVX5/LvmJynn27rqTZCU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KST8cLQvvEOeTaMOFk0K1Jy/FOLdYYZSfxSgNn+K3KO794RZa9ThxnmSlKoCeE+bR
         LSWu6d5ul6GgOhFtH4dYTkKhL0mxEHSRkAP5xFBuiPiNrxdtH2F6ywemPSbUk/4B7e
         uOrWAxcPirZOFuxr5jRBDCJfZpQC8L51Yolsv43A=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Thomas Richter <tmricht@linux.ibm.com>,
        Hendrik Brueckner <brueckner@linux.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Sasha Levin <sashal@kernel.org>, linux-s390@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 085/237] s390/perf: Return error when debug_register fails
Date:   Sat, 16 Nov 2019 10:38:40 -0500
Message-Id: <20191116154113.7417-85-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191116154113.7417-1-sashal@kernel.org>
References: <20191116154113.7417-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index 44404836e9d11..df92c2af99b69 100644
--- a/arch/s390/kernel/perf_cpum_sf.c
+++ b/arch/s390/kernel/perf_cpum_sf.c
@@ -2045,14 +2045,17 @@ static int __init init_cpum_sampling_pmu(void)
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
 
@@ -2061,6 +2064,7 @@ static int __init init_cpum_sampling_pmu(void)
 		pr_cpumsf_err(RS_INIT_FAILURE_PERF);
 		unregister_external_irq(EXT_IRQ_MEASURE_ALERT,
 					cpumf_measurement_alert);
+		debug_unregister(sfdbg);
 		goto out;
 	}
 
-- 
2.20.1

