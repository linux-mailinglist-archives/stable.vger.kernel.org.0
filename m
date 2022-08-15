Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5985595127
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 06:52:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231218AbiHPEwP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Aug 2022 00:52:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232297AbiHPEs7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Aug 2022 00:48:59 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25E44D87C4;
        Mon, 15 Aug 2022 13:44:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B0124B80EB1;
        Mon, 15 Aug 2022 20:44:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E69B9C433C1;
        Mon, 15 Aug 2022 20:44:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660596293;
        bh=k+r9KM2TpEG+TWWUNiAOaK1PNljnrRxwz7Ux3xf+zYM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ILtmyyJRklBb198ep4zn2vlRgF0ByXe1rDur4ovPyO+XPQT9YwspohZ426VW87N55
         jzLB89gjLqh+S17SzWdBbC5gKJ/qHE/dIBpAZktXV7VqIOmFjAURtlkG6OlKsx2wis
         JWoZMgSxcsRnSAIGwUuCDKMB9sE1ozWt/fbWHAd8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stanley Chu <stanley.chu@mediatek.com>,
        Peter Wang <peter.wang@mediatek.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.19 1033/1157] scsi: ufs: core: Correct ufshcd_shutdown() flow
Date:   Mon, 15 Aug 2022 20:06:29 +0200
Message-Id: <20220815180521.282733054@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
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
 drivers/ufs/core/ufshcd.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -9484,12 +9484,8 @@ EXPORT_SYMBOL(ufshcd_runtime_resume);
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


