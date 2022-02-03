Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BEC744A8DB9
	for <lists+stable@lfdr.de>; Thu,  3 Feb 2022 21:32:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354348AbiBCUcm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Feb 2022 15:32:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354501AbiBCUbr (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Feb 2022 15:31:47 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCB7AC06175D;
        Thu,  3 Feb 2022 12:31:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 52BE761A5C;
        Thu,  3 Feb 2022 20:31:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81919C340E8;
        Thu,  3 Feb 2022 20:31:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643920275;
        bh=cfXOxnZgcPdfoYQeHM0c0yyXmHPUq5UCgsWsGd9TXlo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HBdMEAYyY9/WblwtthYrRq5u0G3IL5xpzCL1izPZsbmJlCpbglHNWzlvnnln0PPPN
         BtjE7/omMxmsIZ0tqpL5zHRMLkxKZVZ7EGcbrRl1jYogC5V1MXZg/ts4BzlCSSGvQX
         mKAI14eQdOOID2LBN/alyJfLp+WbzklfIol/Zha1ha8WOz2P7utes5P9XKNW6n2sNG
         CGF3/3+nwiy0tEmD6aOTTxMV4QvLl6WHalS1/5xwfQ/dUGXPfE+Bx7G5I+eFJZQYnh
         lZwI5reHZlqfnWaO+F+chwJLd+J6PN6Jiqqfnntgw85PeAUHCOQZH+Yn0Jc+wCD7Rt
         tdZ4IR4wOkBdg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kiwoong Kim <kwmad.kim@samsung.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, jejb@linux.ibm.com,
        bvanassche@acm.org, Avri.Altman@wdc.com, beanhuo@micron.com,
        gustavoars@kernel.org, cang@codeaurora.org, caleb@connolly.tech,
        linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.16 33/52] scsi: ufs: Treat link loss as fatal error
Date:   Thu,  3 Feb 2022 15:29:27 -0500
Message-Id: <20220203202947.2304-33-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220203202947.2304-1-sashal@kernel.org>
References: <20220203202947.2304-1-sashal@kernel.org>
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
index 6a295c88d850f..a7ff0e5b54946 100644
--- a/drivers/scsi/ufs/ufshci.h
+++ b/drivers/scsi/ufs/ufshci.h
@@ -142,7 +142,8 @@ static inline u32 ufshci_version(u32 major, u32 minor)
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

