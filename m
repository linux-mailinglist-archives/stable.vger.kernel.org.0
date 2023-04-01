Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC12B6D2CAE
	for <lists+stable@lfdr.de>; Sat,  1 Apr 2023 03:43:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233273AbjDABmO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 31 Mar 2023 21:42:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233529AbjDABmH (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 31 Mar 2023 21:42:07 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C8E121AB9;
        Fri, 31 Mar 2023 18:41:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 32222B832F3;
        Sat,  1 Apr 2023 01:41:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4812BC4339B;
        Sat,  1 Apr 2023 01:41:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680313306;
        bh=og1VXg04TCUopqX9IKox5vLheSTvnZlbdsYfs7AKQlo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IOlghgSKUQQiKvDIL2TRRoExoMhVFa1ckxuAKpsLVKh2/90ZOKwWh/OA0a4/vKFcQ
         KlcCcWSr8AG+oov6JmOD1WyKZKFh+hgeXbawzb5Q66xZV7jFycbECXVnCpjB4OShrS
         CNoeKl+SCyfwnVnHmTSFesZJoPQ4E6Nc8PkCk1Ou5ZOTbDgr8esd8BS/8c0pLoyH8L
         Oz126zn6LJPoDREHo/+ea8UfBC0ZgaV06nUjcoSlzXKhKFtvLIdyYT//QF9tYOtWzb
         Bk6+dQm/XJCSr8pYDSBNsK4DHdvkLfhiz5RgIT7h4QXe8Tc8g+TJfOkPFG/gNhQUc2
         3GConBbWFPWwQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yicong Yang <yangyicong@hisilicon.com>,
        Sheng Feng <fengsheng5@huawei.com>,
        Wolfram Sang <wsa@kernel.org>, Sasha Levin <sashal@kernel.org>,
        linux-i2c@vger.kernel.org
Subject: [PATCH AUTOSEL 6.2 10/25] i2c: hisi: Avoid redundant interrupts
Date:   Fri, 31 Mar 2023 21:41:08 -0400
Message-Id: <20230401014126.3356410-10-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230401014126.3356410-1-sashal@kernel.org>
References: <20230401014126.3356410-1-sashal@kernel.org>
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
index f5c37d2f536bc..e067671b3ce2e 100644
--- a/drivers/i2c/busses/i2c-hisi.c
+++ b/drivers/i2c/busses/i2c-hisi.c
@@ -316,6 +316,13 @@ static void hisi_i2c_xfer_msg(struct hisi_i2c_controller *ctlr)
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

