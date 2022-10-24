Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4ED560BA81
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 22:38:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234306AbiJXUhy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 16:37:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234345AbiJXUhU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 16:37:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90CFA3BC63;
        Mon, 24 Oct 2022 11:48:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B16DCB819C9;
        Mon, 24 Oct 2022 12:45:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1273AC433C1;
        Mon, 24 Oct 2022 12:45:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666615528;
        bh=QvZyrofpx2RDc7Q95XGcOIix7KgJLsvg8cGVQruO/Sg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o45Wi3FIdkw4MlwuqlnsvgtndWjzX19br+GpA6DFf7VZ5H/6HJjZt9aYgN8F058X5
         f4NWO+jfqXoaQe8/7qteLlSx/euYBWWiojUuskiwbIOsarkwqHav9E4ROJNbHj60ER
         UoWm3KN0mJG04l7HO/DMSLfKpfWXPARVuJn8Z0zM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Shubhrajyoti Datta <shubhrajyoti.datta@xilinx.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 285/530] tty: xilinx_uartps: Fix the ignore_status
Date:   Mon, 24 Oct 2022 13:30:29 +0200
Message-Id: <20221024113057.949533730@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113044.976326639@linuxfoundation.org>
References: <20221024113044.976326639@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
index d5e243908d9f..815e3e26ee20 100644
--- a/drivers/tty/serial/xilinx_uartps.c
+++ b/drivers/tty/serial/xilinx_uartps.c
@@ -375,6 +375,8 @@ static irqreturn_t cdns_uart_isr(int irq, void *dev_id)
 		isrstatus &= ~CDNS_UART_IXR_TXEMPTY;
 	}
 
+	isrstatus &= port->read_status_mask;
+	isrstatus &= ~port->ignore_status_mask;
 	/*
 	 * Skip RX processing if RX is disabled as RXEMPTY will never be set
 	 * as read bytes will not be removed from the FIFO.
-- 
2.35.1



