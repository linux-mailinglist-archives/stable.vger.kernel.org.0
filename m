Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 423E8E857A
	for <lists+stable@lfdr.de>; Tue, 29 Oct 2019 11:26:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730251AbfJ2K0Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Oct 2019 06:26:25 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:39912 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726071AbfJ2K0Y (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 29 Oct 2019 06:26:24 -0400
Received: by mail-wm1-f67.google.com with SMTP id r141so1767860wme.4;
        Tue, 29 Oct 2019 03:26:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Ho9npiobrNKcojdO6IyVNqKqiBzAHj8uDX5qkliYH/k=;
        b=hqGwCBMw4DDO/GuDK5h/Gk2Lrklz7EyG58ihvK43ILTf59x6WT9YqK1u4mrGbY4YuB
         aQIX+KiUJqHljEJluMv70m1ahwax8EbJNL60wAJy9hbxJKM830arEEAOOXivqWsdQcuk
         lIwB4XZg9qJe9+gejfBQINqnl7NtrHaDUQeG8pD4xgLk9PfdXPJhgWn6OL0nBVoVt370
         iZTFOV2iqTwA1stMLz6wxtoZYfi4hXcQy0WQ8eOHvEePcjllyVcYc26uuoTnkPAapGw8
         JoiDA9lXv5ab23R90qzJ8t3CS1NeZlRHxGe5UBFmC3rt6OaQanBs1n3dbnqa9y/PcvtG
         bthQ==
X-Gm-Message-State: APjAAAV6EjweSgLtWcFJBv77Pk7DPVRNC6NEjERj7yFSPojt5zGlQN2s
        MEekYCE/PeIAfPgQXY7U3Ak=
X-Google-Smtp-Source: APXvYqyNGw2Y96Anz41W3n8zj4SRJyoTDxvvlQmzUGnjCTJSKNO/8e3JTKoBJQbVSPbNh2uG7GFm1w==
X-Received: by 2002:a1c:1d41:: with SMTP id d62mr3322024wmd.32.1572344782634;
        Tue, 29 Oct 2019 03:26:22 -0700 (PDT)
Received: from pi (100.50.158.77.rev.sfr.net. [77.158.50.100])
        by smtp.gmail.com with ESMTPSA id d11sm16336750wrf.80.2019.10.29.03.26.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Oct 2019 03:26:20 -0700 (PDT)
Received: from johan by pi with local (Exim 4.92.2)
        (envelope-from <johan@pi>)
        id 1iPOgQ-0002pq-Cy; Tue, 29 Oct 2019 11:25:02 +0100
From:   Johan Hovold <johan@kernel.org>
To:     Johan Hovold <johan@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-usb@vger.kernel.org, stable <stable@vger.kernel.org>
Subject: [PATCH 1/2] USB: serial: whiteheat: fix potential slab corruption
Date:   Tue, 29 Oct 2019 11:23:53 +0100
Message-Id: <20191029102354.2733-2-johan@kernel.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191029102354.2733-1-johan@kernel.org>
References: <20191029102354.2733-1-johan@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Fix a user-controlled slab buffer overflow due to a missing sanity check
on the bulk-out transfer buffer used for control requests.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/usb/serial/whiteheat.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/usb/serial/whiteheat.c b/drivers/usb/serial/whiteheat.c
index 79314d8c94a4..76cabcb30d21 100644
--- a/drivers/usb/serial/whiteheat.c
+++ b/drivers/usb/serial/whiteheat.c
@@ -559,6 +559,10 @@ static int firm_send_command(struct usb_serial_port *port, __u8 command,
 
 	command_port = port->serial->port[COMMAND_PORT];
 	command_info = usb_get_serial_port_data(command_port);
+
+	if (command_port->bulk_out_size < datasize + 1)
+		return -EIO;
+
 	mutex_lock(&command_info->mutex);
 	command_info->command_finished = false;
 
-- 
2.23.0

