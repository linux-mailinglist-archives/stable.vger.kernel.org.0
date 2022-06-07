Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF0F3540E4F
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 20:54:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353007AbiFGSxx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 14:53:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354526AbiFGSrG (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 14:47:06 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FCE991545;
        Tue,  7 Jun 2022 11:01:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 003D4B82349;
        Tue,  7 Jun 2022 18:01:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 558E1C34119;
        Tue,  7 Jun 2022 18:01:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654624907;
        bh=xJ+H+2CaxHlku3k8gqS+qjfVUzDXWJAwtE4JnyZwM6k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IDvlZZQ6QYRIWSn28FAl2PJZDTXZvO2qCngQlrDpyE2RUSiwH1P4OSbnbYwt3zdhL
         Eedihr2AVuWNS3fXxCo37kaFii/yEmhhybWeerhIYyayld5hhRbrTkryWjps7hlmBy
         8cIOH55U7XYcY7pzmaImJQRrmpQi2i3+tTiQ5/Nd+t5MlKYr8w/D3FEHYuy+g527dN
         WB5OFgBwnjAjlr3No58IPo7OYeAwhujT0tWfST1/5NPMBBODCI6aOHBS4m1sh3SgqB
         t6EMwysGAKUI/hlxdbUj4CV0GhNkd3igeNlWoTXumqbfaUU4P3p16ReA7WTMxBsY96
         sFvPKl49JOj8A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Duoming Zhou <duoming@zju.edu.cn>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, baihaowen@meizu.com,
        dan.carpenter@oracle.com, paskripkin@gmail.com, wjsota@gmail.com,
        dave@stgolabs.net, edumazet@google.com, yangyingliang@huawei.com,
        linux-staging@lists.linux.dev
Subject: [PATCH AUTOSEL 4.19 06/27] drivers: staging: rtl8192e: Fix deadlock in rtllib_beacons_stop()
Date:   Tue,  7 Jun 2022 14:01:10 -0400
Message-Id: <20220607180133.481701-6-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220607180133.481701-1-sashal@kernel.org>
References: <20220607180133.481701-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Duoming Zhou <duoming@zju.edu.cn>

[ Upstream commit 9b6bdbd9337de3917945847bde262a34a87a6303 ]

There is a deadlock in rtllib_beacons_stop(), which is shown
below:

   (Thread 1)              |      (Thread 2)
                           | rtllib_send_beacon()
rtllib_beacons_stop()      |  mod_timer()
 spin_lock_irqsave() //(1) |  (wait a time)
 ...                       | rtllib_send_beacon_cb()
 del_timer_sync()          |  spin_lock_irqsave() //(2)
 (wait timer to stop)      |  ...

We hold ieee->beacon_lock in position (1) of thread 1 and
use del_timer_sync() to wait timer to stop, but timer handler
also need ieee->beacon_lock in position (2) of thread 2.
As a result, rtllib_beacons_stop() will block forever.

This patch extracts del_timer_sync() from the protection of
spin_lock_irqsave(), which could let timer handler to obtain
the needed lock.

Signed-off-by: Duoming Zhou <duoming@zju.edu.cn>
Link: https://lore.kernel.org/r/20220417141641.124388-1-duoming@zju.edu.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/rtl8192e/rtllib_softmac.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/rtl8192e/rtllib_softmac.c b/drivers/staging/rtl8192e/rtllib_softmac.c
index 919231fec09c..5f1dd4e2d12e 100644
--- a/drivers/staging/rtl8192e/rtllib_softmac.c
+++ b/drivers/staging/rtl8192e/rtllib_softmac.c
@@ -654,9 +654,9 @@ static void rtllib_beacons_stop(struct rtllib_device *ieee)
 	spin_lock_irqsave(&ieee->beacon_lock, flags);
 
 	ieee->beacon_txing = 0;
-	del_timer_sync(&ieee->beacon_timer);
 
 	spin_unlock_irqrestore(&ieee->beacon_lock, flags);
+	del_timer_sync(&ieee->beacon_timer);
 
 }
 
-- 
2.35.1

