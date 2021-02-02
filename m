Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2377E30C0B3
	for <lists+stable@lfdr.de>; Tue,  2 Feb 2021 15:06:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233825AbhBBOFY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Feb 2021 09:05:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:46344 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233538AbhBBODU (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Feb 2021 09:03:20 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 033EB6500B;
        Tue,  2 Feb 2021 13:48:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612273691;
        bh=CJYqW0knAVr85WZdAYp8WiCBHY74LJYj+o+ipSz1bJs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MtWa3WJlYM6LHr6MhPwn1VgHKySJsBgGQqvCJTVnIo1bjqsmxSuuXN56F5XK6uNZ7
         yG6JUqPXwRGOmRdcJwuw6hX/HqzxTXgfeuwzwqBI1PdQZTetU1sqeUne2TVNO7U/24
         grAGJNATrOQO3A9CWGN72XEfcpCI5Y73eQApIoHk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Ludovic Desroches <ludovic.desroches@microchip.com>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 5.4 14/61] drivers: soc: atmel: Avoid calling at91_soc_init on non AT91 SoCs
Date:   Tue,  2 Feb 2021 14:37:52 +0100
Message-Id: <20210202132947.072957616@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210202132946.480479453@linuxfoundation.org>
References: <20210202132946.480479453@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sudeep Holla <sudeep.holla@arm.com>

commit caab13b4960416b9fee83169a758eb0f31e65109 upstream.

Since at91_soc_init is called unconditionally from atmel_soc_device_init,
we get the following warning on all non AT91 SoCs:
	" AT91: Could not find identification node"

Fix the same by filtering with allowed AT91 SoC list.

Cc: Nicolas Ferre <nicolas.ferre@microchip.com>
Cc: Alexandre Belloni <alexandre.belloni@bootlin.com>
Cc: Ludovic Desroches <ludovic.desroches@microchip.com>
Cc: stable@vger.kernel.org #4.12+
Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Link: https://lore.kernel.org/r/20201211135846.1334322-1-sudeep.holla@arm.com
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/soc/atmel/soc.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/drivers/soc/atmel/soc.c
+++ b/drivers/soc/atmel/soc.c
@@ -264,8 +264,20 @@ struct soc_device * __init at91_soc_init
 	return soc_dev;
 }
 
+static const struct of_device_id at91_soc_allowed_list[] __initconst = {
+	{ .compatible = "atmel,at91rm9200", },
+	{ .compatible = "atmel,at91sam9", },
+	{ .compatible = "atmel,sama5", },
+	{ .compatible = "atmel,samv7", }
+};
+
 static int __init atmel_soc_device_init(void)
 {
+	struct device_node *np = of_find_node_by_path("/");
+
+	if (!of_match_node(at91_soc_allowed_list, np))
+		return 0;
+
 	at91_soc_init(socs);
 
 	return 0;


