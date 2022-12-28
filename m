Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 190C96580DD
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:22:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234647AbiL1QVe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:21:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234711AbiL1QVG (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:21:06 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAF58192B4
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:19:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 72CEFB817AC
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:19:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE87DC433D2;
        Wed, 28 Dec 2022 16:19:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672244344;
        bh=GCAwWLTS2dS7azZOv1nhK2HejKNwVOj1082OnAyfARU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ow62hjo+5LqFf1AmTmtPAV7Ym7TAg9lrCZRFWgbumfwsGRY4XUGiZquqyP04WyS1A
         kcrdm4hwJuJfGhVbdrFB7qiKsAV/oSxtfhovzZ//6vwN/Gx+hvGKnbVXIy1LHUbMUN
         01bKWO9YCDCPiyP1ePIns4d3+jBmzoQaMEVourKg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Chen Zhongjin <chenzhongjin@huawei.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0654/1146] scsi: fcoe: Fix transport not deattached when fcoe_if_init() fails
Date:   Wed, 28 Dec 2022 15:36:33 +0100
Message-Id: <20221228144347.923482598@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
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

[ Upstream commit 4155658cee394b22b24c6d64e49247bf26d95b92 ]

fcoe_init() calls fcoe_transport_attach(&fcoe_sw_transport), but when
fcoe_if_init() fails, &fcoe_sw_transport is not detached and leaves freed
&fcoe_sw_transport on fcoe_transports list. This causes panic when
reinserting module.

 BUG: unable to handle page fault for address: fffffbfff82e2213
 RIP: 0010:fcoe_transport_attach+0xe1/0x230 [libfcoe]
 Call Trace:
  <TASK>
  do_one_initcall+0xd0/0x4e0
  load_module+0x5eee/0x7210
  ...

Fixes: 78a582463c1e ("[SCSI] fcoe: convert fcoe.ko to become an fcoe transport provider driver")
Signed-off-by: Chen Zhongjin <chenzhongjin@huawei.com>
Link: https://lore.kernel.org/r/20221115092442.133088-1-chenzhongjin@huawei.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/fcoe/fcoe.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
index 6ec296321ffc..38774a272e62 100644
--- a/drivers/scsi/fcoe/fcoe.c
+++ b/drivers/scsi/fcoe/fcoe.c
@@ -2491,6 +2491,7 @@ static int __init fcoe_init(void)
 
 out_free:
 	mutex_unlock(&fcoe_config_mutex);
+	fcoe_transport_detach(&fcoe_sw_transport);
 out_destroy:
 	destroy_workqueue(fcoe_wq);
 	return rc;
-- 
2.35.1



