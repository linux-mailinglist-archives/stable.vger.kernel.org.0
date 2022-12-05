Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 862A16432AB
	for <lists+stable@lfdr.de>; Mon,  5 Dec 2022 20:28:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233814AbiLET2I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Dec 2022 14:28:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233984AbiLET1f (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Dec 2022 14:27:35 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B36927936
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 11:24:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 18ABF612FB
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 19:24:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DB6DC433D6;
        Mon,  5 Dec 2022 19:24:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670268281;
        bh=apM78VqMfjVil3PXuFvJM6AE0MPUExIeLXC8KxUYvLo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=z05O1cQyauhtPJejTSJ9vzkdnGcVTnjXIp+Q14MH1L/1V8NTdPAfZTHKUlMSlWINx
         77yPXiKdJven4KKWcF6Tev2zIw0Ht91CfMN/Ds51ybQbjspWeYmZZrKN9Q8f92w9fM
         g0kjSNXUkZIwmBGGyFvWzQeDsr1cFWh4okm0cYTE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Duoming Zhou <duoming@zju.edu.cn>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 045/124] qlcnic: fix sleep-in-atomic-context bugs caused by msleep
Date:   Mon,  5 Dec 2022 20:09:11 +0100
Message-Id: <20221205190809.718246834@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221205190808.422385173@linuxfoundation.org>
References: <20221205190808.422385173@linuxfoundation.org>
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



