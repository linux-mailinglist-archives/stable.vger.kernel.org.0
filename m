Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C9BC59D7F8
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 12:00:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349711AbiHWJYJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 05:24:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349494AbiHWJWu (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 05:22:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E8318F944;
        Tue, 23 Aug 2022 01:35:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BFF6761475;
        Tue, 23 Aug 2022 08:35:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBACBC433D7;
        Tue, 23 Aug 2022 08:35:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661243733;
        bh=Z6tw5p3I/8qPJhg9+be/JmAilsolo8TLCG5ED0j4UIM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t/JrvDdHy/jPK5GoEXk+UnVn1Qvzb799BM8J7kIwZ6nbLooNpK2a+zEWdaaFuLTMx
         yo1g5FEfFa7D+hre/8SwBv95PqfZZTaPv9IpukZ2qniXhbE3R3jMAh4zWyWfNdWZLA
         yWKOEQdoB1kTF6ivDFp/26gSrnOIp318YsZyxoWU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Ren Zhijie <renzhijie2@huawei.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.19 364/365] scsi: ufs: ufs-mediatek: Fix build error and type mismatch
Date:   Tue, 23 Aug 2022 10:04:25 +0200
Message-Id: <20220823080133.542900028@linuxfoundation.org>
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

From: Ren Zhijie <renzhijie2@huawei.com>

commit f54912b228a8df6c0133e31bc75628677bb8c6e5 upstream.

If CONFIG_PM_SLEEP is not set.

make ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu-, will fail:

drivers/ufs/host/ufs-mediatek.c: In function ‘ufs_mtk_vreg_fix_vcc’:
drivers/ufs/host/ufs-mediatek.c:688:46: warning: format ‘%u’ expects argument of type ‘unsigned int’, but argument 4 has type ‘long unsigned int’ [-Wformat=]
    snprintf(vcc_name, MAX_VCC_NAME, "vcc-opt%u", res.a1);
                                             ~^   ~~~~~~
                                             %lu
drivers/ufs/host/ufs-mediatek.c: In function ‘ufs_mtk_system_suspend’:
drivers/ufs/host/ufs-mediatek.c:1371:8: error: implicit declaration of function ‘ufshcd_system_suspend’; did you mean ‘ufs_mtk_system_suspend’? [-Werror=implicit-function-declaration]
  ret = ufshcd_system_suspend(dev);
        ^~~~~~~~~~~~~~~~~~~~~
        ufs_mtk_system_suspend
drivers/ufs/host/ufs-mediatek.c: In function ‘ufs_mtk_system_resume’:
drivers/ufs/host/ufs-mediatek.c:1386:9: error: implicit declaration of function ‘ufshcd_system_resume’; did you mean ‘ufs_mtk_system_resume’? [-Werror=implicit-function-declaration]
  return ufshcd_system_resume(dev);
         ^~~~~~~~~~~~~~~~~~~~
         ufs_mtk_system_resume
cc1: some warnings being treated as errors

The declaration of func "ufshcd_system_suspend()" depends on
CONFIG_PM_SLEEP, so the function wrapper ufs_mtk_system_suspend() should
wrapped by CONFIG_PM_SLEEP too.

Link: https://lore.kernel.org/r/20220619115432.205504-1-renzhijie2@huawei.com
Fixes: 3fd23b8dfb54 ("scsi: ufs: ufs-mediatek: Fix the timing of configuring device regulators")
Reported-by: Hulk Robot <hulkci@huawei.com>
Reviewed-by: Stanley Chu <stanley.chu@mediatek.com>
Signed-off-by: Ren Zhijie <renzhijie2@huawei.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
[only take the suspend/resume portion of the commit - gregkh]
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/ufs/host/ufs-mediatek.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/ufs/host/ufs-mediatek.c
+++ b/drivers/ufs/host/ufs-mediatek.c
@@ -1220,6 +1220,7 @@ static int ufs_mtk_remove(struct platfor
 	return 0;
 }
 
+#ifdef CONFIG_PM_SLEEP
 int ufs_mtk_system_suspend(struct device *dev)
 {
 	struct ufs_hba *hba = dev_get_drvdata(dev);
@@ -1242,6 +1243,7 @@ int ufs_mtk_system_resume(struct device
 
 	return ufshcd_system_resume(dev);
 }
+#endif
 
 int ufs_mtk_runtime_suspend(struct device *dev)
 {


