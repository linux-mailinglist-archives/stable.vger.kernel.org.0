Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E40D4A8E46
	for <lists+stable@lfdr.de>; Thu,  3 Feb 2022 21:36:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345787AbiBCUgG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Feb 2022 15:36:06 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:40104 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354921AbiBCUd6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Feb 2022 15:33:58 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 15DBA61ACF;
        Thu,  3 Feb 2022 20:33:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C79CC340E8;
        Thu,  3 Feb 2022 20:33:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643920435;
        bh=Fgi/+hxCzJCbjcXLhLAZXPVXkEfPoMdz56AP0nfmSjQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QqEvZQqxH7wdMHlt8zZD1ina2jDS04AjNOVGq9tlHRMkvDserP+q5FmTU+KJpj3kx
         08PRxfSa7s8s6XrKVb03Ue8yuccTwdceXpDLUEbLrZoH1B6mFKjf3e+TV9F8ltxu1t
         3U4vUVQ/4ah8YKFS65/Jh+P4bjrLIIOctKVvu3ZUQmfjxzxm9mmn1DhqYgc4LDE23H
         rBYrkV1irq1FMNC/z296YkXYE9OM++HDXxcWxbAORwLdbOp1BHmCGG9iX7Yp1OjgMV
         8i8sK80XfevUV97mZgQ7hj89MrI2JxkIYopHtQbCru4+I8sen68fCbY3/d6ggVcORT
         vgt88fdMsXaGg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kiwoong Kim <kwmad.kim@samsung.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, jejb@linux.ibm.com,
        Avri.Altman@wdc.com, bvanassche@acm.org, beanhuo@micron.com,
        gustavoars@kernel.org, caleb@connolly.tech, cang@codeaurora.org,
        linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 30/41] scsi: ufs: Treat link loss as fatal error
Date:   Thu,  3 Feb 2022 15:32:34 -0500
Message-Id: <20220203203245.3007-30-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220203203245.3007-1-sashal@kernel.org>
References: <20220203203245.3007-1-sashal@kernel.org>
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
index de95be5d11d4e..3ed60068c4ea6 100644
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

