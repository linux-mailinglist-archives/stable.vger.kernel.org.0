Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF5426CC2C3
	for <lists+stable@lfdr.de>; Tue, 28 Mar 2023 16:48:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233381AbjC1Osa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Mar 2023 10:48:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233330AbjC1OsQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Mar 2023 10:48:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B067BDD1
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 07:48:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4AEFB617F0
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 14:47:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B478C433EF;
        Tue, 28 Mar 2023 14:47:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680014831;
        bh=Ro01yHkj9Yt6ZaFmtZ2dNvqxD6A/0MxbW4UClH76OEM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=L9PLnpODsxX4G0VRs5sCXuUBRqMDdeOHrcNmB3aTgxPwy9OqckI1PUq2C/Cg4JrQX
         AGxV8mcauI6McCD0eYMgeBMEElYnfmsPNdTFe0eB7b/RbdwXyDi5f9h+z5mimKKtnO
         qoCBSYEvVXEQHUU2l/2Ne/Zz73PxfE+Je3mZTwho=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Sheng Feng <fengsheng5@huawei.com>,
        Yicong Yang <yangyicong@hisilicon.com>,
        Wolfram Sang <wsa@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 038/240] i2c: hisi: Only use the completion interrupt to finish the transfer
Date:   Tue, 28 Mar 2023 16:40:01 +0200
Message-Id: <20230328142621.185116641@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230328142619.643313678@linuxfoundation.org>
References: <20230328142619.643313678@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

[ Upstream commit d98263512684a47e81bcb72a5408958ecd1e60b0 ]

The controller will always generate a completion interrupt when the
transfer is finished normally or not. Currently we use either error or
completion interrupt to finish, this may result the completion
interrupt unhandled and corrupt the next transfer, especially at low
speed mode. Since on error case, the error interrupt will come first
then is the completion interrupt. So only use the completion interrupt
to finish the whole transfer process.

Fixes: d62fbdb99a85 ("i2c: add support for HiSilicon I2C controller")
Reported-by: Sheng Feng <fengsheng5@huawei.com>
Signed-off-by: Sheng Feng <fengsheng5@huawei.com>
Signed-off-by: Yicong Yang <yangyicong@hisilicon.com>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-hisi.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/i2c/busses/i2c-hisi.c b/drivers/i2c/busses/i2c-hisi.c
index 8c6c7075c765c..f5c37d2f536bc 100644
--- a/drivers/i2c/busses/i2c-hisi.c
+++ b/drivers/i2c/busses/i2c-hisi.c
@@ -341,7 +341,11 @@ static irqreturn_t hisi_i2c_irq(int irq, void *context)
 		hisi_i2c_read_rx_fifo(ctlr);
 
 out:
-	if (int_stat & HISI_I2C_INT_TRANS_CPLT || ctlr->xfer_err) {
+	/*
+	 * Only use TRANS_CPLT to indicate the completion. On error cases we'll
+	 * get two interrupts, INT_ERR first then TRANS_CPLT.
+	 */
+	if (int_stat & HISI_I2C_INT_TRANS_CPLT) {
 		hisi_i2c_disable_int(ctlr, HISI_I2C_INT_ALL);
 		hisi_i2c_clear_int(ctlr, HISI_I2C_INT_ALL);
 		complete(ctlr->completion);
-- 
2.39.2



