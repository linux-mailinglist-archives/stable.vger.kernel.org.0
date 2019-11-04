Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D3DC5EEE3C
	for <lists+stable@lfdr.de>; Mon,  4 Nov 2019 23:13:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389860AbfKDWIx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Nov 2019 17:08:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:41846 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388158AbfKDWIx (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Nov 2019 17:08:53 -0500
Received: from localhost (6.204-14-84.ripe.coltfrance.com [84.14.204.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 791BD214E0;
        Mon,  4 Nov 2019 22:08:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572905333;
        bh=HhEdyHXPyQomiK5smnYHE2hSZwsoR1/PnK7r2SFJUMY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AGSunWCPBbpq0XZnj3tL0oepdu1YaaJuJCVV0iBap0FDdRPL2OthzEJ2lkg2GXTDJ
         Wts9RsGARsUR1htzyZkFUQga64Z56QfFBfgDL6nDwuaQcsNdCSySewAvxRx6Fwq76l
         GJ02lL1oZEw4gsaSbxgz+J6dlSip1OgFOxS3qQMw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johan Hovold <johan@kernel.org>
Subject: [PATCH 5.3 110/163] USB: serial: whiteheat: fix potential slab corruption
Date:   Mon,  4 Nov 2019 22:45:00 +0100
Message-Id: <20191104212148.223831241@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191104212140.046021995@linuxfoundation.org>
References: <20191104212140.046021995@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Hovold <johan@kernel.org>

commit 1251dab9e0a2c4d0d2d48370ba5baa095a5e8774 upstream.

Fix a user-controlled slab buffer overflow due to a missing sanity check
on the bulk-out transfer buffer used for control requests.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://lore.kernel.org/r/20191029102354.2733-2-johan@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/whiteheat.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/usb/serial/whiteheat.c
+++ b/drivers/usb/serial/whiteheat.c
@@ -559,6 +559,10 @@ static int firm_send_command(struct usb_
 
 	command_port = port->serial->port[COMMAND_PORT];
 	command_info = usb_get_serial_port_data(command_port);
+
+	if (command_port->bulk_out_size < datasize + 1)
+		return -EIO;
+
 	mutex_lock(&command_info->mutex);
 	command_info->command_finished = false;
 


