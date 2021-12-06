Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78719469A4D
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:04:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345631AbhLFPHF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:07:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344956AbhLFPE2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:04:28 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C9F7C0698D3;
        Mon,  6 Dec 2021 07:01:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B12E061322;
        Mon,  6 Dec 2021 15:00:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99F54C341C2;
        Mon,  6 Dec 2021 15:00:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638802859;
        bh=tzrRvf/+l3VoRpurkwVSnZigQa5kJGOJkaBpcQq8KpQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DZgrcwjQ3S2W+JFbYWrwMW4YiZxPy2WgnFVHh3CenQlkyoN3Kwch2fKLh3uy4boCR
         9eO3kUOSHRDB2RnHEppi3cIGUqkhVRQQndFrP86D2E9QjB2xP9Rw59dNAukRZgeFK5
         dXQ1GH1/S4HNwgONx8tkUdja0Kfdg60KzDfgZ0MU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sven Eckelmann <sven@narfation.org>
Subject: [PATCH 4.4 51/52] tty: serial: msm_serial: Deactivate RX DMA for polling support
Date:   Mon,  6 Dec 2021 15:56:35 +0100
Message-Id: <20211206145549.633835750@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211206145547.892668902@linuxfoundation.org>
References: <20211206145547.892668902@linuxfoundation.org>
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
@@ -446,6 +446,9 @@ static void msm_start_rx_dma(struct msm_
 	u32 val;
 	int ret;
 
+	if (IS_ENABLED(CONFIG_CONSOLE_POLL))
+		return;
+
 	if (!dma->chan)
 		return;
 


