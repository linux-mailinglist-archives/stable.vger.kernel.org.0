Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A41424F874
	for <lists+stable@lfdr.de>; Mon, 24 Aug 2020 11:32:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729786AbgHXItz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Aug 2020 04:49:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:52750 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729756AbgHXItw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Aug 2020 04:49:52 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2A6032075B;
        Mon, 24 Aug 2020 08:49:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598258991;
        bh=RPfWYGi+QKddpDu5XlK35oVwvWksJylz921MQD9a08I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M3CQpOi7qTZOVfICZJY0mytBs/QmcdoW/8GAEpz7v8K4I+HE1G1cutvAX1Vtal1By
         n6XgdRmc6i3hFIulr9Sz32tTlnraLidSlTyuF34vb2Yz74X7i+EwEYGMNptRKE+boS
         avnK8IsJG9D8FluDCJQBGJX0BaUKSwg4E8p8Aqss=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ahmad Fatoum <a.fatoum@pengutronix.de>,
        Guenter Roeck <linux@roeck-us.net>,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 05/33] watchdog: f71808e_wdt: remove use of wrong watchdog_info option
Date:   Mon, 24 Aug 2020 10:31:01 +0200
Message-Id: <20200824082346.791664700@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200824082346.498653578@linuxfoundation.org>
References: <20200824082346.498653578@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ahmad Fatoum <a.fatoum@pengutronix.de>

[ Upstream commit 802141462d844f2e6a4d63a12260d79b7afc4c34 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/watchdog/f71808e_wdt.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/watchdog/f71808e_wdt.c b/drivers/watchdog/f71808e_wdt.c
index 3577e356e08cc..2b12ef019ae02 100644
--- a/drivers/watchdog/f71808e_wdt.c
+++ b/drivers/watchdog/f71808e_wdt.c
@@ -642,8 +642,7 @@ static int __init watchdog_init(int sioaddr)
 	 * into the module have been registered yet.
 	 */
 	watchdog.sioaddr = sioaddr;
-	watchdog.ident.options = WDIOC_SETTIMEOUT
-				| WDIOF_MAGICCLOSE
+	watchdog.ident.options = WDIOF_MAGICCLOSE
 				| WDIOF_KEEPALIVEPING
 				| WDIOF_CARDRESET;
 
-- 
2.25.1



