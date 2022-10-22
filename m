Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63138608C0B
	for <lists+stable@lfdr.de>; Sat, 22 Oct 2022 12:58:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230472AbiJVK6B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Oct 2022 06:58:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230494AbiJVK5k (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Oct 2022 06:57:40 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 167592E983F;
        Sat, 22 Oct 2022 03:16:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 58643B82E14;
        Sat, 22 Oct 2022 07:44:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1DFEC433C1;
        Sat, 22 Oct 2022 07:44:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666424679;
        bh=/WHpOa08+5yeB5M68zBL42rWpAGT/Vty05ist5mnjeg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LtGfJUQOqawN9d7syREvvtG9DClXq9s5SiECps3YMp5JKvxHK/qJtoczZIdJrM9ml
         mwqKFtvirIDAe09oAqZQg2IELspSSsWLobL5hrNQ1+BDP/bPhkLLx5QfnPdhZOn9nO
         5RaHzvP0HxMLFtDUoPGeBMDm4WnSSQtFtUJRpni8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yang Yingliang <yangyingliang@huawei.com>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Kalle Valo <kvalo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 228/717] wifi: rtw88: add missing destroy_workqueue() on error path in rtw_core_init()
Date:   Sat, 22 Oct 2022 09:21:47 +0200
Message-Id: <20221022072455.457843616@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221022072415.034382448@linuxfoundation.org>
References: <20221022072415.034382448@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit b0ea758b30bbdf7c4323c78b7c50c05d2e1224d5 ]

Add the missing destroy_workqueue() before return from rtw_core_init()
in error path.

Fixes: fe101716c7c9 ("rtw88: replace tx tasklet with work queue")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Reviewed-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/20220826023817.3908255-1-yangyingliang@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw88/main.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw88/main.c b/drivers/net/wireless/realtek/rtw88/main.c
index 645ef1d01895..c364482ab331 100644
--- a/drivers/net/wireless/realtek/rtw88/main.c
+++ b/drivers/net/wireless/realtek/rtw88/main.c
@@ -2037,7 +2037,7 @@ int rtw_core_init(struct rtw_dev *rtwdev)
 	ret = rtw_load_firmware(rtwdev, RTW_NORMAL_FW);
 	if (ret) {
 		rtw_warn(rtwdev, "no firmware loaded\n");
-		return ret;
+		goto out;
 	}
 
 	if (chip->wow_fw_name) {
@@ -2047,11 +2047,15 @@ int rtw_core_init(struct rtw_dev *rtwdev)
 			wait_for_completion(&rtwdev->fw.completion);
 			if (rtwdev->fw.firmware)
 				release_firmware(rtwdev->fw.firmware);
-			return ret;
+			goto out;
 		}
 	}
 
 	return 0;
+
+out:
+	destroy_workqueue(rtwdev->tx_wq);
+	return ret;
 }
 EXPORT_SYMBOL(rtw_core_init);
 
-- 
2.35.1



