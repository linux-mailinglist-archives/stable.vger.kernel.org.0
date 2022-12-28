Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2881657813
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 15:48:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230183AbiL1Or7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 09:47:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232920AbiL1Ord (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 09:47:33 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5495711C18
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 06:46:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E1CF061545
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 14:46:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3C26C433D2;
        Wed, 28 Dec 2022 14:46:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672238795;
        bh=6RAevpV9vBfvWGQuq8yD8rM+BX5gWDhc5DU/iFA3Bkk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pK8/HXmLqslpbggnwWpPdEMvuvgh5ihCo1p+qs01W32GHcxTKR6k0n7kD6EU3aRDF
         PbtLXE13tevcglfr0A0MK6SwNDhhhghLcY2jG0R/YNhomkhdvZBUPq6ec2R9nzufY1
         3Bq4sFIzebhWegWAsVACnr4l4dt0w5yM7lJ7zdyU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Chen Jiahao <chenjiahao16@huawei.com>,
        Nishanth Menon <nm@ti.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 015/731] drivers: soc: ti: knav_qmss_queue: Mark knav_acc_firmwares as static
Date:   Wed, 28 Dec 2022 15:32:02 +0100
Message-Id: <20221228144256.980869806@linuxfoundation.org>
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

From: Chen Jiahao <chenjiahao16@huawei.com>

[ Upstream commit adf85adc2a7199b41e7a4da083bd17274a3d6969 ]

There is a sparse warning shown below:

drivers/soc/ti/knav_qmss_queue.c:70:12: warning: symbol
'knav_acc_firmwares' was not declared. Should it be static?

Since 'knav_acc_firmwares' is only called within knav_qmss_queue.c,
mark it as static to fix the warning.

Fixes: 96ee19becc3b ("soc: ti: add firmware file name as part of the driver")
Signed-off-by: Chen Jiahao <chenjiahao16@huawei.com>
Signed-off-by: Nishanth Menon <nm@ti.com>
Link: https://lore.kernel.org/r/20221019153212.72350-1-chenjiahao16@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/ti/knav_qmss_queue.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/soc/ti/knav_qmss_queue.c b/drivers/soc/ti/knav_qmss_queue.c
index 2ac3856b8d42..920eca809084 100644
--- a/drivers/soc/ti/knav_qmss_queue.c
+++ b/drivers/soc/ti/knav_qmss_queue.c
@@ -67,7 +67,7 @@ static DEFINE_MUTEX(knav_dev_lock);
  * Newest followed by older ones. Search is done from start of the array
  * until a firmware file is found.
  */
-const char *knav_acc_firmwares[] = {"ks2_qmss_pdsp_acc48.bin"};
+static const char * const knav_acc_firmwares[] = {"ks2_qmss_pdsp_acc48.bin"};
 
 static bool device_ready;
 bool knav_qmss_device_ready(void)
-- 
2.35.1



