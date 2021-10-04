Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0BC2420B95
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 14:56:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233954AbhJDM6R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 08:58:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:59554 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233977AbhJDM5c (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Oct 2021 08:57:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5BE9E613C8;
        Mon,  4 Oct 2021 12:55:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633352143;
        bh=gHFMhGAaO10T6p9SaF6TCYykqJsnVasi791xcp+XVF8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Njbn300XQ68VM+2JJIq5SjG/V+WoZn9Wh7JAvX/reCxAuenJaz/NmXLyMJ6XGZ+UH
         jkrNcKnCnmCTLjh3cmwpV9WBm5bxGdr3cVICq85iKyl69Xh/YHQ9uv+8jjFbUpUBdO
         9nGSl5zf8vpAP7CTNBvtvdkfwmyUAXGTtxqiv0Ow=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Samuel Iglesias Gonsalvez <siglesias@igalia.com>,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH 4.4 32/41] ipack: ipoctal: fix tty-registration error handling
Date:   Mon,  4 Oct 2021 14:52:23 +0200
Message-Id: <20211004125027.601017563@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211004125026.597501645@linuxfoundation.org>
References: <20211004125026.597501645@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Hovold <johan@kernel.org>

commit cd20d59291d1790dc74248476e928f57fc455189 upstream.

Registration of the ipoctal tty devices is unlikely to fail, but if it
ever does, make sure not to deregister a never registered tty device
(and dereference a NULL pointer) when the driver is later unbound.

Fixes: 2afb41d9d30d ("Staging: ipack/devices/ipoctal: Check tty_register_device return value.")
Cc: stable@vger.kernel.org      # 3.7
Acked-by: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://lore.kernel.org/r/20210917114622.5412-4-johan@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/ipack/devices/ipoctal.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/ipack/devices/ipoctal.c
+++ b/drivers/ipack/devices/ipoctal.c
@@ -38,6 +38,7 @@ struct ipoctal_channel {
 	unsigned int			pointer_read;
 	unsigned int			pointer_write;
 	struct tty_port			tty_port;
+	bool				tty_registered;
 	union scc2698_channel __iomem	*regs;
 	union scc2698_block __iomem	*block_regs;
 	unsigned int			board_id;
@@ -402,9 +403,11 @@ static int ipoctal_inst_slot(struct ipoc
 							i, NULL, channel, NULL);
 		if (IS_ERR(tty_dev)) {
 			dev_err(&ipoctal->dev->dev, "Failed to register tty device.\n");
+			tty_port_free_xmit_buf(&channel->tty_port);
 			tty_port_destroy(&channel->tty_port);
 			continue;
 		}
+		channel->tty_registered = true;
 	}
 
 	/*
@@ -706,6 +709,10 @@ static void __ipoctal_remove(struct ipoc
 
 	for (i = 0; i < NR_CHANNELS; i++) {
 		struct ipoctal_channel *channel = &ipoctal->channel[i];
+
+		if (!channel->tty_registered)
+			continue;
+
 		tty_unregister_device(ipoctal->tty_drv, i);
 		tty_port_free_xmit_buf(&channel->tty_port);
 		tty_port_destroy(&channel->tty_port);


