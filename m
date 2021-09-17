Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52C6840F6D7
	for <lists+stable@lfdr.de>; Fri, 17 Sep 2021 13:50:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343950AbhIQLv1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Sep 2021 07:51:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:34198 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242150AbhIQLv0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 17 Sep 2021 07:51:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1746361244;
        Fri, 17 Sep 2021 11:50:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631879404;
        bh=wgx2hpsJswsOfqwTAmGNgmWN+DwrHT6ApDtd6++mkV8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a8fDqfVlMpM6zshNkanpae2JAcG9BuDFRQJj6F8xgxOtzIqYNbtxKtNqE8kq39u7t
         Get2TELq5gsg3oRL1f04XJvGAbyVVGvymHPOQcMXHdAVwtKLy0fktEU3w/z7fdcf4D
         gQnoffiQcl5KAJLze6ukemMgjP1/cgYDQmfsuMIQb8Bxfm3CgLtalrCYmEQkFra+7c
         a4wXAXInAhonqz7kmm47ZtiDO74R0URdowlPet6dhr7PE+f7LVShWyf8Cy9REBAIiX
         3w8MFzl+yPAtgl0NsKBkJHQ5Hgup43m57WT17wUjHmDKYAhsoo58rAd8CXZQcwsMf+
         J1KKD3icCtX+A==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1mRCNZ-0001RR-NK; Fri, 17 Sep 2021 13:50:05 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Samuel Iglesias Gonsalvez <siglesias@igalia.com>,
        Jens Taprogge <jens.taprogge@taprogge.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     industrypack-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, Johan Hovold <johan@kernel.org>,
        stable@vger.kernel.org
Subject: [PATCH 2/6] ipack: ipoctal: fix tty registration race
Date:   Fri, 17 Sep 2021 13:46:18 +0200
Message-Id: <20210917114622.5412-3-johan@kernel.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210917114622.5412-1-johan@kernel.org>
References: <20210917114622.5412-1-johan@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Make sure to set the tty class-device driver data before registering the
tty to avoid having a racing open() dereference a NULL pointer.

Fixes: 9c1d784afc6f ("Staging: ipack/devices/ipoctal: Get rid of ipoctal_list.")
Cc: stable@vger.kernel.org      # 3.7
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/ipack/devices/ipoctal.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/ipack/devices/ipoctal.c b/drivers/ipack/devices/ipoctal.c
index c62fec75987c..262451343127 100644
--- a/drivers/ipack/devices/ipoctal.c
+++ b/drivers/ipack/devices/ipoctal.c
@@ -392,13 +392,13 @@ static int ipoctal_inst_slot(struct ipoctal *ipoctal, unsigned int bus_nr,
 		spin_lock_init(&channel->lock);
 		channel->pointer_read = 0;
 		channel->pointer_write = 0;
-		tty_dev = tty_port_register_device(&channel->tty_port, tty, i, NULL);
+		tty_dev = tty_port_register_device_attr(&channel->tty_port, tty,
+							i, NULL, channel, NULL);
 		if (IS_ERR(tty_dev)) {
 			dev_err(&ipoctal->dev->dev, "Failed to register tty device.\n");
 			tty_port_destroy(&channel->tty_port);
 			continue;
 		}
-		dev_set_drvdata(tty_dev, channel);
 	}
 
 	/*
-- 
2.32.0

