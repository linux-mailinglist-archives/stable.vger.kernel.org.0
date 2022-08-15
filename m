Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 381BF593B72
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 22:35:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344928AbiHOTtq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 15:49:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344976AbiHOTsE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 15:48:04 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4760742AC3;
        Mon, 15 Aug 2022 11:49:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 64513B810A0;
        Mon, 15 Aug 2022 18:49:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AADB0C433D6;
        Mon, 15 Aug 2022 18:49:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660589381;
        bh=o7H7UAVGrrpPOWxQzTHEeKccaB3z4bO8liOCqHQkIlA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dHOGAt2FMMxcYZxj2c39W+5g5FHXOTJ4zLd11igKNBsVS8NyL+eE982lzOn5BpZ98
         RUZRctl+8I8HxcWTDqR4sOlSRyoMx08o+J8Sc6npiz+rwrUT+BeU4qhH/uhc5Bk9yx
         CQzdP1B6KfgZzzFQAjjmGPMt2bgM1GQ3o8ugOnTA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stanley Chu <stanley.chu@mediatek.com>,
        Peter Wang <peter.wang@mediatek.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.15 669/779] scsi: ufs: core: Correct ufshcd_shutdown() flow
Date:   Mon, 15 Aug 2022 20:05:13 +0200
Message-Id: <20220815180405.942124712@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180337.130757997@linuxfoundation.org>
References: <20220815180337.130757997@linuxfoundation.org>
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

From: Peter Wang <peter.wang@mediatek.com>

commit 00511d2abf5708ad05dd5d1c36adb2468d274698 upstream.

After ufshcd_wl_shutdown() set device power off and link off,
ufshcd_shutdown() could turn off clock/power. Also remove
pm_runtime_get_sync.

The reason why it is safe to remove pm_runtime_get_sync() is because:

 - ufshcd_wl_shutdown() -> pm_runtime_get_sync() will resume hba->dev too.

 - device resume(turn on clk/power) is not required, even if device is in
   RPM_SUSPENDED.

Link: https://lore.kernel.org/r/20220727030526.31022-1-peter.wang@mediatek.com
Fixes: b294ff3e3449 ("scsi: ufs: core: Enable power management for wlun")
Cc: <stable@vger.kernel.org> # 5.15.x
Reviewed-by: Stanley Chu <stanley.chu@mediatek.com>
Signed-off-by: Peter Wang <peter.wang@mediatek.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/ufs/ufshcd.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -9239,12 +9239,8 @@ EXPORT_SYMBOL(ufshcd_runtime_resume);
 int ufshcd_shutdown(struct ufs_hba *hba)
 {
 	if (ufshcd_is_ufs_dev_poweroff(hba) && ufshcd_is_link_off(hba))
-		goto out;
+		ufshcd_suspend(hba);
 
-	pm_runtime_get_sync(hba->dev);
-
-	ufshcd_suspend(hba);
-out:
 	hba->is_powered = false;
 	/* allow force shutdown even in case of errors */
 	return 0;


