Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E350B141655
	for <lists+stable@lfdr.de>; Sat, 18 Jan 2020 08:27:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726046AbgARH1Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 18 Jan 2020 02:27:16 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:9188 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725913AbgARH1Q (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 18 Jan 2020 02:27:16 -0500
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 1F2C57E85339D3B5DA16;
        Sat, 18 Jan 2020 15:27:12 +0800 (CST)
Received: from huawei.com (10.175.104.201) by DGGEMS404-HUB.china.huawei.com
 (10.3.19.204) with Microsoft SMTP Server id 14.3.439.0; Sat, 18 Jan 2020
 15:27:04 +0800
From:   Miaohe Lin <linmiaohe@huawei.com>
To:     <linmiaohe@huawei.com>
CC:     Stefan Berger <stefanb@linux.ibm.com>, <stable@vger.kernel.org>,
        "Jerry Snitselaar" <jsnitsel@redhat.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: [PATCH] tpm: Revert "tpm_tis_core: Set TPM_CHIP_FLAG_IRQ before probing for interrupts"
Date:   Sat, 18 Jan 2020 15:25:44 -0500
Message-ID: <20200118202544.14523-1-linmiaohe@huawei.com>
X-Mailer: git-send-email 2.19.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.104.201]
X-CFilter-Loop: Reflected
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stefan Berger <stefanb@linux.ibm.com>

There has been a bunch of reports (one from kernel bugzilla linked)
reporting that when this commit is applied it causes on some machines
boot freezes.

Unfortunately hardware where this commit causes a failure is not widely
available (only one I'm aware is Lenovo T490), which means we cannot
predict yet how long it will take to properly fix tpm_tis interrupt
probing.

Thus, the least worst short term action is to revert the code to the
state before this commit. In long term we need fix the tpm_tis probing
code to work on machines that Stefan's fix was supposed to fix.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=205935
Fixes: 1ea32c83c699 ("tpm_tis_core: Set TPM_CHIP_FLAG_IRQ before probing for interrupts")
Cc: stable@vger.kernel.org
Cc: Jerry Snitselaar <jsnitsel@redhat.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Tested-by: Dan Williams <dan.j.williams@intel.com>
Tested-by: Xiaoping Zhou <xiaoping.zhou@intel.com>
Signed-off-by: Stefan Berger <stefanb@linux.ibm.com>
Reported-by: Jerry Snitselaar <jsnitsel@redhat.com>
Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
---
 drivers/char/tpm/tpm_tis_core.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/char/tpm/tpm_tis_core.c b/drivers/char/tpm/tpm_tis_core.c
index 8af2cee1a762..5dc52c4e2292 100644
--- a/drivers/char/tpm/tpm_tis_core.c
+++ b/drivers/char/tpm/tpm_tis_core.c
@@ -1060,7 +1060,6 @@ int tpm_tis_core_init(struct device *dev, struct tpm_tis_data *priv, int irq,
 		}
 
 		tpm_chip_start(chip);
-		chip->flags |= TPM_CHIP_FLAG_IRQ;
 		if (irq) {
 			tpm_tis_probe_irq_single(chip, intmask, IRQF_SHARED,
 						 irq);
-- 
2.19.1

