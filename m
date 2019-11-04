Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 01376EEEFC
	for <lists+stable@lfdr.de>; Mon,  4 Nov 2019 23:19:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388055AbfKDWSA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Nov 2019 17:18:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:60566 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389224AbfKDWCO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Nov 2019 17:02:14 -0500
Received: from localhost (6.204-14-84.ripe.coltfrance.com [84.14.204.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 391092089C;
        Mon,  4 Nov 2019 22:02:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572904933;
        bh=iOwJt4PH0vF7tQobDg6MlteMOkoS0OlM2wN4cLQY6wE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Mzofvc2Tw965kMI4iB12AHdReN3n0VsvsV8Mwy63fpcZjl83sjzpd+J11fGZR2fgh
         +D7nvPeQ2wZiCELktB4dbivKQQDppw9F4ALvsqwlQUQ1NOj2OO/ik+QQwXjSl11PE7
         qczvTeP7+bT/dZ4wam7jS1aE6Na3pWYT7vS7GllA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johan Hovold <johan@kernel.org>
Subject: [PATCH 4.19 120/149] USB: serial: whiteheat: fix potential slab corruption
Date:   Mon,  4 Nov 2019 22:45:13 +0100
Message-Id: <20191104212144.726422498@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191104212126.090054740@linuxfoundation.org>
References: <20191104212126.090054740@linuxfoundation.org>
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
@@ -571,6 +571,10 @@ static int firm_send_command(struct usb_
 
 	command_port = port->serial->port[COMMAND_PORT];
 	command_info = usb_get_serial_port_data(command_port);
+
+	if (command_port->bulk_out_size < datasize + 1)
+		return -EIO;
+
 	mutex_lock(&command_info->mutex);
 	command_info->command_finished = false;
 


