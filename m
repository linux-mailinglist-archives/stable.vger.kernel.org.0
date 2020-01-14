Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 890C713A531
	for <lists+stable@lfdr.de>; Tue, 14 Jan 2020 11:08:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730129AbgANKFZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jan 2020 05:05:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:33450 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730126AbgANKFY (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 Jan 2020 05:05:24 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 94D242467D;
        Tue, 14 Jan 2020 10:05:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578996324;
        bh=QLRq49Oa3q7afnFXHe3koQkdpAPWSchtx4mPwYc8D+I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ocP803m3vJDqSW9N+mq/KBnYnbYh63mjRmez2j1NKJrgGVQe4PYo9GyAH5I0F13TP
         Gy1Jww4B90ilLilztCRavn3v5ZHBXY8co2NZjV5Gea20aFCOpiKp47TyOOvqZeFdfB
         UQw2KbPdqLY1LdKspCGRJDAfhJvqllx1BerXE5g8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Kenneth R. Crudup" <kenny@panix.com>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Subject: [PATCH 5.4 56/78] tty: always relink the port
Date:   Tue, 14 Jan 2020 11:01:30 +0100
Message-Id: <20200114094400.977175947@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200114094352.428808181@linuxfoundation.org>
References: <20200114094352.428808181@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>

commit 273f632912f1b24b642ba5b7eb5022e43a72f3b5 upstream.

If the serial device is disconnected and reconnected, it re-enumerates
properly but does not link it. fwiw, linking means just saving the port
index, so allow it always as there is no harm in saving the same value
again even if it tries to relink with the same port.

Fixes: fb2b90014d78 ("tty: link tty and port before configuring it as console")
Reported-by: Kenneth R. Crudup <kenny@panix.com>
Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20191227174434.12057-1-sudipm.mukherjee@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/tty/tty_port.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/tty/tty_port.c
+++ b/drivers/tty/tty_port.c
@@ -89,8 +89,7 @@ void tty_port_link_device(struct tty_por
 {
 	if (WARN_ON(index >= driver->num))
 		return;
-	if (!driver->ports[index])
-		driver->ports[index] = port;
+	driver->ports[index] = port;
 }
 EXPORT_SYMBOL_GPL(tty_port_link_device);
 


