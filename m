Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB4743D5DE6
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 17:45:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235937AbhGZPEV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:04:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:44310 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235943AbhGZPES (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:04:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 68CFD60F38;
        Mon, 26 Jul 2021 15:44:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627314287;
        bh=GbOe5nLAvF/9W+HikZFDgRh0jNiyC0ZMZ7uVQnd7KUI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sKg6GzHA8HrQGlEl8JeEIpn/+1cSgbcA8zI5+XtFEtwnjs14Y48WuOWPrSKWUhbUL
         ih6hwcj45oHt3C4geBcd4PQo6HoJDD5sjfEol5+2uChQuwdT8GZ5VyuyOwtWbqSq2x
         7p0mfn/oC5C0jzNe/DkDk1jTgKZqB2MaLprtHVKQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Subject: [PATCH 4.9 51/60] usb: renesas_usbhs: Fix superfluous irqs happen after usb_pkt_pop()
Date:   Mon, 26 Jul 2021 17:39:05 +0200
Message-Id: <20210726153826.473898767@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153824.868160836@linuxfoundation.org>
References: <20210726153824.868160836@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>

commit 5719df243e118fb343725e8b2afb1637e1af1373 upstream.

This driver has a potential issue which this driver is possible to
cause superfluous irqs after usb_pkt_pop() is called. So, after
the commit 3af32605289e ("usb: renesas_usbhs: fix error return
code of usbhsf_pkt_handler()") had been applied, we could observe
the following error happened when we used g_audio.

    renesas_usbhs e6590000.usb: irq_ready run_error 1 : -22

To fix the issue, disable the tx or rx interrupt in usb_pkt_pop().

Fixes: 2743e7f90dc0 ("usb: renesas_usbhs: fix the usb_pkt_pop()")
Cc: <stable@vger.kernel.org> # v4.4+
Signed-off-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Link: https://lore.kernel.org/r/20210624122039.596528-1-yoshihiro.shimoda.uh@renesas.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/renesas_usbhs/fifo.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/usb/renesas_usbhs/fifo.c
+++ b/drivers/usb/renesas_usbhs/fifo.c
@@ -115,6 +115,8 @@ static struct dma_chan *usbhsf_dma_chan_
 #define usbhsf_dma_map(p)	__usbhsf_dma_map_ctrl(p, 1)
 #define usbhsf_dma_unmap(p)	__usbhsf_dma_map_ctrl(p, 0)
 static int __usbhsf_dma_map_ctrl(struct usbhs_pkt *pkt, int map);
+static void usbhsf_tx_irq_ctrl(struct usbhs_pipe *pipe, int enable);
+static void usbhsf_rx_irq_ctrl(struct usbhs_pipe *pipe, int enable);
 struct usbhs_pkt *usbhs_pkt_pop(struct usbhs_pipe *pipe, struct usbhs_pkt *pkt)
 {
 	struct usbhs_priv *priv = usbhs_pipe_to_priv(pipe);
@@ -138,6 +140,11 @@ struct usbhs_pkt *usbhs_pkt_pop(struct u
 			dmaengine_terminate_all(chan);
 			usbhsf_fifo_clear(pipe, fifo);
 			usbhsf_dma_unmap(pkt);
+		} else {
+			if (usbhs_pipe_is_dir_in(pipe))
+				usbhsf_rx_irq_ctrl(pipe, 0);
+			else
+				usbhsf_tx_irq_ctrl(pipe, 0);
 		}
 
 		usbhs_pipe_running(pipe, 0);


