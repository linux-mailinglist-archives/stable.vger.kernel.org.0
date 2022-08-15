Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A6155948C8
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 02:09:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352443AbiHOX6j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 19:58:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355558AbiHOX4j (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 19:56:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9243616306E;
        Mon, 15 Aug 2022 13:19:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2270761057;
        Mon, 15 Aug 2022 20:19:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 107EEC433D6;
        Mon, 15 Aug 2022 20:19:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660594796;
        bh=UTztaEE8l6pZclggwKNlEFaJ8BgFSoAmWP/+gRernds=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tXruzDutR4SktlMAfLpMR1VzOzpBonOVpXrNYT6uVWJaxtBWfIOUke3W/oARP/67P
         y/SHSnMKs/6aMfImriQCkyTxPZfB+I7lDsjh3Cew99iVtHYLt0rMg/9iGCZ+K/WLWH
         6ikn9qo66pHbUDqVMufZs+4ZTUPMro4WxAMrlQYc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hacash Robot <hacashRobot@santino.com>,
        William Dean <williamsukatube@gmail.com>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Kalle Valo <kvalo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0562/1157] wifi: rtw88: check the return value of alloc_workqueue()
Date:   Mon, 15 Aug 2022 19:58:38 +0200
Message-Id: <20220815180502.085806225@linuxfoundation.org>
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

From: William Dean <williamsukatube@gmail.com>

[ Upstream commit 42bbf810e155efc6129a3a648ae5300f00b79d7b ]

The function alloc_workqueue() in rtw_core_init() can fail, but
there is no check of its return value. To fix this bug, its return value
should be checked with new error handling code.

Fixes: fe101716c7c9d ("rtw88: replace tx tasklet with work queue")
Reported-by: Hacash Robot <hacashRobot@santino.com>
Signed-off-by: William Dean <williamsukatube@gmail.com>
Reviewed-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/20220723063756.2956189-1-williamsukatube@163.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw88/main.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtw88/main.c b/drivers/net/wireless/realtek/rtw88/main.c
index efabd5b1bf5b..645ef1d01895 100644
--- a/drivers/net/wireless/realtek/rtw88/main.c
+++ b/drivers/net/wireless/realtek/rtw88/main.c
@@ -1984,6 +1984,10 @@ int rtw_core_init(struct rtw_dev *rtwdev)
 	timer_setup(&rtwdev->tx_report.purge_timer,
 		    rtw_tx_report_purge_timer, 0);
 	rtwdev->tx_wq = alloc_workqueue("rtw_tx_wq", WQ_UNBOUND | WQ_HIGHPRI, 0);
+	if (!rtwdev->tx_wq) {
+		rtw_warn(rtwdev, "alloc_workqueue rtw_tx_wq failed\n");
+		return -ENOMEM;
+	}
 
 	INIT_DELAYED_WORK(&rtwdev->watch_dog_work, rtw_watch_dog_work);
 	INIT_DELAYED_WORK(&coex->bt_relink_work, rtw_coex_bt_relink_work);
-- 
2.35.1



