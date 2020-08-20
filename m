Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8805824B2E0
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 11:38:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728764AbgHTJiY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 05:38:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:55972 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728745AbgHTJiW (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 05:38:22 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 74A5B208E4;
        Thu, 20 Aug 2020 09:38:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597916302;
        bh=qODI7FfI8D79fxtK+8MRpGep8DMuZaOYzP9AJdDA99k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C7WNUcPoGwdpfV+ll0q6Y87SiyBQk7mqwj3cn7/Gx7j8bPL3Ol2nu2V1+qLcpnsP5
         NTqmJiydC9j0gl7it2KNDtmGIydvfaMe1yhc03iW+KvMvICHbrWBTP7L/ncIpNzNG5
         fUaPhE+3DLaqeDMBWEnbSjFrdCj7PUnVTu49mHV0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ahmad Fatoum <a.fatoum@pengutronix.de>,
        Guenter Roeck <linux@roeck-us.net>,
        Wim Van Sebroeck <wim@linux-watchdog.org>
Subject: [PATCH 5.7 081/204] watchdog: f71808e_wdt: remove use of wrong watchdog_info option
Date:   Thu, 20 Aug 2020 11:19:38 +0200
Message-Id: <20200820091610.388391556@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820091606.194320503@linuxfoundation.org>
References: <20200820091606.194320503@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ahmad Fatoum <a.fatoum@pengutronix.de>

commit 802141462d844f2e6a4d63a12260d79b7afc4c34 upstream.

The flags that should be or-ed into the watchdog_info.options by drivers
all start with WDIOF_, e.g. WDIOF_SETTIMEOUT, which indicates that the
driver's watchdog_ops has a usable set_timeout.

WDIOC_SETTIMEOUT was used instead, which expands to 0xc0045706, which
equals:

   WDIOF_FANFAULT | WDIOF_EXTERN1 | WDIOF_PRETIMEOUT | WDIOF_ALARMONLY |
   WDIOF_MAGICCLOSE | 0xc0045000

These were so far indicated to userspace on WDIOC_GETSUPPORT.
As the driver has not yet been migrated to the new watchdog kernel API,
the constant can just be dropped without substitute.

Fixes: 96cb4eb019ce ("watchdog: f71808e_wdt: new watchdog driver for Fintek F71808E and F71882FG")
Cc: stable@vger.kernel.org
Signed-off-by: Ahmad Fatoum <a.fatoum@pengutronix.de>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Link: https://lore.kernel.org/r/20200611191750.28096-4-a.fatoum@pengutronix.de
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Wim Van Sebroeck <wim@linux-watchdog.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/watchdog/f71808e_wdt.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/watchdog/f71808e_wdt.c
+++ b/drivers/watchdog/f71808e_wdt.c
@@ -690,8 +690,7 @@ static int __init watchdog_init(int sioa
 	 * into the module have been registered yet.
 	 */
 	watchdog.sioaddr = sioaddr;
-	watchdog.ident.options = WDIOC_SETTIMEOUT
-				| WDIOF_MAGICCLOSE
+	watchdog.ident.options = WDIOF_MAGICCLOSE
 				| WDIOF_KEEPALIVEPING
 				| WDIOF_CARDRESET;
 


