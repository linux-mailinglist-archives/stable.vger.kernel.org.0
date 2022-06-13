Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 152E7548E06
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:17:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378727AbiFMNmd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 09:42:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379261AbiFMNkJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 09:40:09 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2354E201B8;
        Mon, 13 Jun 2022 04:31:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B7A43B80D3A;
        Mon, 13 Jun 2022 11:31:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EAB0C34114;
        Mon, 13 Jun 2022 11:31:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655119862;
        bh=gJVpB7T37wyoUJOyInE1sOTyR+6HawgA6LXykwcBDEg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NJrxWNvP1GRFA0lT8ISbKmPGfQc6LnAVd0Ovy7IymIsUoeeM1FKAPcOlu1QFgdQ98
         YTFt6bH1u9vntH6O2TTb87iTpDX2GqWW+aMwuKS1/SHx7WfIdAt2Tol2Kg1B8RkgbW
         Nk00coEGk6BeiSDLZaWuPm/R43QO7YTqxmQ5Nx0k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Lucas Tanure <tanureal@opensource.cirrus.com>,
        Michal Simek <michal.simek@xilinx.com>,
        Wolfram Sang <wsa@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 165/339] i2c: cadence: Increase timeout per message if necessary
Date:   Mon, 13 Jun 2022 12:09:50 +0200
Message-Id: <20220613094931.686510988@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094926.497929857@linuxfoundation.org>
References: <20220613094926.497929857@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Lucas Tanure <tanureal@opensource.cirrus.com>

[ Upstream commit 96789dce043f5bff8b7d62aa28d52a7c59403a84 ]

Timeout as 1 second sets an upper limit on the length
of the transfer executed, but there is no maximum length
of a write or read message set in i2c_adapter_quirks for
this controller.

This upper limit affects devices that require sending
large firmware blobs over I2C.

To remove that limitation, calculate the minimal time
necessary, plus some wiggle room, for every message and
use it instead of the default one second, if more than
one second.

Signed-off-by: Lucas Tanure <tanureal@opensource.cirrus.com>
Acked-by: Michal Simek <michal.simek@xilinx.com>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-cadence.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/i2c/busses/i2c-cadence.c b/drivers/i2c/busses/i2c-cadence.c
index 805c77143a0f..b4c1ad19cdae 100644
--- a/drivers/i2c/busses/i2c-cadence.c
+++ b/drivers/i2c/busses/i2c-cadence.c
@@ -760,7 +760,7 @@ static void cdns_i2c_master_reset(struct i2c_adapter *adap)
 static int cdns_i2c_process_msg(struct cdns_i2c *id, struct i2c_msg *msg,
 		struct i2c_adapter *adap)
 {
-	unsigned long time_left;
+	unsigned long time_left, msg_timeout;
 	u32 reg;
 
 	id->p_msg = msg;
@@ -785,8 +785,16 @@ static int cdns_i2c_process_msg(struct cdns_i2c *id, struct i2c_msg *msg,
 	else
 		cdns_i2c_msend(id);
 
+	/* Minimal time to execute this message */
+	msg_timeout = msecs_to_jiffies((1000 * msg->len * BITS_PER_BYTE) / id->i2c_clk);
+	/* Plus some wiggle room */
+	msg_timeout += msecs_to_jiffies(500);
+
+	if (msg_timeout < adap->timeout)
+		msg_timeout = adap->timeout;
+
 	/* Wait for the signal of completion */
-	time_left = wait_for_completion_timeout(&id->xfer_done, adap->timeout);
+	time_left = wait_for_completion_timeout(&id->xfer_done, msg_timeout);
 	if (time_left == 0) {
 		cdns_i2c_master_reset(adap);
 		dev_err(id->adap.dev.parent,
-- 
2.35.1



