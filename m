Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9576469BA5
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:14:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356165AbhLFPSG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:18:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357451AbhLFPQG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:16:06 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3448AC08EA74;
        Mon,  6 Dec 2021 07:08:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F094CB8111A;
        Mon,  6 Dec 2021 15:08:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B7F9C341CA;
        Mon,  6 Dec 2021 15:08:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638803314;
        bh=fzhFtjV0JZA5MKmOFmqC9SL+v6z0pKoJd1YZyse+dYU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uZOuVUXlUv2FbT4yYiyhAVuUz8PaNynRB5mC5Ehq5jFAvGpy3w5Ze0ZBHBDoEsis1
         UpXxL1RaiuBtWW/ryVRjmV6/oKDzXsCrsWudRGMlBcANsQDjT5y5OOir+YzYJR4qif
         8ymg7pyNLWNN1FTmO9AMrfUcKpjQfsummra88u7s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sven Eckelmann <sven@narfation.org>
Subject: [PATCH 4.14 103/106] tty: serial: msm_serial: Deactivate RX DMA for polling support
Date:   Mon,  6 Dec 2021 15:56:51 +0100
Message-Id: <20211206145559.115046810@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211206145555.386095297@linuxfoundation.org>
References: <20211206145555.386095297@linuxfoundation.org>
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
@@ -611,6 +611,9 @@ static void msm_start_rx_dma(struct msm_
 	u32 val;
 	int ret;
 
+	if (IS_ENABLED(CONFIG_CONSOLE_POLL))
+		return;
+
 	if (!dma->chan)
 		return;
 


