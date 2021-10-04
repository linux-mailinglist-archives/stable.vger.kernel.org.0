Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 294E0420E9F
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 15:25:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236654AbhJDN0q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 09:26:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:37038 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236778AbhJDNY7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Oct 2021 09:24:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8C43D611CA;
        Mon,  4 Oct 2021 13:10:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633353054;
        bh=6Pk4Jc9/09r9O54MJ73BphJ7mA6nAb0PFrVY3CSKJAo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z9qVJqVM6YKB+67Buwa6ur9hfJGJRk+5dmdgmIN6cjkRz3dRrNg6ElLWg0gjsc4rB
         JkkgTQuHfAxVpgKG75cf8cIax6n5z+T6Ks9cp/2yM2p7SHqZT6+TqmCZh+FbBx9nFL
         vNsMrjLtK7GFs5AV+SP2p8qpt0BFWWjW8Aob3WTs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Samuel Iglesias Gonsalvez <siglesias@igalia.com>,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH 5.10 72/93] ipack: ipoctal: fix tty registration race
Date:   Mon,  4 Oct 2021 14:53:10 +0200
Message-Id: <20211004125036.961654303@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211004125034.579439135@linuxfoundation.org>
References: <20211004125034.579439135@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Hovold <johan@kernel.org>

commit 65c001df517a7bf9be8621b53d43c89f426ce8d6 upstream.

Make sure to set the tty class-device driver data before registering the
tty to avoid having a racing open() dereference a NULL pointer.

Fixes: 9c1d784afc6f ("Staging: ipack/devices/ipoctal: Get rid of ipoctal_list.")
Cc: stable@vger.kernel.org      # 3.7
Acked-by: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://lore.kernel.org/r/20210917114622.5412-3-johan@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/ipack/devices/ipoctal.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/ipack/devices/ipoctal.c
+++ b/drivers/ipack/devices/ipoctal.c
@@ -395,13 +395,13 @@ static int ipoctal_inst_slot(struct ipoc
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


