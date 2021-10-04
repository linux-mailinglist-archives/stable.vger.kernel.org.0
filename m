Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04DEB420DC9
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 15:17:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235829AbhJDNTE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 09:19:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:55644 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235309AbhJDNRT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Oct 2021 09:17:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A4F8B6136F;
        Mon,  4 Oct 2021 13:06:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633352819;
        bh=wZMgo4gl+2tQup07NRFHpMI01h3M95+MqkaaMPs4i2U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SZsHnlEQMoBE7RLJi6xLtuOfVTIpaci+WhqglRWG4MApMEs/Qele70Rwnf66mndG/
         kHaPq0bzFlo0XYeGsCe8Xwo7Xj+ZK1tCMOZvFRjoqcZecSs7W5avUvrNlylmDAp+K+
         m3GOksBuUSWueAP18RpE+rdaiFSD6HSHGt3isCFY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Samuel Iglesias Gonsalvez <siglesias@igalia.com>,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH 5.4 38/56] ipack: ipoctal: fix tty-registration error handling
Date:   Mon,  4 Oct 2021 14:52:58 +0200
Message-Id: <20211004125031.197743938@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211004125030.002116402@linuxfoundation.org>
References: <20211004125030.002116402@linuxfoundation.org>
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
@@ -35,6 +35,7 @@ struct ipoctal_channel {
 	unsigned int			pointer_read;
 	unsigned int			pointer_write;
 	struct tty_port			tty_port;
+	bool				tty_registered;
 	union scc2698_channel __iomem	*regs;
 	union scc2698_block __iomem	*block_regs;
 	unsigned int			board_id;
@@ -399,9 +400,11 @@ static int ipoctal_inst_slot(struct ipoc
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
@@ -702,6 +705,10 @@ static void __ipoctal_remove(struct ipoc
 
 	for (i = 0; i < NR_CHANNELS; i++) {
 		struct ipoctal_channel *channel = &ipoctal->channel[i];
+
+		if (!channel->tty_registered)
+			continue;
+
 		tty_unregister_device(ipoctal->tty_drv, i);
 		tty_port_free_xmit_buf(&channel->tty_port);
 		tty_port_destroy(&channel->tty_port);


