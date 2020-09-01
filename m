Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0317F259360
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 17:25:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729997AbgIAPZE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 11:25:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:49204 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729993AbgIAPZC (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Sep 2020 11:25:02 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A3FFC20FC3;
        Tue,  1 Sep 2020 15:25:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598973902;
        bh=onWtOnOe38uujL9+85ri15ureODnZNtdVZRCOwH2QR4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2K4IOHwZuYsQj8iJ6Zrvud8iiT4kavBQUAo0pHTHv/lpjXLCVesI1J3uWj9lepiIx
         536lZDw5mNK5SYREl3eWtPJG5lu754v9a1nu9sDGMKF6r1fAJeyOEpJdM/HMf4SDhf
         w144s6Tjtzua0JDC0MYsgdIyj8maaumudh2jPH+4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lukas Wunner <lukas@wunner.de>,
        Tushar Behera <tushar.behera@linaro.org>
Subject: [PATCH 4.19 091/125] serial: pl011: Dont leak amba_ports entry on driver register error
Date:   Tue,  1 Sep 2020 17:10:46 +0200
Message-Id: <20200901150939.045905828@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200901150934.576210879@linuxfoundation.org>
References: <20200901150934.576210879@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lukas Wunner <lukas@wunner.de>

commit 89efbe70b27dd325d8a8c177743a26b885f7faec upstream.

pl011_probe() calls pl011_setup_port() to reserve an amba_ports[] entry,
then calls pl011_register_port() to register the uart driver with the
tty layer.

If registration of the uart driver fails, the amba_ports[] entry is not
released.  If this happens 14 times (value of UART_NR macro), then all
amba_ports[] entries will have been leaked and driver probing is no
longer possible.  (To be fair, that can only happen if the DeviceTree
doesn't contain alias IDs since they cause the same entry to be used for
a given port.)   Fix it.

Fixes: ef2889f7ffee ("serial: pl011: Move uart_register_driver call to device")
Signed-off-by: Lukas Wunner <lukas@wunner.de>
Cc: stable@vger.kernel.org # v3.15+
Cc: Tushar Behera <tushar.behera@linaro.org>
Link: https://lore.kernel.org/r/138f8c15afb2f184d8102583f8301575566064a6.1597316167.git.lukas@wunner.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/tty/serial/amba-pl011.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/tty/serial/amba-pl011.c
+++ b/drivers/tty/serial/amba-pl011.c
@@ -2593,7 +2593,7 @@ static int pl011_setup_port(struct devic
 
 static int pl011_register_port(struct uart_amba_port *uap)
 {
-	int ret;
+	int ret, i;
 
 	/* Ensure interrupts from this UART are masked and cleared */
 	pl011_write(0, uap, REG_IMSC);
@@ -2604,6 +2604,9 @@ static int pl011_register_port(struct ua
 		if (ret < 0) {
 			dev_err(uap->port.dev,
 				"Failed to register AMBA-PL011 driver\n");
+			for (i = 0; i < ARRAY_SIZE(amba_ports); i++)
+				if (amba_ports[i] == uap)
+					amba_ports[i] = NULL;
 			return ret;
 		}
 	}


