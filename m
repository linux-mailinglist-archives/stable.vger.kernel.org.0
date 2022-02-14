Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90FF04B4725
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 10:53:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245065AbiBNJrM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 04:47:12 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:43378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245742AbiBNJqI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 04:46:08 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1F6E69286;
        Mon, 14 Feb 2022 01:39:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 609AE60FA2;
        Mon, 14 Feb 2022 09:39:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08132C340E9;
        Mon, 14 Feb 2022 09:39:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644831575;
        bh=JJpFLpXzXPk/tob/exmxLZtN9BW2CT29sd98rwJznw8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ODMtmNRt6O6mMqMO/36byp1+vb4I5dCRFTEbOFuSVTWpFzUUPOy+r4V5kSmYamxwJ
         q8tdeQxl8pcebTobtJEheyqm38vcwTkA3p2ynSShX1vhPo7fLinq9XuBwD9U5gZExJ
         Q1W5th4QJJE9PmClLs+pjwb05tFkRpiHNaDmjgwk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bean Huo <beanhuo@micron.com>,
        Xiaoke Wang <xkernel.wang@foxmail.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 026/116] scsi: ufs: ufshcd-pltfrm: Check the return value of devm_kstrdup()
Date:   Mon, 14 Feb 2022 10:25:25 +0100
Message-Id: <20220214092459.584903113@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220214092458.668376521@linuxfoundation.org>
References: <20220214092458.668376521@linuxfoundation.org>
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
index e49505534d498..0f2430fb398db 100644
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
@@ -128,6 +133,8 @@ static int ufshcd_populate_vreg(struct device *dev, const char *name,
 		return -ENOMEM;
 
 	vreg->name = devm_kstrdup(dev, name, GFP_KERNEL);
+	if (!vreg->name)
+		return -ENOMEM;
 
 	snprintf(prop_name, MAX_PROP_SIZE, "%s-max-microamp", name);
 	if (of_property_read_u32(np, prop_name, &vreg->max_uA)) {
-- 
2.34.1



