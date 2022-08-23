Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0171F59D5EF
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 11:10:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346435AbiHWIwN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 04:52:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348409AbiHWIv1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 04:51:27 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E354A7D1CF;
        Tue, 23 Aug 2022 01:23:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 6A148CE1B35;
        Tue, 23 Aug 2022 08:17:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78F69C433D6;
        Tue, 23 Aug 2022 08:17:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661242657;
        bh=efGEspcF5pNJAi8jGCXqCYNzKEOJZR9M4Z6Xin4Qk84=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NL0oyUMTEEto/3pzDJII0/HUV9OV3RULYHPHJe7/TxfZUwkaD6gVZ0hWJjf+M8aeh
         bxK9iLhk43ltP5cHvtUoVUhRizxABSamebcbE0vCar3hG8wqrPGmHDQV8Pg630Theo
         fG1LNgZS+4q4IYlmTOJV838kedmMogVnClnwJqKo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Robin Reckmann <robin.reckmann@gmail.com>,
        Luca Weiss <luca.weiss@fairphone.com>,
        Caleb Connolly <caleb@connolly.tech>,
        Konrad Dybcio <konrad.dybcio@somainline.org>,
        Wolfram Sang <wsa@kernel.org>
Subject: [PATCH 5.19 156/365] i2c: qcom-geni: Fix GPI DMA buffer sync-back
Date:   Tue, 23 Aug 2022 10:00:57 +0200
Message-Id: <20220823080124.756891054@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080118.128342613@linuxfoundation.org>
References: <20220823080118.128342613@linuxfoundation.org>
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

From: Robin Reckmann <robin.reckmann@googlemail.com>

commit 8689b80b22dbf1f5e993233370fe57f08731b14d upstream.

Fix i2c transfers using GPI DMA mode for all message types that do not set
the I2C_M_DMA_SAFE flag (e.g. SMBus "read byte").

In this case a bounce buffer is returned by i2c_get_dma_safe_msg_buf(),
and it has to synced back to the message after the transfer is done.

Add missing assignment of dma buffer in geni_i2c_gpi().

Set xferred in i2c_put_dma_safe_msg_buf() to true in case of no error to
ensure the sync-back of this dma buffer to the message.

Fixes: d8703554f4de ("i2c: qcom-geni: Add support for GPI DMA")
Signed-off-by: Robin Reckmann <robin.reckmann@gmail.com>
Tested-by: Luca Weiss <luca.weiss@fairphone.com>
Tested-by: Caleb Connolly <caleb@connolly.tech>
Reviewed-by: Konrad Dybcio <konrad.dybcio@somainline.org>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i2c/busses/i2c-qcom-geni.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/i2c/busses/i2c-qcom-geni.c
+++ b/drivers/i2c/busses/i2c-qcom-geni.c
@@ -484,12 +484,12 @@ static void geni_i2c_gpi_unmap(struct ge
 {
 	if (tx_buf) {
 		dma_unmap_single(gi2c->se.dev->parent, tx_addr, msg->len, DMA_TO_DEVICE);
-		i2c_put_dma_safe_msg_buf(tx_buf, msg, false);
+		i2c_put_dma_safe_msg_buf(tx_buf, msg, !gi2c->err);
 	}
 
 	if (rx_buf) {
 		dma_unmap_single(gi2c->se.dev->parent, rx_addr, msg->len, DMA_FROM_DEVICE);
-		i2c_put_dma_safe_msg_buf(rx_buf, msg, false);
+		i2c_put_dma_safe_msg_buf(rx_buf, msg, !gi2c->err);
 	}
 }
 
@@ -553,6 +553,7 @@ static int geni_i2c_gpi(struct geni_i2c_
 	desc->callback_param = gi2c;
 
 	dmaengine_submit(desc);
+	*buf = dma_buf;
 	*dma_addr_p = addr;
 
 	return 0;


