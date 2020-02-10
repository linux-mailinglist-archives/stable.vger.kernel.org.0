Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 755B31574F7
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 13:38:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727775AbgBJMhV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 07:37:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:58758 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728165AbgBJMhT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:37:19 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 785B320733;
        Mon, 10 Feb 2020 12:37:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338239;
        bh=ShEiTjx4VjRs/g2AFrNdObXXPzjqLZd6BsDl4aY7RDo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s1e03Wwyot1xujZ0q8DLl1dPZ7quGTr8CJ8gy6J9WS79xdwcu5/rmZXtCNTBYY1X7
         H5aK7LAn/dhzSosoCDUISkpDv91IirhZnfYfs9iLI1v+9WkwnTlOJWuDIAVgHpIQMo
         OxiDlfBWEEPOB699od3czFB0NNtvlziFcupOIFQk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Li Jun <jun.li@nxp.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 5.4 039/309] usb: typec: tcpci: mask event interrupts when remove driver
Date:   Mon, 10 Feb 2020 04:29:55 -0800
Message-Id: <20200210122409.849294785@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210122406.106356946@linuxfoundation.org>
References: <20200210122406.106356946@linuxfoundation.org>
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
 drivers/usb/typec/tcpm/tcpci.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/usb/typec/tcpm/tcpci.c
+++ b/drivers/usb/typec/tcpm/tcpci.c
@@ -591,6 +591,12 @@ static int tcpci_probe(struct i2c_client
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
 


