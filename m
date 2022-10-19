Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97DA6603CF2
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 10:55:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231699AbiJSIzN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 04:55:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231974AbiJSIyP (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 04:54:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF9D591847;
        Wed, 19 Oct 2022 01:51:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8F7AA61831;
        Wed, 19 Oct 2022 08:50:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1814C433C1;
        Wed, 19 Oct 2022 08:50:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666169408;
        bh=N7Z0fmsOKPI6czj4QQoycKm9e6SPcritX2riAcV8dNE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A/ovfSb8tQsfvFg390bstU0B4HgJ0CT6NtVTc0qIsTTjJ5PJw19QVRtmS9AmWrDGE
         8SJ8rImmwyAJI3ieJrBJQQsDSh2yLTJUlA+FIoi+tOfkDM9/PQhEsuR/DHQzxY676x
         aj+NjeaOTrHECG9TIoSCkK9rf0A2KVOlOFSvW+t0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yang Yingliang <yangyingliang@huawei.com>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Kalle Valo <kvalo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 264/862] wifi: rtw88: add missing destroy_workqueue() on error path in rtw_core_init()
Date:   Wed, 19 Oct 2022 10:25:51 +0200
Message-Id: <20221019083301.695786772@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
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
 drivers/net/wireless/realtek/rtw88/main.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/drivers/net/wireless/realtek/rtw88/main.c
+++ b/drivers/net/wireless/realtek/rtw88/main.c
@@ -2045,7 +2045,7 @@ int rtw_core_init(struct rtw_dev *rtwdev
 	ret = rtw_load_firmware(rtwdev, RTW_NORMAL_FW);
 	if (ret) {
 		rtw_warn(rtwdev, "no firmware loaded\n");
-		return ret;
+		goto out;
 	}
 
 	if (chip->wow_fw_name) {
@@ -2055,11 +2055,15 @@ int rtw_core_init(struct rtw_dev *rtwdev
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
 


