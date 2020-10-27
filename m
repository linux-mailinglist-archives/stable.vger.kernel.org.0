Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50E3729B463
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 16:04:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1783304AbgJ0PBb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:01:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:35352 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1788970AbgJ0PB3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:01:29 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 01AFB22264;
        Tue, 27 Oct 2020 15:01:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603810888;
        bh=4pUed4VROy9nOj/9XsiIeRnGe9h+xTjtWlpgp4aG6bY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FxEnebD3R4oHPpiwHBdpkbDu1eOtRYrddHsbwSVxk1FZddTuOSQmN1iEy3NHmoqXt
         GvmMa/ZBqHXK5XN8dxsc/Qza0JGXYP8rjxtDKIvdBVOe/4bM/xyWRT4wmLBlxUXyVT
         LUKwtTLWrOCADQql/eQg6Nx86HzpyrH5LXF632vs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        Linh Phung <linh.phung.jy@renesas.com>,
        Tam Nguyen <tam.nguyen.xa@renesas.com>,
        Felipe Balbi <balbi@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 298/633] usb: gadget: u_serial: clear suspended flag when disconnecting
Date:   Tue, 27 Oct 2020 14:50:41 +0100
Message-Id: <20201027135536.650544510@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135522.655719020@linuxfoundation.org>
References: <20201027135522.655719020@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>

[ Upstream commit d98ef43bfb65b5201e1afe36aaf8c4f9d71b4307 ]

The commit aba3a8d01d62 ("usb: gadget: u_serial: add suspend resume
callbacks") set/cleared the suspended flag in USB bus suspend/resume
only. But, when a USB cable is disconnected in the suspend, since some
controllers will not detect USB bus resume, the suspended flag is not
cleared. After that, user cannot send any data. To fix the issue,
clears the suspended flag in the gserial_disconnect().

Fixes: aba3a8d01d62 ("usb: gadget: u_serial: add suspend resume callbacks")
Signed-off-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Tested-by: Linh Phung <linh.phung.jy@renesas.com>
Tested-by: Tam Nguyen <tam.nguyen.xa@renesas.com>
Signed-off-by: Felipe Balbi <balbi@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/gadget/function/u_serial.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/usb/gadget/function/u_serial.c b/drivers/usb/gadget/function/u_serial.c
index 3cfc6e2eba71a..e0e3cb2f6f3bc 100644
--- a/drivers/usb/gadget/function/u_serial.c
+++ b/drivers/usb/gadget/function/u_serial.c
@@ -1391,6 +1391,7 @@ void gserial_disconnect(struct gserial *gser)
 		if (port->port.tty)
 			tty_hangup(port->port.tty);
 	}
+	port->suspended = false;
 	spin_unlock_irqrestore(&port->port_lock, flags);
 
 	/* disable endpoints, aborting down any active I/O */
-- 
2.25.1



