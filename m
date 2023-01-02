Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41D6E65B0D1
	for <lists+stable@lfdr.de>; Mon,  2 Jan 2023 12:28:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232881AbjABL2j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Jan 2023 06:28:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232877AbjABL1x (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Jan 2023 06:27:53 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 488FC5FA3
        for <stable@vger.kernel.org>; Mon,  2 Jan 2023 03:26:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 099E8B80CA9
        for <stable@vger.kernel.org>; Mon,  2 Jan 2023 11:26:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78118C433D2;
        Mon,  2 Jan 2023 11:26:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672658812;
        bh=TufFJV//O+nDzye0OPSIBR9Jg2nC5aCNVJIyO56ws+M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Dih9vJu/haT3RnZY1WCP+xkTW5yG7c9hhjIY2PZraX+wTaVYRBYBiHcBUxA8jA7+P
         uumeVnVK5J7mDmd3uZ6O0vdWZMrm/qE5CoypQCIos0JbPsXbhufjh61x8ikLLtXeYZ
         iJrl+G3oS7Cs2J10bLhMePVzUIARyu4L5MOuJ/A4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, stable <stable@kernel.org>,
        Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
        Miaoqian Lin <linmq006@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 01/74] usb: dwc3: qcom: Fix memory leak in dwc3_qcom_interconnect_init
Date:   Mon,  2 Jan 2023 12:21:34 +0100
Message-Id: <20230102110552.119540370@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230102110552.061937047@linuxfoundation.org>
References: <20230102110552.061937047@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
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

From: Miaoqian Lin <linmq006@gmail.com>

[ Upstream commit 97a48da1619ba6bd42a0e5da0a03aa490a9496b1 ]

of_icc_get() alloc resources for path handle, we should release it when not
need anymore. Like the release in dwc3_qcom_interconnect_exit() function.
Add icc_put() in error handling to fix this.

Fixes: bea46b981515 ("usb: dwc3: qcom: Add interconnect support in dwc3 driver")
Cc: stable <stable@kernel.org>
Acked-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Link: https://lore.kernel.org/r/20221206081731.818107-1-linmq006@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/dwc3/dwc3-qcom.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/dwc3/dwc3-qcom.c b/drivers/usb/dwc3/dwc3-qcom.c
index d3f3937d7005..e7d37b6000ad 100644
--- a/drivers/usb/dwc3/dwc3-qcom.c
+++ b/drivers/usb/dwc3/dwc3-qcom.c
@@ -260,7 +260,8 @@ static int dwc3_qcom_interconnect_init(struct dwc3_qcom *qcom)
 	if (IS_ERR(qcom->icc_path_apps)) {
 		dev_err(dev, "failed to get apps-usb path: %ld\n",
 				PTR_ERR(qcom->icc_path_apps));
-		return PTR_ERR(qcom->icc_path_apps);
+		ret = PTR_ERR(qcom->icc_path_apps);
+		goto put_path_ddr;
 	}
 
 	if (usb_get_maximum_speed(&qcom->dwc3->dev) >= USB_SPEED_SUPER ||
@@ -273,17 +274,23 @@ static int dwc3_qcom_interconnect_init(struct dwc3_qcom *qcom)
 
 	if (ret) {
 		dev_err(dev, "failed to set bandwidth for usb-ddr path: %d\n", ret);
-		return ret;
+		goto put_path_apps;
 	}
 
 	ret = icc_set_bw(qcom->icc_path_apps,
 		APPS_USB_AVG_BW, APPS_USB_PEAK_BW);
 	if (ret) {
 		dev_err(dev, "failed to set bandwidth for apps-usb path: %d\n", ret);
-		return ret;
+		goto put_path_apps;
 	}
 
 	return 0;
+
+put_path_apps:
+	icc_put(qcom->icc_path_apps);
+put_path_ddr:
+	icc_put(qcom->icc_path_ddr);
+	return ret;
 }
 
 /**
-- 
2.35.1



