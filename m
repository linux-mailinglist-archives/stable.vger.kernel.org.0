Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BF2383A95E
	for <lists+stable@lfdr.de>; Sun,  9 Jun 2019 19:10:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388378AbfFIRDR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Jun 2019 13:03:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:41580 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388371AbfFIRDO (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 9 Jun 2019 13:03:14 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D02792145D;
        Sun,  9 Jun 2019 17:03:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560099794;
        bh=fMtF6+aAcAGG8CmxQdMXRhxL2ZRsH3RGfrlSmREcy9M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DybVEg9ushhLcxM1Zfm+qhf45Er7SlMsqS/LLVcqJ5ddLIzPf+mCzNNbyXbjGqdt0
         PpZnWzNAGJyAnH9GxEcZ+JykM7Zzp+735JTx2okBHoFENkydRqm1Gxd7pgpl6PrDw3
         ny9+0liiq6/JjC9klK1WCY4g7Mk5FMbclXaDisHw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, siliu@redhat.com,
        Pankaj Gupta <pagupta@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 167/241] virtio_console: initialize vtermno value for ports
Date:   Sun,  9 Jun 2019 18:41:49 +0200
Message-Id: <20190609164152.596927769@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190609164147.729157653@linuxfoundation.org>
References: <20190609164147.729157653@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 4b0a2c5ff7215206ea6135a405f17c5f6fca7d00 ]

For regular serial ports we do not initialize value of vtermno
variable. A garbage value is assigned for non console ports.
The value can be observed as a random integer with [1].

[1] vim /sys/kernel/debug/virtio-ports/vport*p*

This patch initialize the value of vtermno for console serial
ports to '1' and regular serial ports are initiaized to '0'.

Reported-by: siliu@redhat.com
Signed-off-by: Pankaj Gupta <pagupta@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/virtio_console.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/char/virtio_console.c b/drivers/char/virtio_console.c
index 2aca689061e1f..df9eab91c2d25 100644
--- a/drivers/char/virtio_console.c
+++ b/drivers/char/virtio_console.c
@@ -76,7 +76,7 @@ struct ports_driver_data {
 	/* All the console devices handled by this driver */
 	struct list_head consoles;
 };
-static struct ports_driver_data pdrvdata;
+static struct ports_driver_data pdrvdata = { .next_vtermno = 1};
 
 static DEFINE_SPINLOCK(pdrvdata_lock);
 static DECLARE_COMPLETION(early_console_added);
@@ -1419,6 +1419,7 @@ static int add_port(struct ports_device *portdev, u32 id)
 	port->async_queue = NULL;
 
 	port->cons.ws.ws_row = port->cons.ws.ws_col = 0;
+	port->cons.vtermno = 0;
 
 	port->host_connected = port->guest_connected = false;
 	port->stats = (struct port_stats) { 0 };
-- 
2.20.1



