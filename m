Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4171E2F262
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 06:22:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729095AbfE3EVL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 May 2019 00:21:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:37858 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730182AbfE3DPP (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:15:15 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9E89024555;
        Thu, 30 May 2019 03:15:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559186114;
        bh=dJfhr74dfhlzBQ06oDacfJP3wgeQgcEy2cx2MN0M1ss=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=y1OApNmR/LCwrSjWkESRNfJJ4vzvecRIr8/Epy2ftWiXH3MuVoXkQThHWu/T5mWiN
         sIjS7zPQoesVoW/a4N11G2YJ8I5p3+M6C+/42CrHBcdk3ylRZq6h680YJYTDjpKe2U
         KLd14k2Sw0WrnQCy78Vto/IRr0cjZejsgozhXtRk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, siliu@redhat.com,
        Pankaj Gupta <pagupta@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.0 266/346] virtio_console: initialize vtermno value for ports
Date:   Wed, 29 May 2019 20:05:39 -0700
Message-Id: <20190530030554.455579593@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030540.363386121@linuxfoundation.org>
References: <20190530030540.363386121@linuxfoundation.org>
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
index fbeb71953526a..05dbfdb9f4aff 100644
--- a/drivers/char/virtio_console.c
+++ b/drivers/char/virtio_console.c
@@ -75,7 +75,7 @@ struct ports_driver_data {
 	/* All the console devices handled by this driver */
 	struct list_head consoles;
 };
-static struct ports_driver_data pdrvdata;
+static struct ports_driver_data pdrvdata = { .next_vtermno = 1};
 
 static DEFINE_SPINLOCK(pdrvdata_lock);
 static DECLARE_COMPLETION(early_console_added);
@@ -1394,6 +1394,7 @@ static int add_port(struct ports_device *portdev, u32 id)
 	port->async_queue = NULL;
 
 	port->cons.ws.ws_row = port->cons.ws.ws_col = 0;
+	port->cons.vtermno = 0;
 
 	port->host_connected = port->guest_connected = false;
 	port->stats = (struct port_stats) { 0 };
-- 
2.20.1



