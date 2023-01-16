Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5FDC66CCAF
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 18:28:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234177AbjAPR2w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 12:28:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234738AbjAPR2Y (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 12:28:24 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9331E5C0D8
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 09:05:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 540B1B81014
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 17:05:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6AECC433EF;
        Mon, 16 Jan 2023 17:05:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673888708;
        bh=j9utuhXSv1AWVOYNkEAE4jfhGt7sAOx3jur8tj7uvpI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SVefBYzoeHq1e5SDGPPZRB4C2OHMq21x503XhdRZLJEabs3jDR3F/F00w9UrRiM4z
         iB/vkxbxgfCYa+LVCqfdOLSHmGSzLq/fyEGT1+zFJL9ddAxXp3Zqmpd/Cv7iQhRbE+
         rtCYvyqQ45GMw55x7nCRpjS20rUEt8e6tVtcnDyg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yang Yingliang <yangyingliang@huawei.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 107/338] mmc: vub300: fix return value check of mmc_add_host()
Date:   Mon, 16 Jan 2023 16:49:40 +0100
Message-Id: <20230116154825.529104263@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154820.689115727@linuxfoundation.org>
References: <20230116154820.689115727@linuxfoundation.org>
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

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit 0613ad2401f88bdeae5594c30afe318e93b14676 ]

mmc_add_host() may return error, if we ignore its return value, the memory
that allocated in mmc_alloc_host() will be leaked and it will lead a kernel
crash because of deleting not added device in the remove path.

So fix this by checking the return value and goto error path which will call
mmc_free_host(), besides, the timer added before mmc_add_host() needs be del.

And this patch fixes another missing call mmc_free_host() if usb_control_msg()
fails.

Fixes: 88095e7b473a ("mmc: Add new VUB300 USB-to-SD/SDIO/MMC driver")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Link: https://lore.kernel.org/r/20221101063023.1664968-9-yangyingliang@huawei.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/host/vub300.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/mmc/host/vub300.c b/drivers/mmc/host/vub300.c
index 71e4392de25a..0d2d748d0b58 100644
--- a/drivers/mmc/host/vub300.c
+++ b/drivers/mmc/host/vub300.c
@@ -2309,14 +2309,14 @@ static int vub300_probe(struct usb_interface *interface,
 				0x0000, 0x0000, &vub300->system_port_status,
 				sizeof(vub300->system_port_status), 1000);
 	if (retval < 0) {
-		goto error4;
+		goto error5;
 	} else if (sizeof(vub300->system_port_status) == retval) {
 		vub300->card_present =
 			(0x0001 & vub300->system_port_status.port_flags) ? 1 : 0;
 		vub300->read_only =
 			(0x0010 & vub300->system_port_status.port_flags) ? 1 : 0;
 	} else {
-		goto error4;
+		goto error5;
 	}
 	usb_set_intfdata(interface, vub300);
 	INIT_DELAYED_WORK(&vub300->pollwork, vub300_pollwork_thread);
@@ -2342,8 +2342,13 @@ static int vub300_probe(struct usb_interface *interface,
 			 "USB vub300 remote SDIO host controller[%d]"
 			 "connected with no SD/SDIO card inserted\n",
 			 interface_to_InterfaceNumber(interface));
-	mmc_add_host(mmc);
+	retval = mmc_add_host(mmc);
+	if (retval)
+		goto error6;
+
 	return 0;
+error6:
+	del_timer_sync(&vub300->inactivity_timer);
 error5:
 	mmc_free_host(mmc);
 	/*
-- 
2.35.1



