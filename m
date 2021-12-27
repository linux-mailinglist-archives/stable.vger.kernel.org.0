Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C40CE47FFCC
	for <lists+stable@lfdr.de>; Mon, 27 Dec 2021 16:41:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238339AbhL0PlK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Dec 2021 10:41:10 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:41408 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239355AbhL0Pjq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Dec 2021 10:39:46 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id B7355CE10AF;
        Mon, 27 Dec 2021 15:39:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8AD5C36AE7;
        Mon, 27 Dec 2021 15:39:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640619583;
        bh=jEHoQe8jrvJBL+MxHK0xVNO8NAQF6zaULzhhgCUanQs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ocTxDrCrRL2trBhDVro8w3SXV+StbX9pDpV7EqC9sTyKCoEunfe5y9dIDBdo7WjoN
         5G9/YyVwzx5tloESwqOe2xlN3pXP/Ee5gN+/eXX7uMDJJMOWNTiQ4HP+m6AMh/YlP+
         lGi9fs0WppQZ6KQPPmdVcyZ9R3ZUPZLkEOhEkzVc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>,
        Mian Yousaf Kaukab <ykaukab@suse.de>,
        Corey Minyard <cminyard@mvista.com>
Subject: [PATCH 5.10 42/76] ipmi: ssif: initialize ssif_info->client early
Date:   Mon, 27 Dec 2021 16:30:57 +0100
Message-Id: <20211227151326.166139792@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211227151324.694661623@linuxfoundation.org>
References: <20211227151324.694661623@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mian Yousaf Kaukab <ykaukab@suse.de>

commit 34f35f8f14bc406efc06ee4ff73202c6fd245d15 upstream.

During probe ssif_info->client is dereferenced in error path. However,
it is set when some of the error checking has already been done. This
causes following kernel crash if an error path is taken:

[   30.645593][  T674] ipmi_ssif 0-000e: ipmi_ssif: Not probing, Interface already present
[   30.657616][  T674] Unable to handle kernel NULL pointer dereference at virtual address 0000000000000088
...
[   30.657723][  T674] pc : __dev_printk+0x28/0xa0
[   30.657732][  T674] lr : _dev_err+0x7c/0xa0
...
[   30.657772][  T674] Call trace:
[   30.657775][  T674]  __dev_printk+0x28/0xa0
[   30.657778][  T674]  _dev_err+0x7c/0xa0
[   30.657781][  T674]  ssif_probe+0x548/0x900 [ipmi_ssif 62ce4b08badc1458fd896206d9ef69a3c31f3d3e]
[   30.657791][  T674]  i2c_device_probe+0x37c/0x3c0
...

Initialize ssif_info->client before any error path can be taken. Clear
i2c_client data in the error path to prevent the dangling pointer from
leaking.

Fixes: c4436c9149c5 ("ipmi_ssif: avoid registering duplicate ssif interface")
Cc: stable@vger.kernel.org # 5.4.x
Suggested-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Mian Yousaf Kaukab <ykaukab@suse.de>
Message-Id: <20211208093239.4432-1-ykaukab@suse.de>
Signed-off-by: Corey Minyard <cminyard@mvista.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/ipmi/ipmi_ssif.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/drivers/char/ipmi/ipmi_ssif.c
+++ b/drivers/char/ipmi/ipmi_ssif.c
@@ -1700,6 +1700,9 @@ static int ssif_probe(struct i2c_client
 		}
 	}
 
+	ssif_info->client = client;
+	i2c_set_clientdata(client, ssif_info);
+
 	rv = ssif_check_and_remove(client, ssif_info);
 	/* If rv is 0 and addr source is not SI_ACPI, continue probing */
 	if (!rv && ssif_info->addr_source == SI_ACPI) {
@@ -1720,9 +1723,6 @@ static int ssif_probe(struct i2c_client
 		ipmi_addr_src_to_str(ssif_info->addr_source),
 		client->addr, client->adapter->name, slave_addr);
 
-	ssif_info->client = client;
-	i2c_set_clientdata(client, ssif_info);
-
 	/* Now check for system interface capabilities */
 	msg[0] = IPMI_NETFN_APP_REQUEST << 2;
 	msg[1] = IPMI_GET_SYSTEM_INTERFACE_CAPABILITIES_CMD;
@@ -1922,6 +1922,7 @@ static int ssif_probe(struct i2c_client
 
 		dev_err(&ssif_info->client->dev,
 			"Unable to start IPMI SSIF: %d\n", rv);
+		i2c_set_clientdata(client, NULL);
 		kfree(ssif_info);
 	}
 	kfree(resp);


