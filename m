Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51808469C73
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:19:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356994AbhLFPWb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:22:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376557AbhLFPUh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:20:37 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68740C08E84D;
        Mon,  6 Dec 2021 07:14:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 077A1612EB;
        Mon,  6 Dec 2021 15:14:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E148BC341C1;
        Mon,  6 Dec 2021 15:14:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638803655;
        bh=v5OnXFIzNoHpTxFbEu11cJ1Cmar+jDZkPLdfGLe9UHc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mzaVesjzImgs5Tf5xjg3re1Bto5hygrfm6m/vIUQRMUms7o1tt1hIR0G/MHlxUuMZ
         q4F6mHHDNLcz0kzx0cZ8EqMck+YSiViR9mclzOVinLyObiqIu1/U6KEadvlAuv7BxZ
         +zL0EHefFqva7sejAXsbM09wIsevwXqKL1rcvO+8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sven Eckelmann <sven@narfation.org>
Subject: [PATCH 5.4 62/70] tty: serial: msm_serial: Deactivate RX DMA for polling support
Date:   Mon,  6 Dec 2021 15:57:06 +0100
Message-Id: <20211206145554.066157339@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211206145551.909846023@linuxfoundation.org>
References: <20211206145551.909846023@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sven Eckelmann <sven@narfation.org>

commit 7492ffc90fa126afb67d4392d56cb4134780194a upstream.

The CONSOLE_POLLING mode is used for tools like k(g)db. In this kind of
setup, it is often sharing a serial device with the normal system console.
This is usually no problem because the polling helpers can consume input
values directly (when in kgdb context) and the normal Linux handlers can
only consume new input values after kgdb switched back.

This is not true anymore when RX DMA is enabled for UARTDM controllers.
Single input values can no longer be received correctly. Instead following
seems to happen:

* on 1. input, some old input is read (continuously)
* on 2. input, two old inputs are read (continuously)
* on 3. input, three old input values are read (continuously)
* on 4. input, 4 previous inputs are received

This repeats then for each group of 4 input values.

This behavior changes slightly depending on what state the controller was
when the first input was received. But this makes working with kgdb
basically impossible because control messages are always corrupted when
kgdboc tries to parse them.

RX DMA should therefore be off when CONSOLE_POLLING is enabled to avoid
these kind of problems. No such problem was noticed for TX DMA.

Fixes: 99693945013a ("tty: serial: msm: Add RX DMA support")
Cc: stable@vger.kernel.org
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Link: https://lore.kernel.org/r/20211113121050.7266-1-sven@narfation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/msm_serial.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/tty/serial/msm_serial.c
+++ b/drivers/tty/serial/msm_serial.c
@@ -603,6 +603,9 @@ static void msm_start_rx_dma(struct msm_
 	u32 val;
 	int ret;
 
+	if (IS_ENABLED(CONFIG_CONSOLE_POLL))
+		return;
+
 	if (!dma->chan)
 		return;
 


