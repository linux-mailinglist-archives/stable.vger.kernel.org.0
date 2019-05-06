Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F033814C64
	for <lists+stable@lfdr.de>; Mon,  6 May 2019 16:40:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727933AbfEFOkB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 May 2019 10:40:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:33168 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727930AbfEFOkA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 6 May 2019 10:40:00 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A1FEB20449;
        Mon,  6 May 2019 14:39:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557153600;
        bh=XViI8siM9t8Km8JK78U5QE8Ny1YHZh50Bn88VtjLptA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=e2s2UDWLu2j8dIk52vdwWv+xTYMoev6QZedI8L3dUSQX4a+92qfzsDqtkjk1WSkXd
         QUjIHhcF3UOFVjUmvn+vNGIyJyn8C2fSwMiAasM+4X4qHXJC3ypeWRRddXybwQ5qq4
         ImsoDtSo/r3nvYLmjT9y+9HmlJnpxJzdts4xTeLc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Keijo Vaara <ferdasyn@rocketmail.com>,
        Jarkko Nikula <jarkko.nikula@linux.intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Wolfram Sang <wsa@the-dreams.de>
Subject: [PATCH 4.19 09/99] i2c: Prevent runtime suspend of adapter when Host Notify is required
Date:   Mon,  6 May 2019 16:31:42 +0200
Message-Id: <20190506143054.703397889@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190506143053.899356316@linuxfoundation.org>
References: <20190506143053.899356316@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jarkko Nikula <jarkko.nikula@linux.intel.com>

commit 72bfcee11cf89509795c56b0e40a3785ab00bbdd upstream.

Multiple users have reported their Synaptics touchpad has stopped
working between v4.20.1 and v4.20.2 when using SMBus interface.

The culprit for this appeared to be commit c5eb1190074c ("PCI / PM: Allow
runtime PM without callback functions") that fixed the runtime PM for
i2c-i801 SMBus adapter. Those Synaptics touchpad are using i2c-i801
for SMBus communication and testing showed they are able to get back
working by preventing the runtime suspend of adapter.

Normally when i2c-i801 SMBus adapter transmits with the client it resumes
before operation and autosuspends after.

However, if client requires SMBus Host Notify protocol, what those
Synaptics touchpads do, then the host adapter must not go to runtime
suspend since then it cannot process incoming SMBus Host Notify commands
the client may send.

Fix this by keeping I2C/SMBus adapter active in case client requires
Host Notify.

Reported-by: Keijo Vaara <ferdasyn@rocketmail.com>
Link: https://bugzilla.kernel.org/show_bug.cgi?id=203297
Fixes: c5eb1190074c ("PCI / PM: Allow runtime PM without callback functions")
Cc: stable@vger.kernel.org # v4.20+
Signed-off-by: Jarkko Nikula <jarkko.nikula@linux.intel.com>
Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Tested-by: Keijo Vaara <ferdasyn@rocketmail.com>
Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/i2c/i2c-core-base.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/i2c/i2c-core-base.c
+++ b/drivers/i2c/i2c-core-base.c
@@ -327,6 +327,8 @@ static int i2c_device_probe(struct devic
 
 		if (client->flags & I2C_CLIENT_HOST_NOTIFY) {
 			dev_dbg(dev, "Using Host Notify IRQ\n");
+			/* Keep adapter active when Host Notify is required */
+			pm_runtime_get_sync(&client->adapter->dev);
 			irq = i2c_smbus_host_notify_to_irq(client);
 		} else if (dev->of_node) {
 			irq = of_irq_get_byname(dev->of_node, "irq");
@@ -431,6 +433,8 @@ static int i2c_device_remove(struct devi
 	device_init_wakeup(&client->dev, false);
 
 	client->irq = client->init_irq;
+	if (client->flags & I2C_CLIENT_HOST_NOTIFY)
+		pm_runtime_put(&client->adapter->dev);
 
 	return status;
 }


