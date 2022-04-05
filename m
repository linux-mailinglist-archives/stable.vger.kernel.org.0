Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF13E4F2C1C
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 13:22:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245403AbiDEIze (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:55:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237548AbiDEISG (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:18:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4AA46A421;
        Tue,  5 Apr 2022 01:06:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 81012617F0;
        Tue,  5 Apr 2022 08:06:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D7F1C385A0;
        Tue,  5 Apr 2022 08:06:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649146005;
        bh=xSXEUYgzxQ6dCPr/F/TUohTuCLEdahAXG9X8b46p8Eg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fGPFWY0h4jX62uMFqkuabsAV5HpkGU9bHqSPLND9331VUWbVLSEwNZwgWJSfYisSP
         1S/3KOoVxQYU31/hG0mtXcJXA3x47pPyFs4TywVo/jtNshEXlI1Ma3hSBtzKuP+foN
         50eMaXyAAvLdwMNrCbjWcrbidp/72lG+AGa9f+Vg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yihang Li <liyihang6@hisilicon.com>,
        Xiang Chen <chenxiang66@hisilicon.com>,
        John Garry <john.garry@huawei.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0608/1126] scsi: hisi_sas: Change permission of parameter prot_mask
Date:   Tue,  5 Apr 2022 09:22:35 +0200
Message-Id: <20220405070425.480902281@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Xiang Chen <chenxiang66@hisilicon.com>

[ Upstream commit c4e070457a93705e56ed06b3910d9e5fe56d3be3 ]

Currently the permission of parameter prot_mask is 0x0, which means that
the member does not appear in sysfs. Change it as other module parameters
to 0444 for world-readable.

[mkp: s/v3/v2/]

Link: https://lore.kernel.org/r/1645703489-87194-2-git-send-email-john.garry@huawei.com
Fixes: d6a9000b81be ("scsi: hisi_sas: Add support for DIF feature for v2 hw")
Reported-by: Yihang Li <liyihang6@hisilicon.com>
Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
Signed-off-by: John Garry <john.garry@huawei.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
index a01a3a7b706b..70173389f6eb 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -530,7 +530,7 @@ MODULE_PARM_DESC(intr_conv, "interrupt converge enable (0-1)");
 
 /* permit overriding the host protection capabilities mask (EEDP/T10 PI) */
 static int prot_mask;
-module_param(prot_mask, int, 0);
+module_param(prot_mask, int, 0444);
 MODULE_PARM_DESC(prot_mask, " host protection capabilities mask, def=0x0 ");
 
 static void debugfs_work_handler_v3_hw(struct work_struct *work);
-- 
2.34.1



