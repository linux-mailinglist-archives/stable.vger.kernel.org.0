Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7C8B30CEC6
	for <lists+stable@lfdr.de>; Tue,  2 Feb 2021 23:25:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233561AbhBBWZ2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Feb 2021 17:25:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:37148 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235173AbhBBWX0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Feb 2021 17:23:26 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id EF22264DE7;
        Tue,  2 Feb 2021 22:22:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612304565;
        bh=FQ7ij3jcgTLtPd0I3aD7MuqjxzjRngmZ5KWMJmsiHi8=;
        h=From:To:Cc:Subject:Date:From;
        b=njmYSoXbYWtsVxVLVHFZeAtsPim9spqoYLSXhz/abFBLeITXTfIxH24UObim5ZrpV
         WyyimTz/bhTxBlEPUuo1Qh9GVpdYKW14IafAfEXJCTiA74SOeoiX6Sgs/iN8JOO9yS
         vGnktms5EWtCFKEc4xLz7KUo0ERSC+4PvaW7UkCOgffXd12+CqddyXP3ca307dbgcY
         IHKqzaNZrcXGtBiBCHr6/bmwWMG0psST5Q0YNVMIwoxZkDEebruw0LRXhxK/wLh8I3
         hQnZDnRNsVi1xnk7Mh4OJ8CL4kYBJIV5qbqkv8j1Y7o8cfJsOWmZVUJdnf6Oh1zpdF
         lG35wohGFp2lg==
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     linux-integrity@vger.kernel.org
Cc:     Jarkko Sakkinen <jarkko@kernel.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Stefan Berger <stefanb@linux.ibm.com>, stable@vger.kernel.org,
        Peter Huewe <peterhuewe@gmx.de>,
        Jason Gunthorpe <jgg@ziepe.ca>, Wang Hai <wanghai38@huawei.com>
Subject: [PATCH v2] tpm: WARN_ONCE() -> dev_warn_once() in tpm_tis_status()
Date:   Wed,  3 Feb 2021 00:21:50 +0200
Message-Id: <20210202222150.120664-1-jarkko@kernel.org>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

An unexpected status from TPM chip is not irrecovable failure of the
kernel. It's only undesirable situation. Thus, change the WARN_ONCE()
instance inside tpm_tis_status() to dev_warn_once().

In addition: print the status in the log message because it is actually
useful information lacking from the existing log message.

Suggested-by: Guenter Roeck <linux@roeck-us.net>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Reviewed-by: Stefan Berger <stefanb@linux.ibm.com>
Cc: stable@vger.kernel.org
Fixes: 6f4f57f0b909 ("tpm: ibmvtpm: fix error return code in tpm_ibmvtpm_probe()")
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
---
v2:
- Use dev_warn_once() instead of pr_warn_once(), as suggested by Jason.
 drivers/char/tpm/tpm_tis_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/char/tpm/tpm_tis_core.c b/drivers/char/tpm/tpm_tis_core.c
index 431919d5f48a..22b6c751c33a 100644
--- a/drivers/char/tpm/tpm_tis_core.c
+++ b/drivers/char/tpm/tpm_tis_core.c
@@ -202,7 +202,7 @@ static u8 tpm_tis_status(struct tpm_chip *chip)
 		 * acquired.  Usually because tpm_try_get_ops() hasn't
 		 * been called before doing a TPM operation.
 		 */
-		WARN_ONCE(1, "TPM returned invalid status\n");
+		dev_warn_once(&chip->dev, "TPM returned invalid status: 0x%x\n", status);
 		return 0;
 	}
 
-- 
2.30.0

