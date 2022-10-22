Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EFCB660882C
	for <lists+stable@lfdr.de>; Sat, 22 Oct 2022 10:11:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233165AbiJVILB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Oct 2022 04:11:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233427AbiJVIJt (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Oct 2022 04:09:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDB572CA7EC;
        Sat, 22 Oct 2022 00:54:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ED92060B82;
        Sat, 22 Oct 2022 07:53:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E80AFC433D7;
        Sat, 22 Oct 2022 07:53:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666425201;
        bh=hqNac0gTxsglYnMmGMAxm6Y4F9sO9iFM2+9XX3B3yuA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cPw8gRNnJFNA8JT//uCCmL6Fw5UMkO/RgqHinJW0/HR/i89BIbd+pEcLsgKM47c3/
         dQzwgZbRt9SZjogJwdI6M0+FPx3bsGoWX5WYTo+aMq92/hf+QwVJ5tMrz599xnqRhn
         cintvDN5QY9kpDTVlbp8OooJFK4EwULOgN5vPaf8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Shubhrajyoti Datta <shubhrajyoti.datta@xilinx.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 395/717] tty: xilinx_uartps: Fix the ignore_status
Date:   Sat, 22 Oct 2022 09:24:34 +0200
Message-Id: <20221022072515.268051620@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221022072415.034382448@linuxfoundation.org>
References: <20221022072415.034382448@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shubhrajyoti Datta <shubhrajyoti.datta@xilinx.com>

[ Upstream commit b8a6c3b3d4654fba19881cc77da61eac29f57cae ]

Currently the ignore_status is not considered in the isr.
Add a check to add the ignore_status.

Fixes: 61ec9016988f ("tty/serial: add support for Xilinx PS UART")
Signed-off-by: Shubhrajyoti Datta <shubhrajyoti.datta@xilinx.com>
Link: https://lore.kernel.org/r/20220729114748.18332-5-shubhrajyoti.datta@xilinx.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/xilinx_uartps.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/tty/serial/xilinx_uartps.c b/drivers/tty/serial/xilinx_uartps.c
index 9e01fe6c0ab8..e08d2c3305ba 100644
--- a/drivers/tty/serial/xilinx_uartps.c
+++ b/drivers/tty/serial/xilinx_uartps.c
@@ -361,6 +361,8 @@ static irqreturn_t cdns_uart_isr(int irq, void *dev_id)
 		isrstatus &= ~CDNS_UART_IXR_TXEMPTY;
 	}
 
+	isrstatus &= port->read_status_mask;
+	isrstatus &= ~port->ignore_status_mask;
 	/*
 	 * Skip RX processing if RX is disabled as RXEMPTY will never be set
 	 * as read bytes will not be removed from the FIFO.
-- 
2.35.1



