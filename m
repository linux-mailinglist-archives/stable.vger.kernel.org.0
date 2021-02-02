Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B74B530C822
	for <lists+stable@lfdr.de>; Tue,  2 Feb 2021 18:44:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234084AbhBBRm2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Feb 2021 12:42:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:48892 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234126AbhBBOMX (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Feb 2021 09:12:23 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 823A464FB1;
        Tue,  2 Feb 2021 13:52:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612273932;
        bh=AfAtCAdUTLCzHvef04qEg8pRnvR1WbD+PEiA/0jNdxk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WNLbYmqt3AHnUsoU3ekaWoqV6NjrPgrFShLd92llpQ8P1a8jnYYIpDLnuaIZEBcYz
         B/kk7YSHmZrglnpPV+65VQY7m1onS2KP6gBFNRCO6KotW5Pw/qOkjZ8GLlcmniBDGt
         I546wvguucioFbt3tI9acUvjtvjsnxadPJqDDisY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 4.14 07/30] drivers: soc: atmel: add null entry at the end of at91_soc_allowed_list[]
Date:   Tue,  2 Feb 2021 14:38:48 +0100
Message-Id: <20210202132942.430407251@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210202132942.138623851@linuxfoundation.org>
References: <20210202132942.138623851@linuxfoundation.org>
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
@@ -250,7 +250,8 @@ static const struct of_device_id at91_so
 	{ .compatible = "atmel,at91rm9200", },
 	{ .compatible = "atmel,at91sam9", },
 	{ .compatible = "atmel,sama5", },
-	{ .compatible = "atmel,samv7", }
+	{ .compatible = "atmel,samv7", },
+	{ }
 };
 
 static int __init atmel_soc_device_init(void)


