Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C53B84417EB
	for <lists+stable@lfdr.de>; Mon,  1 Nov 2021 10:39:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232916AbhKAJlo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Nov 2021 05:41:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:47848 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233424AbhKAJjp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Nov 2021 05:39:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F1752611BD;
        Mon,  1 Nov 2021 09:27:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635758842;
        bh=D59Z+iVaZCoJbcR6UEt9nEm6CrTrMjpkANHIpTkw9LM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b/eED2h/KBULbpiagFBwBVRrizA5gioPrjN0+jOH9DBeSDmbLCeyj81fJczohzS8J
         K2Tj3PYoY5cpiRCR5XUQsQn/a80ahVLzNdc3p+3gkFPhlKmnktmLgbQOZz3XAlaAx/
         AoqZfga0FaoIZYk6dQaT2jeyvJd8TSEzz6krY9MM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alim Akhtar <alim.akhtar@samsung.com>,
        Kiwoong Kim <kwmad.kim@samsung.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Avri Altman <avri.altman@wdc.com>,
        Chanho Park <chanho61.park@samsung.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 74/77] scsi: ufs: ufs-exynos: Correct timeout value setting registers
Date:   Mon,  1 Nov 2021 10:18:02 +0100
Message-Id: <20211101082526.983837147@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211101082511.254155853@linuxfoundation.org>
References: <20211101082511.254155853@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chanho Park <chanho61.park@samsung.com>

[ Upstream commit 282da7cef078a87b6d5e8ceba8b17e428cf0e37c ]

PA_PWRMODEUSERDATA0 -> DL_FC0PROTTIMEOUTVAL
PA_PWRMODEUSERDATA1 -> DL_TC0REPLAYTIMEOUTVAL
PA_PWRMODEUSERDATA2 -> DL_AFC0REQTIMEOUTVAL

Link: https://lore.kernel.org/r/20211018062841.18226-1-chanho61.park@samsung.com
Fixes: a967ddb22d94 ("scsi: ufs: ufs-exynos: Apply vendor-specific values for three timeouts")
Cc: Alim Akhtar <alim.akhtar@samsung.com>
Cc: Kiwoong Kim <kwmad.kim@samsung.com>
Cc: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Reviewed-by: Alim Akhtar <alim.akhtar@samsung.com>
Reviewed-by: Avri Altman <avri.altman@wdc.com>
Signed-off-by: Chanho Park <chanho61.park@samsung.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/ufs/ufs-exynos.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/ufs/ufs-exynos.c b/drivers/scsi/ufs/ufs-exynos.c
index 3f4f3d6f48f9..0246ea99df7b 100644
--- a/drivers/scsi/ufs/ufs-exynos.c
+++ b/drivers/scsi/ufs/ufs-exynos.c
@@ -654,9 +654,9 @@ static int exynos_ufs_pre_pwr_mode(struct ufs_hba *hba,
 	}
 
 	/* setting for three timeout values for traffic class #0 */
-	ufshcd_dme_set(hba, UIC_ARG_MIB(PA_PWRMODEUSERDATA0), 8064);
-	ufshcd_dme_set(hba, UIC_ARG_MIB(PA_PWRMODEUSERDATA1), 28224);
-	ufshcd_dme_set(hba, UIC_ARG_MIB(PA_PWRMODEUSERDATA2), 20160);
+	ufshcd_dme_set(hba, UIC_ARG_MIB(DL_FC0PROTTIMEOUTVAL), 8064);
+	ufshcd_dme_set(hba, UIC_ARG_MIB(DL_TC0REPLAYTIMEOUTVAL), 28224);
+	ufshcd_dme_set(hba, UIC_ARG_MIB(DL_AFC0REQTIMEOUTVAL), 20160);
 
 	return 0;
 out:
-- 
2.33.0



