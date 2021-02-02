Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21FDB30CCA0
	for <lists+stable@lfdr.de>; Tue,  2 Feb 2021 21:04:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240247AbhBBUCO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Feb 2021 15:02:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:38206 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232744AbhBBNpk (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Feb 2021 08:45:40 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B0EA364F7B;
        Tue,  2 Feb 2021 13:40:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612273253;
        bh=ld8Bdw80jS1RKI++vEXxfl3dzwNVg1yeAttiamGbiZ0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GYd2LvG6oXAAoPGrJNRjkFWnHCsS9hmH9AaopJnj4srVWrWFK4t/mA6NDm2UxakMU
         8WyXqNqq1UY7F+e6H3ot47a4NQyPWvphGkUL1uIHkVMhYqjkksPl04zVEBrniQeHBX
         +N+xbr+QoqlHsUZLVNE9cYzWiSsE/0WY4uGBXYXs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 5.10 036/142] drivers: soc: atmel: add null entry at the end of at91_soc_allowed_list[]
Date:   Tue,  2 Feb 2021 14:36:39 +0100
Message-Id: <20210202132959.197609557@linuxfoundation.org>
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

From: Claudiu Beznea <claudiu.beznea@microchip.com>

commit 680896556805d3ad3fa47f6002b87b3041a45ac2 upstream.

of_match_node() calls __of_match_node() which loops though the entries of
matches array. It stops when condition:
(matches->name[0] || matches->type[0] || matches->compatible[0]) is
false. Thus, add a null entry at the end of at91_soc_allowed_list[]
array.

Fixes: caab13b49604 ("drivers: soc: atmel: Avoid calling at91_soc_init on non AT91 SoCs")
Cc: stable@vger.kernel.org #4.12+
Signed-off-by: Claudiu Beznea <claudiu.beznea@microchip.com>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/soc/atmel/soc.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/soc/atmel/soc.c
+++ b/drivers/soc/atmel/soc.c
@@ -269,7 +269,8 @@ static const struct of_device_id at91_so
 	{ .compatible = "atmel,at91rm9200", },
 	{ .compatible = "atmel,at91sam9", },
 	{ .compatible = "atmel,sama5", },
-	{ .compatible = "atmel,samv7", }
+	{ .compatible = "atmel,samv7", },
+	{ }
 };
 
 static int __init atmel_soc_device_init(void)


