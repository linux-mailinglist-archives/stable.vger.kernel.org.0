Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9DD64F37D0
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 16:25:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359561AbiDELUB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 07:20:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349219AbiDEJt1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:49:27 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6C8222B32;
        Tue,  5 Apr 2022 02:42:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 67A89B81B14;
        Tue,  5 Apr 2022 09:42:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD5B1C385A2;
        Tue,  5 Apr 2022 09:42:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649151772;
        bh=vKovIcCBUGCFdRn+0oQW/himbqi/UkvNL17+CQQ38oY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2WfVaEP71rr821eA4yp5VzdfeT639VJLYZ/f9gYRJAn8ZBjoTWpn5VUsY6z96/xZ4
         g9BLhFu1j0nS3AdvgJP8c+rpkIiOzAuWj56qi47NeGBADHl9mOOytpqFgk01WWCHuV
         Vpa2GxQqM9RSbBwoxbM5QfTftqb+/5V2+hzycFq0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yihang Li <liyihang6@hisilicon.com>,
        Xiang Chen <chenxiang66@hisilicon.com>,
        John Garry <john.garry@huawei.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 497/913] scsi: hisi_sas: Change permission of parameter prot_mask
Date:   Tue,  5 Apr 2022 09:25:59 +0200
Message-Id: <20220405070354.752269504@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070339.801210740@linuxfoundation.org>
References: <20220405070339.801210740@linuxfoundation.org>
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
index 3ab669dc806f..1942970f9eb7 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -527,7 +527,7 @@ MODULE_PARM_DESC(intr_conv, "interrupt converge enable (0-1)");
 
 /* permit overriding the host protection capabilities mask (EEDP/T10 PI) */
 static int prot_mask;
-module_param(prot_mask, int, 0);
+module_param(prot_mask, int, 0444);
 MODULE_PARM_DESC(prot_mask, " host protection capabilities mask, def=0x0 ");
 
 static void debugfs_work_handler_v3_hw(struct work_struct *work);
-- 
2.34.1



