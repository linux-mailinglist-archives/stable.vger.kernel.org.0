Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A9AB4B4A07
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 11:37:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347188AbiBNK1i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 05:27:38 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:34784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347325AbiBNKZu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 05:25:50 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E8996EF0D;
        Mon, 14 Feb 2022 01:57:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 220E3B80DD5;
        Mon, 14 Feb 2022 09:57:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F337C340E9;
        Mon, 14 Feb 2022 09:57:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644832628;
        bh=Y4I1XbzZkketrSB1+LOJA9GxTunIlw/Msl9gsyKUgh8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LDcR5evzA+pMzv41ed4nV2ogNyfh2QF1zxYBSwrMhDLNDa3MSltzmnGiV49xC7ubJ
         +SqLgLFgTHJDH1lHHt32g7uYIReP43fpR7/lqlTwHJTTHg4qlKaKg/JXbHJdJrrxPk
         8zwrjCVWRUklX7ZhXdbmEyDycTnERnwtKKon+ruE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bean Huo <beanhuo@micron.com>,
        Xiaoke Wang <xkernel.wang@foxmail.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 044/203] scsi: ufs: ufshcd-pltfrm: Check the return value of devm_kstrdup()
Date:   Mon, 14 Feb 2022 10:24:48 +0100
Message-Id: <20220214092511.713387573@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220214092510.221474733@linuxfoundation.org>
References: <20220214092510.221474733@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xiaoke Wang <xkernel.wang@foxmail.com>

[ Upstream commit a65b32748f4566f986ba2495a8236c141fa42a26 ]

devm_kstrdup() returns pointer to allocated string on success, NULL on
failure. So it is better to check the return value of it.

Link: https://lore.kernel.org/r/tencent_4257E15D4A94FF9020DDCC4BB9B21C041408@qq.com
Reviewed-by: Bean Huo <beanhuo@micron.com>
Signed-off-by: Xiaoke Wang <xkernel.wang@foxmail.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/ufs/ufshcd-pltfrm.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/scsi/ufs/ufshcd-pltfrm.c b/drivers/scsi/ufs/ufshcd-pltfrm.c
index 8b16bbbcb806c..87975d1a21c8b 100644
--- a/drivers/scsi/ufs/ufshcd-pltfrm.c
+++ b/drivers/scsi/ufs/ufshcd-pltfrm.c
@@ -92,6 +92,11 @@ static int ufshcd_parse_clock_info(struct ufs_hba *hba)
 		clki->min_freq = clkfreq[i];
 		clki->max_freq = clkfreq[i+1];
 		clki->name = devm_kstrdup(dev, name, GFP_KERNEL);
+		if (!clki->name) {
+			ret = -ENOMEM;
+			goto out;
+		}
+
 		if (!strcmp(name, "ref_clk"))
 			clki->keep_link_active = true;
 		dev_dbg(dev, "%s: min %u max %u name %s\n", "freq-table-hz",
@@ -127,6 +132,8 @@ static int ufshcd_populate_vreg(struct device *dev, const char *name,
 		return -ENOMEM;
 
 	vreg->name = devm_kstrdup(dev, name, GFP_KERNEL);
+	if (!vreg->name)
+		return -ENOMEM;
 
 	snprintf(prop_name, MAX_PROP_SIZE, "%s-max-microamp", name);
 	if (of_property_read_u32(np, prop_name, &vreg->max_uA)) {
-- 
2.34.1



