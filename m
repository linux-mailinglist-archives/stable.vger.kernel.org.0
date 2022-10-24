Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 782B960AB6C
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 15:52:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236551AbiJXNwO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 09:52:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236586AbiJXNvd (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 09:51:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADC69BA915;
        Mon, 24 Oct 2022 05:42:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C8849611B0;
        Mon, 24 Oct 2022 12:41:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0747C433D6;
        Mon, 24 Oct 2022 12:41:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666615293;
        bh=G+64bLDaqhTJFDrsaQTm7MH6DNPZniUfnto6LrBgJmg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IrtZFyEvUf3TphpiIZse0BShkXFqkrW70GLwk84kcrvSFPyNIisgB6tjqlL3FdT1F
         xS+7xuiJN4em+1qGi1tYaUhr2SVU+Xd6tvw+xyCfX7LvVrqUkwCMS8kmgvSSpEVMP7
         ia1zoC2SCkQtAIbTWU1sWNYK50VXHfKX42h0QYqw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yang Yingliang <yangyingliang@huawei.com>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Kalle Valo <kvalo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 165/530] wifi: rtw88: add missing destroy_workqueue() on error path in rtw_core_init()
Date:   Mon, 24 Oct 2022 13:28:29 +0200
Message-Id: <20221024113052.528593734@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113044.976326639@linuxfoundation.org>
References: <20221024113044.976326639@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
index 5786995d90d4..d7b7b2cce974 100644
--- a/drivers/net/wireless/realtek/rtw88/main.c
+++ b/drivers/net/wireless/realtek/rtw88/main.c
@@ -1869,7 +1869,7 @@ int rtw_core_init(struct rtw_dev *rtwdev)
 	ret = rtw_load_firmware(rtwdev, RTW_NORMAL_FW);
 	if (ret) {
 		rtw_warn(rtwdev, "no firmware loaded\n");
-		return ret;
+		goto out;
 	}
 
 	if (chip->wow_fw_name) {
@@ -1879,11 +1879,15 @@ int rtw_core_init(struct rtw_dev *rtwdev)
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



