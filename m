Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A3B3F1574AA
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 13:35:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727752AbgBJMfK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 07:35:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:51662 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727729AbgBJMfJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:35:09 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 32FB52168B;
        Mon, 10 Feb 2020 12:35:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338109;
        bh=iJIScaKcBBiAXvtWaUrzFmJW9LfZUpxI49wQF0wdBig=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rpfzdyBBlx9tduUOA3S6+qhl1Jbhw97+h6t8YK0r3wCWIOifqclxh7YykReZFrcy1
         1GUJdlBzVS5wb79msFKCb6Toxpuz5z4NFDvXaark9HAeUSYkZyGz0QFn236aStoXNZ
         KRwk84PmxHOSLj0CoJ0+0vedDm5uSfu9Y8sJyg0k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Li Jun <jun.li@nxp.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 4.19 032/195] usb: typec: tcpci: mask event interrupts when remove driver
Date:   Mon, 10 Feb 2020 04:31:30 -0800
Message-Id: <20200210122309.639639914@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210122305.731206734@linuxfoundation.org>
References: <20200210122305.731206734@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jun Li <jun.li@nxp.com>

commit 3ba76256fc4e2a0d7fb26cc95459041ea0e88972 upstream.

This is to prevent any possible events generated while unregister
tpcm port.

Fixes: 74e656d6b055 ("staging: typec: Type-C Port Controller Interface driver (tcpci)")
Signed-off-by: Li Jun <jun.li@nxp.com>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Link: https://lore.kernel.org/r/1579502333-4145-1-git-send-email-jun.li@nxp.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/typec/tcpci.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/usb/typec/tcpci.c
+++ b/drivers/usb/typec/tcpci.c
@@ -581,6 +581,12 @@ static int tcpci_probe(struct i2c_client
 static int tcpci_remove(struct i2c_client *client)
 {
 	struct tcpci_chip *chip = i2c_get_clientdata(client);
+	int err;
+
+	/* Disable chip interrupts before unregistering port */
+	err = tcpci_write16(chip->tcpci, TCPC_ALERT_MASK, 0);
+	if (err < 0)
+		return err;
 
 	tcpci_unregister_port(chip->tcpci);
 


