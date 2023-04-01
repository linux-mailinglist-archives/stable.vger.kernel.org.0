Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8AD326D2D74
	for <lists+stable@lfdr.de>; Sat,  1 Apr 2023 03:56:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233996AbjDAB4Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 31 Mar 2023 21:56:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233999AbjDAB4K (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 31 Mar 2023 21:56:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D99A12220C;
        Fri, 31 Mar 2023 18:53:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0161162D13;
        Sat,  1 Apr 2023 01:44:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B72ACC433EF;
        Sat,  1 Apr 2023 01:43:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680313439;
        bh=zKIvtOe1Alz4MwME8rOlBXRtWuePbmqJq7eVf7NcSKI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OzCbYb61xgtG9rmR4VKBQuMD4pEUrkNRBpvgbmdLRBEzMmmfzj5VLdF58U23Op5L+
         oH6O5HBPgS+OknlJQQteLcQ8LESyvSxGfbS3uuIXA9hu5RUquBlfWYyZQ8kWjscBB8
         GvQJmL8TbuIsonrcf/hb5vC3bExZ08l8JYUheQ1N8vY4xTMVEosjuNVRCpl3BxoVP9
         oAZe9eHnY9UYCHBx6BpHlDrGAtJWjrF8NcbWTmLdKa2eYbpsUdrkKLyhD72h1g4Fh4
         KgJzeoecHb0E/nNjXBXt1U6RBygfNVrTDBnIYxBAHaciZv15z9EW/7Ml7lzI3DATjF
         vU23mrTm35tpA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yicong Yang <yangyicong@hisilicon.com>,
        Sheng Feng <fengsheng5@huawei.com>,
        Wolfram Sang <wsa@kernel.org>, Sasha Levin <sashal@kernel.org>,
        linux-i2c@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 05/11] i2c: hisi: Avoid redundant interrupts
Date:   Fri, 31 Mar 2023 21:43:43 -0400
Message-Id: <20230401014350.3357107-5-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230401014350.3357107-1-sashal@kernel.org>
References: <20230401014350.3357107-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yicong Yang <yangyicong@hisilicon.com>

[ Upstream commit cc9812a3096d1986caca9a23bee99effc45c08df ]

After issuing all the messages we can disable the TX_EMPTY interrupts
to avoid handling redundant interrupts. For doing a sinlge bus
detection (i2cdetect -y -r 0) we can reduce ~97% interrupts (before
~12000 after ~400).

Signed-off-by: Sheng Feng <fengsheng5@huawei.com>
Signed-off-by: Yicong Yang <yangyicong@hisilicon.com>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-hisi.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/i2c/busses/i2c-hisi.c b/drivers/i2c/busses/i2c-hisi.c
index 72e43ecaff133..1f406e6f4ece3 100644
--- a/drivers/i2c/busses/i2c-hisi.c
+++ b/drivers/i2c/busses/i2c-hisi.c
@@ -315,6 +315,13 @@ static void hisi_i2c_xfer_msg(struct hisi_i2c_controller *ctlr)
 		    max_write == 0)
 			break;
 	}
+
+	/*
+	 * Disable the TX_EMPTY interrupt after finishing all the messages to
+	 * avoid overwhelming the CPU.
+	 */
+	if (ctlr->msg_tx_idx == ctlr->msg_num)
+		hisi_i2c_disable_int(ctlr, HISI_I2C_INT_TX_EMPTY);
 }
 
 static irqreturn_t hisi_i2c_irq(int irq, void *context)
-- 
2.39.2

