Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B848E4A8E7D
	for <lists+stable@lfdr.de>; Thu,  3 Feb 2022 21:37:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354485AbiBCUhi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Feb 2022 15:37:38 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:37914 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355308AbiBCUfg (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Feb 2022 15:35:36 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AA938B835AE;
        Thu,  3 Feb 2022 20:35:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D0A6C340EB;
        Thu,  3 Feb 2022 20:35:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643920533;
        bh=Oj7NXyw/WsaA4MVF4fR5lEQedQrm6KIDPdBManiDg4c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=euKhTwQ/Ju/9i9sQCFDa1Qp1dWcF/u/2rzb2r/B2SDp1h/9Op0BNQjCHCLzGWJECU
         G/Ii5ct+Uv/ErmHAih55rAQMCBhb+v8WU+Fx3DuQ/kF2vnOQxS7P3t4qq6yLEjYFlV
         So0/vQI/XIQ6YYkXMpokCbYSqfFDGii87u+0n4xX2oY/7yh0tdhjhkWvOve3Kyxl1T
         3NmK8rRdpiAhHacNhHicKo7RuDGIsWb0Th+KkvqmHbvDBpeGT3Xsl162fqSXrz10X6
         QU6ZFJsrDqauaUntA5QaCsIMq8eZESShnlYwTqfGNe5eDdpguJWIVHO05PvR1gG+wW
         6JPQvrpHeYsgA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kiwoong Kim <kwmad.kim@samsung.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, jejb@linux.ibm.com,
        bvanassche@acm.org, Avri.Altman@wdc.com, beanhuo@micron.com,
        gustavoars@kernel.org, caleb@connolly.tech, cang@codeaurora.org,
        linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 18/25] scsi: ufs: Treat link loss as fatal error
Date:   Thu,  3 Feb 2022 15:34:39 -0500
Message-Id: <20220203203447.3570-18-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220203203447.3570-1-sashal@kernel.org>
References: <20220203203447.3570-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kiwoong Kim <kwmad.kim@samsung.com>

[ Upstream commit c99b9b2301492b665b6e51ba6c06ec362eddcd10 ]

This event is raised when link is lost as specified in UFSHCI spec and that
means communication is not possible. Thus initializing UFS interface needs
to be done.

Make UFS driver considers Link Lost as fatal in the INT_FATAL_ERRORS
mask. This will trigger a host reset whenever a link lost interrupt occurs.

Link: https://lore.kernel.org/r/1642743475-54275-1-git-send-email-kwmad.kim@samsung.com
Signed-off-by: Kiwoong Kim <kwmad.kim@samsung.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/ufs/ufshci.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/ufs/ufshci.h b/drivers/scsi/ufs/ufshci.h
index 6795e1f0e8f8c..1d999228efc85 100644
--- a/drivers/scsi/ufs/ufshci.h
+++ b/drivers/scsi/ufs/ufshci.h
@@ -138,7 +138,8 @@ enum {
 #define INT_FATAL_ERRORS	(DEVICE_FATAL_ERROR |\
 				CONTROLLER_FATAL_ERROR |\
 				SYSTEM_BUS_FATAL_ERROR |\
-				CRYPTO_ENGINE_FATAL_ERROR)
+				CRYPTO_ENGINE_FATAL_ERROR |\
+				UIC_LINK_LOST)
 
 /* HCS - Host Controller Status 30h */
 #define DEVICE_PRESENT				0x1
-- 
2.34.1

