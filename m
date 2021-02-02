Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5CB230C3F3
	for <lists+stable@lfdr.de>; Tue,  2 Feb 2021 16:37:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235292AbhBBPg3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Feb 2021 10:36:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:44180 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235443AbhBBPe0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Feb 2021 10:34:26 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E697164E9A;
        Tue,  2 Feb 2021 15:33:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612280025;
        bh=OAUPds6mAnAwG336U2WKoSVD+QXAp2woeVAgzYyVCXY=;
        h=From:To:Cc:Subject:Date:From;
        b=QJRVzYNj086qnX5qOwI1vg4NS/gsApKpQdGjx/+m3kUgGAav+NojCS4ebMyM5tZkE
         dTze50ZXMrpGyCRsbyLWicX8nXOqEwT7Po1Ic3lbZUB25qDyv5bwPzVP1LCs3BAPbK
         /nn9vmysSd6KiCwM8smJW8maKFwnFoJzLuaVlGDEML4C64W4ZGMFxLpFPq50HaLH/Q
         Zrp/+WASXvZBJMbTWnrf9/9dnIfvOvRHOglCPJx56x6rXz7SJzJSb5hGCdcfA5geIo
         2ztQpYCtLMKKALZ0S8TFtHKSTElKtiWkyzLYQ41tG1xZPzEVGxZu0dq7vIU4pcnwQu
         1ny8YWl2OcF9w==
From:   jarkko@kernel.org
To:     linux-integrity@vger.kernel.org
Cc:     Jarkko Sakkinen <jarkko@kernel.org>,
        Guenter Roeck <linux@roeck-us.net>, stable@vger.kernel.org,
        Peter Huewe <peterhuewe@gmx.de>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Stefan Berger <stefanb@linux.ibm.com>,
        Wang Hai <wanghai38@huawei.com>
Subject: [PATCH] tpm: WARN_ONCE() -> pr_warn_once() in tpm_tis_status()
Date:   Tue,  2 Feb 2021 17:33:17 +0200
Message-Id: <20210202153317.57749-1-jarkko@kernel.org>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jarkko Sakkinen <jarkko@kernel.org>

An unexpected status from TPM chip is not irrecovable failure of the
kernel. It's only undesirable situation. Thus, change the WARN_ONCE
instance inside tpm_tis_status() to pr_warn_once().

In addition: print the status in the log message because it is actually
useful information lacking from the existing log message.

Suggested-by:  Guenter Roeck <linux@roeck-us.net>
Cc: stable@vger.kernel.org
Fixes: 6f4f57f0b909 ("tpm: ibmvtpm: fix error return code in tpm_ibmvtpm_probe()")
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
---
 drivers/char/tpm/tpm_tis_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/char/tpm/tpm_tis_core.c b/drivers/char/tpm/tpm_tis_core.c
index 431919d5f48a..21f67c6366cb 100644
--- a/drivers/char/tpm/tpm_tis_core.c
+++ b/drivers/char/tpm/tpm_tis_core.c
@@ -202,7 +202,7 @@ static u8 tpm_tis_status(struct tpm_chip *chip)
 		 * acquired.  Usually because tpm_try_get_ops() hasn't
 		 * been called before doing a TPM operation.
 		 */
-		WARN_ONCE(1, "TPM returned invalid status\n");
+		pr_warn_once("TPM returned invalid status: 0x%x\n", status);
 		return 0;
 	}
 
-- 
2.30.0

