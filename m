Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08CA5657BD2
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:26:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233408AbiL1P0O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:26:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233811AbiL1PZh (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:25:37 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E1DF14090
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:25:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3976261562
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:25:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48E4CC4339B;
        Wed, 28 Dec 2022 15:25:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672241135;
        bh=H0/2lVufVcgmfCTaHjqj60U5X0v4AH4CRhvow763WYQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xeiBnnAGaxbmOhB/GPTJWq9OvGzSpN6JdJx/LvlTviSlSSLpJK8wvc264D1asECYU
         CnKptUZAtM6MI/WPDraxzZ/IiY6o4DuiMLZZg/JQe+P3JIAF2VB/LHXXuWIt8kIi9J
         Q1ORu0BgW2KjdcgoiDhLdKuBxEV/ohaVu+bBYFAY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Chen Zhongjin <chenzhongjin@huawei.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 410/731] scsi: efct: Fix possible memleak in efct_device_init()
Date:   Wed, 28 Dec 2022 15:38:37 +0100
Message-Id: <20221228144308.454204168@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chen Zhongjin <chenzhongjin@huawei.com>

[ Upstream commit bb0cd225dd37df1f4a22e36dad59ff33178ecdfc ]

In efct_device_init(), when efct_scsi_reg_fc_transport() fails,
efct_scsi_tgt_driver_exit() is not called to release memory for
efct_scsi_tgt_driver_init() and causes memleak:

unreferenced object 0xffff8881020ce000 (size 2048):
  comm "modprobe", pid 465, jiffies 4294928222 (age 55.872s)
  backtrace:
    [<0000000021a1ef1b>] kmalloc_trace+0x27/0x110
    [<000000004c3ed51c>] target_register_template+0x4fd/0x7b0 [target_core_mod]
    [<00000000f3393296>] efct_scsi_tgt_driver_init+0x18/0x50 [efct]
    [<00000000115de533>] 0xffffffffc0d90011
    [<00000000d608f646>] do_one_initcall+0xd0/0x4e0
    [<0000000067828cf1>] do_init_module+0x1cc/0x6a0
    ...

Fixes: 4df84e846624 ("scsi: elx: efct: Driver initialization routines")
Signed-off-by: Chen Zhongjin <chenzhongjin@huawei.com>
Link: https://lore.kernel.org/r/20221111074046.57061-1-chenzhongjin@huawei.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/elx/efct/efct_driver.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/elx/efct/efct_driver.c b/drivers/scsi/elx/efct/efct_driver.c
index eab68fd9337a..37e1ab96ee5b 100644
--- a/drivers/scsi/elx/efct/efct_driver.c
+++ b/drivers/scsi/elx/efct/efct_driver.c
@@ -42,6 +42,7 @@ efct_device_init(void)
 
 	rc = efct_scsi_reg_fc_transport();
 	if (rc) {
+		efct_scsi_tgt_driver_exit();
 		pr_err("failed to register to FC host\n");
 		return rc;
 	}
-- 
2.35.1



