Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A9C424BD8D
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 15:08:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728244AbgHTNID (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 09:08:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:55858 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728888AbgHTJiT (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 05:38:19 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E4341207DE;
        Thu, 20 Aug 2020 09:38:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597916299;
        bh=qlZatptjxTirg4Rm1dhbqHVFHrmeSZ2GGI51mK8nO1g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pvq80yrCYcvIXO7RhxDqGVXja6QBCBJlP79jKPbACWzpiSEGLcP66SG+9CPrzozh/
         Vcv3bXJa1FY3hX5GP5REBPWuo2ucq1Ruf6a04L3rABykXc9hEKVbII4yVjhMcqEtL0
         aoC1MRAQ9XaCcf5cposPJTdUgG27JIjuLy/kf86g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ahmad Fatoum <a.fatoum@pengutronix.de>,
        Guenter Roeck <linux@roeck-us.net>,
        Wim Van Sebroeck <wim@linux-watchdog.org>
Subject: [PATCH 5.7 080/204] watchdog: f71808e_wdt: indicate WDIOF_CARDRESET support in watchdog_info.options
Date:   Thu, 20 Aug 2020 11:19:37 +0200
Message-Id: <20200820091610.339238964@linuxfoundation.org>
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

commit e871e93fb08a619dfc015974a05768ed6880fd82 upstream.

The driver supports populating bootstatus with WDIOF_CARDRESET, but so
far userspace couldn't portably determine whether absence of this flag
meant no watchdog reset or no driver support. Or-in the bit to fix this.

Fixes: b97cb21a4634 ("watchdog: f71808e_wdt: Fix WDTMOUT_STS register read")
Cc: stable@vger.kernel.org
Signed-off-by: Ahmad Fatoum <a.fatoum@pengutronix.de>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Link: https://lore.kernel.org/r/20200611191750.28096-3-a.fatoum@pengutronix.de
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Wim Van Sebroeck <wim@linux-watchdog.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/watchdog/f71808e_wdt.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/watchdog/f71808e_wdt.c
+++ b/drivers/watchdog/f71808e_wdt.c
@@ -692,7 +692,8 @@ static int __init watchdog_init(int sioa
 	watchdog.sioaddr = sioaddr;
 	watchdog.ident.options = WDIOC_SETTIMEOUT
 				| WDIOF_MAGICCLOSE
-				| WDIOF_KEEPALIVEPING;
+				| WDIOF_KEEPALIVEPING
+				| WDIOF_CARDRESET;
 
 	snprintf(watchdog.ident.identity,
 		sizeof(watchdog.ident.identity), "%s watchdog",


