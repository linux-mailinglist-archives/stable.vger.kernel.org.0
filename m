Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 421E911B833
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 17:14:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729702AbfLKPHT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 10:07:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:54342 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729144AbfLKPHT (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:07:19 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 064A4208C3;
        Wed, 11 Dec 2019 15:07:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576076837;
        bh=S1YkN6O6yv6W4P5KTj8GXvZtQ4bxmpqDV3ZgFsMXh38=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IIJxPTHvH4qVtjIgqJ2oz3jsAQK9k/0EcUO7EmzzpU3EIo2E997VkOPdFQNYX7WDa
         u3O5yutQb6TZn+q0KpMCX5nHwjMCavuaGAngAO0yRrEjR7iCeM283ltcI1xjeq5D0j
         oldSpx/GA0q4p40gWWGUfMt46ZJdJK3s031MkHf8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Micha=C5=82=20Miros=C5=82aw?= <mirq-linux@rere.qmqm.pl>,
        Ladislav Michl <ladis@linux-mips.org>,
        Felipe Balbi <felipe.balbi@linux.intel.com>
Subject: [PATCH 5.4 10/92] usb: gadget: u_serial: add missing port entry locking
Date:   Wed, 11 Dec 2019 16:05:01 +0100
Message-Id: <20191211150224.106028704@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191211150221.977775294@linuxfoundation.org>
References: <20191211150221.977775294@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michał Mirosław <mirq-linux@rere.qmqm.pl>

commit daf82bd24e308c5a83758047aff1bd81edda4f11 upstream.

gserial_alloc_line() misses locking (for a release barrier) while
resetting port entry on TTY allocation failure. Fix this.

Cc: stable@vger.kernel.org
Signed-off-by: Michał Mirosław <mirq-linux@rere.qmqm.pl>
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Tested-by: Ladislav Michl <ladis@linux-mips.org>
Signed-off-by: Felipe Balbi <felipe.balbi@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/gadget/function/u_serial.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/usb/gadget/function/u_serial.c
+++ b/drivers/usb/gadget/function/u_serial.c
@@ -1239,8 +1239,10 @@ int gserial_alloc_line(unsigned char *li
 				__func__, port_num, PTR_ERR(tty_dev));
 
 		ret = PTR_ERR(tty_dev);
+		mutex_lock(&ports[port_num].lock);
 		port = ports[port_num].port;
 		ports[port_num].port = NULL;
+		mutex_unlock(&ports[port_num].lock);
 		gserial_free_port(port);
 		goto err;
 	}


