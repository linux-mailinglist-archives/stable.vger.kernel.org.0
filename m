Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA05040F6D4
	for <lists+stable@lfdr.de>; Fri, 17 Sep 2021 13:50:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242247AbhIQLv0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Sep 2021 07:51:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:34174 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240718AbhIQLv0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 17 Sep 2021 07:51:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 104C2611C8;
        Fri, 17 Sep 2021 11:50:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631879404;
        bh=db+fBwb7w4mcFWM+a2SxD0qQqbLVfAV0BytKC90zxC4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NgGlv1gt/1NVSHZLGv5HrIgaVB/hU9dDJQCH7EQB3fsaJM80uvO3T9UGqVZ/ZAMZm
         CtSSBKIIxAWaYxEE9JRAvpIUKZW3shAnZ6VqNN+e8wA1DvHdyYZGO/ZsOMiRvCQu98
         hYlgSJdNllf/KGUDkJpz0zFX0fuO1UZNT8nIKA6F0GsM8eD5nG/084DKCctSpGG9+A
         s58WoYMzYLPErxY/J+6hed+ije8A2tdTcmtbifcyJUOdx1FwQl2XTWv5/wDrmeqmsH
         63PvGOiFhDDmwRI1TVaADT775g4IhLciZkD07X8AI8yvDXR1ODKMOYnFnekU4OLPgD
         Ry0YOBm1aaUfw==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1mRCNZ-0001RU-QD; Fri, 17 Sep 2021 13:50:05 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Samuel Iglesias Gonsalvez <siglesias@igalia.com>,
        Jens Taprogge <jens.taprogge@taprogge.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     industrypack-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, Johan Hovold <johan@kernel.org>,
        stable@vger.kernel.org
Subject: [PATCH 3/6] ipack: ipoctal: fix tty-registration error handling
Date:   Fri, 17 Sep 2021 13:46:19 +0200
Message-Id: <20210917114622.5412-4-johan@kernel.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210917114622.5412-1-johan@kernel.org>
References: <20210917114622.5412-1-johan@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Registration of the ipoctal tty devices is unlikely to fail, but if it
ever does, make sure not to deregister a never registered tty device
(and dereference a NULL pointer) when the driver is later unbound.

Fixes: 2afb41d9d30d ("Staging: ipack/devices/ipoctal: Check tty_register_device return value.")
Cc: stable@vger.kernel.org      # 3.7
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/ipack/devices/ipoctal.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/ipack/devices/ipoctal.c b/drivers/ipack/devices/ipoctal.c
index 262451343127..d6875aa6a295 100644
--- a/drivers/ipack/devices/ipoctal.c
+++ b/drivers/ipack/devices/ipoctal.c
@@ -33,6 +33,7 @@ struct ipoctal_channel {
 	unsigned int			pointer_read;
 	unsigned int			pointer_write;
 	struct tty_port			tty_port;
+	bool				tty_registered;
 	union scc2698_channel __iomem	*regs;
 	union scc2698_block __iomem	*block_regs;
 	unsigned int			board_id;
@@ -396,9 +397,11 @@ static int ipoctal_inst_slot(struct ipoctal *ipoctal, unsigned int bus_nr,
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
@@ -698,6 +701,10 @@ static void __ipoctal_remove(struct ipoctal *ipoctal)
 
 	for (i = 0; i < NR_CHANNELS; i++) {
 		struct ipoctal_channel *channel = &ipoctal->channel[i];
+
+		if (!channel->tty_registered)
+			continue;
+
 		tty_unregister_device(ipoctal->tty_drv, i);
 		tty_port_free_xmit_buf(&channel->tty_port);
 		tty_port_destroy(&channel->tty_port);
-- 
2.32.0

