Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D6D26E636A
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 14:40:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231820AbjDRMk3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 08:40:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231794AbjDRMk2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 08:40:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FA0D13C14
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 05:40:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AE8416330B
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 12:40:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3B1FC433D2;
        Tue, 18 Apr 2023 12:40:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681821627;
        bh=zKIvtOe1Alz4MwME8rOlBXRtWuePbmqJq7eVf7NcSKI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YhxNMBWcBGFUlTDwjkBVDuZqnyl+SilnETXgrR7eHY5EZOfCgIuax6vNa6oBGuncb
         yEeHUTmUjkM3A9/bnMbXhxs1Ld2YRCHgXS9P/1P2cexsDLOsWMBTdtsdF9vc2BtzYW
         qZm+vZ675a9Q/jeGMg21V70bslOnziBEMzpkluFg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Sheng Feng <fengsheng5@huawei.com>,
        Yicong Yang <yangyicong@hisilicon.com>,
        Wolfram Sang <wsa@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 42/91] i2c: hisi: Avoid redundant interrupts
Date:   Tue, 18 Apr 2023 14:21:46 +0200
Message-Id: <20230418120307.040358252@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120305.520719816@linuxfoundation.org>
References: <20230418120305.520719816@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
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



