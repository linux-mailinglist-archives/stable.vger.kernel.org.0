Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0F8259D781
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 11:59:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242703AbiHWJQ7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 05:16:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349099AbiHWJOQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 05:14:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F30186C2E;
        Tue, 23 Aug 2022 01:32:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5BE23614C5;
        Tue, 23 Aug 2022 08:31:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AAA7C433C1;
        Tue, 23 Aug 2022 08:31:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661243505;
        bh=wvUJ88hrV5QL9tWRPmCuYWJ//YbsY8jZCc5Y1rHvmxY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tNGxalzqUB7ASopjNxrQs/EkO/F01E5MlaGZQ8YavBMbVNPelC1J6aRYzzRBHA/xZ
         KX1+IPhYVvkqYDgBIE7iiMg8tYHOoi6UgsXMyfB/3Y5WYq8O/r4AoN4WipkhZwOfSr
         0FN7ScaNm/tD6/mZ7in95PJyv5RdpqHo10REkkcU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 268/365] scsi: ufs: core: Add UFSHCD_QUIRK_BROKEN_64BIT_ADDRESS
Date:   Tue, 23 Aug 2022 10:02:49 +0200
Message-Id: <20220823080129.392779806@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080118.128342613@linuxfoundation.org>
References: <20220823080118.128342613@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>

[ Upstream commit 6554400d6f66b9494a0c0f07712ab0a9d307eb01 ]

Add UFSHCD_QUIRK_BROKEN_64BIT_ADDRESS for host controllers which do not
support 64-bit addressing.

Link: https://lore.kernel.org/r/20220603110524.1997825-3-yoshihiro.shimoda.uh@renesas.com
Signed-off-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ufs/core/ufshcd.c | 2 ++
 include/ufs/ufshcd.h      | 6 ++++++
 2 files changed, 8 insertions(+)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 8d91be0fd1a4..141fff01a662 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -2227,6 +2227,8 @@ static inline int ufshcd_hba_capabilities(struct ufs_hba *hba)
 	int err;
 
 	hba->capabilities = ufshcd_readl(hba, REG_CONTROLLER_CAPABILITIES);
+	if (hba->quirks & UFSHCD_QUIRK_BROKEN_64BIT_ADDRESS)
+		hba->capabilities &= ~MASK_64_ADDRESSING_SUPPORT;
 
 	/* nutrs and nutmrs are 0 based values */
 	hba->nutrs = (hba->capabilities & MASK_TRANSFER_REQUESTS_SLOTS) + 1;
diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
index a92271421718..795c8951341d 100644
--- a/include/ufs/ufshcd.h
+++ b/include/ufs/ufshcd.h
@@ -577,6 +577,12 @@ enum ufshcd_quirks {
 	 * support physical host configuration.
 	 */
 	UFSHCD_QUIRK_SKIP_PH_CONFIGURATION		= 1 << 16,
+
+	/*
+	 * This quirk needs to be enabled if the host controller has
+	 * 64-bit addressing supported capability but it doesn't work.
+	 */
+	UFSHCD_QUIRK_BROKEN_64BIT_ADDRESS		= 1 << 17,
 };
 
 enum ufshcd_caps {
-- 
2.35.1



