Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1267830CCA2
	for <lists+stable@lfdr.de>; Tue,  2 Feb 2021 21:04:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232767AbhBBUCU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Feb 2021 15:02:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:38204 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232607AbhBBNpl (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Feb 2021 08:45:41 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id EA1BC64F7E;
        Tue,  2 Feb 2021 13:40:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612273250;
        bh=IS+fyvq5SKTMi//gjqcWIQi0DaLbEO1LVjvdxdqY6sI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BIe8orqSQSAidCYp8kkNSF2Kaa58tJJsxm5SFMGBhyqYBB+L6ksC4Ppk25z37RJ1n
         ArFd3uB4q+vdHwy0SwnhsKZmUIRZm61I9jGqSLQ2A9aatdCeNcfNpelmpSaAMslf2u
         Nau3HFHanYkDsrwBEZkdFRAQpN1tUwzmCzRcLqeE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Ludovic Desroches <ludovic.desroches@microchip.com>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 5.10 035/142] drivers: soc: atmel: Avoid calling at91_soc_init on non AT91 SoCs
Date:   Tue,  2 Feb 2021 14:36:38 +0100
Message-Id: <20210202132959.155319864@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210202132957.692094111@linuxfoundation.org>
References: <20210202132957.692094111@linuxfoundation.org>
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
@@ -265,8 +265,20 @@ struct soc_device * __init at91_soc_init
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


