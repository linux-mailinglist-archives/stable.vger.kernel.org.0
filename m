Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 457692EFFD
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 06:01:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730143AbfE3DSZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 May 2019 23:18:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:50856 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731535AbfE3DSZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:18:25 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 716282479B;
        Thu, 30 May 2019 03:18:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559186304;
        bh=0BK1sgaU5LR/sd1M8lx0WjOwW1JgDyFaTY3j81AsQKM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b58sU1oWAf4t95IbV9yYFl1RbyZC6dbqtTro3mlYefI70qWQ839tmGlOaYPuCXX65
         axuNOF9+JRBjwb8hUhymKOwpCqThKHvPDiuqQx9Zqthedwu0dIJpHXuWNTNbstZTZW
         646Q/mnV61P5nrmWyoz74x8HWOUG17uStbZBBJCY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, siliu@redhat.com,
        Pankaj Gupta <pagupta@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 228/276] virtio_console: initialize vtermno value for ports
Date:   Wed, 29 May 2019 20:06:26 -0700
Message-Id: <20190530030539.365627657@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030523.133519668@linuxfoundation.org>
References: <20190530030523.133519668@linuxfoundation.org>
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
index 5b5b5d72eab7f..c55f6aeb4227a 100644
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
@@ -1405,6 +1405,7 @@ static int add_port(struct ports_device *portdev, u32 id)
 	port->async_queue = NULL;
 
 	port->cons.ws.ws_row = port->cons.ws.ws_col = 0;
+	port->cons.vtermno = 0;
 
 	port->host_connected = port->guest_connected = false;
 	port->stats = (struct port_stats) { 0 };
-- 
2.20.1



