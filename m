Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1739D4A8F0A
	for <lists+stable@lfdr.de>; Thu,  3 Feb 2022 21:42:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238046AbiBCUmG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Feb 2022 15:42:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355675AbiBCUin (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Feb 2022 15:38:43 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FAE3C06173B;
        Thu,  3 Feb 2022 12:36:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2E5A860A77;
        Thu,  3 Feb 2022 20:36:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCFC4C34103;
        Thu,  3 Feb 2022 20:36:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643920565;
        bh=X0E4WVPFXgHyWjQLo8X5V4Un4nPYt7YLfCvR7RUnq7w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=shfTh2qHZfWJ4lXowGpk/By6sLYHtbHiIDlSzlnI0bm8qrPEJD8x5dvpZtmNjS3EQ
         dFrNocvt7JxM9tZG1kxS3lg4B0QtrjMyJk1+jOHCFaOYfV2I8N3nW6tghon4lUIkA2
         YXXB5Bq6QFNSlJNElexJGJqxvgPDL2QLi2HkpzhgD/umkmvefr0nJmaw+OzlTrAFQG
         0KHtoeiGbSMXbcsILT49vgP8quYCE/fkiBCSRv7fv255GIhDI9KU9MefSuf+VlIcVS
         yx0JAVa1MTFCsofJJaFpmrhN8H72MrWBJDAqHyVS2DoO92lbiPKMaMTPO8e00/mf8i
         gNSaIIe0FqGPQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tong Zhang <ztong0001@gmail.com>, Hannes Reinecke <hare@suse.de>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, hare@kernel.org,
        jejb@linux.ibm.com, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 11/15] scsi: myrs: Fix crash in error case
Date:   Thu,  3 Feb 2022 15:35:41 -0500
Message-Id: <20220203203545.3879-11-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220203203545.3879-1-sashal@kernel.org>
References: <20220203203545.3879-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tong Zhang <ztong0001@gmail.com>

[ Upstream commit 4db09593af0b0b4d7d4805ebb3273df51d7cc30d ]

In myrs_detect(), cs->disable_intr is NULL when privdata->hw_init() fails
with non-zero. In this case, myrs_cleanup(cs) will call a NULL ptr and
crash the kernel.

[    1.105606] myrs 0000:00:03.0: Unknown Initialization Error 5A
[    1.105872] myrs 0000:00:03.0: Failed to initialize Controller
[    1.106082] BUG: kernel NULL pointer dereference, address: 0000000000000000
[    1.110774] Call Trace:
[    1.110950]  myrs_cleanup+0xe4/0x150 [myrs]
[    1.111135]  myrs_probe.cold+0x91/0x56a [myrs]
[    1.111302]  ? DAC960_GEM_intr_handler+0x1f0/0x1f0 [myrs]
[    1.111500]  local_pci_probe+0x48/0x90

Link: https://lore.kernel.org/r/20220123225717.1069538-1-ztong0001@gmail.com
Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Tong Zhang <ztong0001@gmail.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/myrs.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/myrs.c b/drivers/scsi/myrs.c
index cfc3f8b4174ab..2d3d14aa46b4b 100644
--- a/drivers/scsi/myrs.c
+++ b/drivers/scsi/myrs.c
@@ -2272,7 +2272,8 @@ static void myrs_cleanup(struct myrs_hba *cs)
 	myrs_unmap(cs);
 
 	if (cs->mmio_base) {
-		cs->disable_intr(cs);
+		if (cs->disable_intr)
+			cs->disable_intr(cs);
 		iounmap(cs->mmio_base);
 		cs->mmio_base = NULL;
 	}
-- 
2.34.1

