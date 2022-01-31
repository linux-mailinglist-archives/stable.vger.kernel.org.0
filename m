Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A3FE4A44D0
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 12:35:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376965AbiAaLcv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 06:32:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377592AbiAaL1B (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 06:27:01 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2296EC03327E;
        Mon, 31 Jan 2022 03:16:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B5E54611DB;
        Mon, 31 Jan 2022 11:16:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF441C340EE;
        Mon, 31 Jan 2022 11:16:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643627792;
        bh=Ii7bXh798F+1fkbQs8ohe5qE2OvgUqgwk72WPGEicF8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=evc/tphnmuIlq5A5xA/XnsP8Rcq7dUpTEfw5CUVwe3w2MKXLTBwGdJalZiE6olhRa
         nkdTU3dU1WWUaOpgwReTJ+L7ljyyWgfPh9Q8pMl6hcwAZ4rE688ac3Oq4AHqMKvRhP
         +WqBph+wQE8LJZ4uXfRKqWwSkHGqW/6pV2lEVBVw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Matt Kline <matt@bitbashing.io>,
        Chandrasekar Ramakrishnan <rcsekar@samsung.com>,
        Michael Anochin <anochin@photo-meter.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 5.16 009/200] can: m_can: m_can_fifo_{read,write}: dont read or write from/to FIFO if length is 0
Date:   Mon, 31 Jan 2022 11:54:32 +0100
Message-Id: <20220131105233.868161646@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220131105233.561926043@linuxfoundation.org>
References: <20220131105233.561926043@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marc Kleine-Budde <mkl@pengutronix.de>

commit db72589c49fd260bfc99c7160c079675bc7417af upstream.

In order to optimize FIFO access, especially on m_can cores attached
to slow busses like SPI, in patch

| e39381770ec9 ("can: m_can: Disable IRQs on FIFO bus errors")

bulk read/write support has been added to the m_can_fifo_{read,write}
functions.

That change leads to the tcan driver to call
regmap_bulk_{read,write}() with a length of 0 (for CAN frames with 0
data length). regmap treats this as an error:

| tcan4x5x spi1.0 tcan4x5x0: FIFO write returned -22

This patch fixes the problem by not calling the
cdev->ops->{read,write)_fifo() in case of a 0 length read/write.

Fixes: e39381770ec9 ("can: m_can: Disable IRQs on FIFO bus errors")
Link: https://lore.kernel.org/all/20220114155751.2651888-1-mkl@pengutronix.de
Cc: stable@vger.kernel.org
Cc: Matt Kline <matt@bitbashing.io>
Cc: Chandrasekar Ramakrishnan <rcsekar@samsung.com>
Reported-by: Michael Anochin <anochin@photo-meter.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/can/m_can/m_can.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/net/can/m_can/m_can.c
+++ b/drivers/net/can/m_can/m_can.c
@@ -336,6 +336,9 @@ m_can_fifo_read(struct m_can_classdev *c
 	u32 addr_offset = cdev->mcfg[MRAM_RXF0].off + fgi * RXF0_ELEMENT_SIZE +
 		offset;
 
+	if (val_count == 0)
+		return 0;
+
 	return cdev->ops->read_fifo(cdev, addr_offset, val, val_count);
 }
 
@@ -346,6 +349,9 @@ m_can_fifo_write(struct m_can_classdev *
 	u32 addr_offset = cdev->mcfg[MRAM_TXB].off + fpi * TXB_ELEMENT_SIZE +
 		offset;
 
+	if (val_count == 0)
+		return 0;
+
 	return cdev->ops->write_fifo(cdev, addr_offset, val, val_count);
 }
 


