Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 059266433C7
	for <lists+stable@lfdr.de>; Mon,  5 Dec 2022 20:39:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234765AbiLETj3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Dec 2022 14:39:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234666AbiLETjL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Dec 2022 14:39:11 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A3C62E5
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 11:36:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B9B7EB811EC
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 19:36:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20AF8C433C1;
        Mon,  5 Dec 2022 19:36:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670268976;
        bh=apM78VqMfjVil3PXuFvJM6AE0MPUExIeLXC8KxUYvLo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q3yhKrX587tDLsSYPgBmYQiO50Cb5a69jjREAY2R8oZfM75cRJ1bAfrOYTtSP8QiP
         DjHEdpoQ4uROOtuTFssvWkoyDaxXKC5r+8EytUv6CX5Hy9vvOWCOn2eEKBIkEJowNa
         ReNMEgngkQLZ10mxr7PZ2NpMo0FVRb0PX6a5bMp4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Duoming Zhou <duoming@zju.edu.cn>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 043/120] qlcnic: fix sleep-in-atomic-context bugs caused by msleep
Date:   Mon,  5 Dec 2022 20:09:43 +0100
Message-Id: <20221205190807.835180386@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221205190806.528972574@linuxfoundation.org>
References: <20221205190806.528972574@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Duoming Zhou <duoming@zju.edu.cn>

[ Upstream commit 8dbd6e4ce1b9c527921643d9e34f188a10d4e893 ]

The watchdog timer is used to monitor whether the process
of transmitting data is timeout. If we use qlcnic driver,
the dev_watchdog() that is the timer handler of watchdog
timer will call qlcnic_tx_timeout() to process the timeout.
But the qlcnic_tx_timeout() calls msleep(), as a result,
the sleep-in-atomic-context bugs will happen. The processes
are shown below:

   (atomic context)
dev_watchdog
  qlcnic_tx_timeout
    qlcnic_83xx_idc_request_reset
      qlcnic_83xx_lock_driver
        msleep

---------------------------

   (atomic context)
dev_watchdog
  qlcnic_tx_timeout
    qlcnic_83xx_idc_request_reset
      qlcnic_83xx_lock_driver
        qlcnic_83xx_recover_driver_lock
          msleep

Fix by changing msleep() to mdelay(), the mdelay() is
busy-waiting and the bugs could be mitigated.

Fixes: 629263acaea3 ("qlcnic: 83xx CNA inter driver communication mechanism")
Signed-off-by: Duoming Zhou <duoming@zju.edu.cn>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_hw.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_hw.c b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_hw.c
index bd0607680329..2fd5c6fdb500 100644
--- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_hw.c
+++ b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_hw.c
@@ -2991,7 +2991,7 @@ static void qlcnic_83xx_recover_driver_lock(struct qlcnic_adapter *adapter)
 		QLCWRX(adapter->ahw, QLC_83XX_RECOVER_DRV_LOCK, val);
 		dev_info(&adapter->pdev->dev,
 			 "%s: lock recovery initiated\n", __func__);
-		msleep(QLC_83XX_DRV_LOCK_RECOVERY_DELAY);
+		mdelay(QLC_83XX_DRV_LOCK_RECOVERY_DELAY);
 		val = QLCRDX(adapter->ahw, QLC_83XX_RECOVER_DRV_LOCK);
 		id = ((val >> 2) & 0xF);
 		if (id == adapter->portnum) {
@@ -3027,7 +3027,7 @@ int qlcnic_83xx_lock_driver(struct qlcnic_adapter *adapter)
 		if (status)
 			break;
 
-		msleep(QLC_83XX_DRV_LOCK_WAIT_DELAY);
+		mdelay(QLC_83XX_DRV_LOCK_WAIT_DELAY);
 		i++;
 
 		if (i == 1)
-- 
2.35.1



