Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5785A259CC8
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 19:20:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728814AbgIAPNU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 11:13:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:56238 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728875AbgIAPNR (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Sep 2020 11:13:17 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AFD4A206FA;
        Tue,  1 Sep 2020 15:13:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598973197;
        bh=/n3LStJnKPhmQsWi2OERGM1VspQY3skebgmnoMp75Gs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ptbUoSuAgAVmtakUTsyM20sMK6owQMeBtK47Y83dYus9eB6ahS9gSa36PcmbRpFGI
         /YmuKUpTUU73UaXZtDKKFuhnOuJHpVrrrA3M6/zXncwCQ8VBO3KyegjSKdT/KkeRw0
         wU9kbZq/MI4+JRCcnCb5GQhabbx4VVWt1h/9Owq4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lukas Wunner <lukas@wunner.de>,
        Tushar Behera <tushar.behera@linaro.org>
Subject: [PATCH 4.4 45/62] serial: pl011: Dont leak amba_ports entry on driver register error
Date:   Tue,  1 Sep 2020 17:10:28 +0200
Message-Id: <20200901150923.002698347@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200901150920.697676718@linuxfoundation.org>
References: <20200901150920.697676718@linuxfoundation.org>
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
@@ -2332,7 +2332,7 @@ static int pl011_setup_port(struct devic
 
 static int pl011_register_port(struct uart_amba_port *uap)
 {
-	int ret;
+	int ret, i;
 
 	/* Ensure interrupts from this UART are masked and cleared */
 	writew(0, uap->port.membase + UART011_IMSC);
@@ -2343,6 +2343,9 @@ static int pl011_register_port(struct ua
 		if (ret < 0) {
 			dev_err(uap->port.dev,
 				"Failed to register AMBA-PL011 driver\n");
+			for (i = 0; i < ARRAY_SIZE(amba_ports); i++)
+				if (amba_ports[i] == uap)
+					amba_ports[i] = NULL;
 			return ret;
 		}
 	}


