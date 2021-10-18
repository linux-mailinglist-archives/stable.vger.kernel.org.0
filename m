Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53360431C19
	for <lists+stable@lfdr.de>; Mon, 18 Oct 2021 15:37:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231922AbhJRNjK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Oct 2021 09:39:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:55140 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232972AbhJRNgP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Oct 2021 09:36:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EA16A613BD;
        Mon, 18 Oct 2021 13:31:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634563862;
        bh=8Yv8DfGlHSd0F1x2NLq7qL26rhiIUTD5Ci5LMFjrKWo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gVMG9eD1+7JeBW2ycAMSixzCJZrmut172O0yOpoY0jJy2yjkC1Y5+0DWdqbcpfhVl
         oi0c0IhTRAuqRWeBG0d8MheM53MjfvX1ib5B7MQ3TCTuydO+2IEREquDUGv6iLt72V
         mzDs5v1BUcnStAz2rNABE1Qdx0IUSPCTGfaQEzqY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Chris Packham <chris.packham@alliedtelesis.co.nz>,
        Guenter Roeck <linux@roeck-us.net>,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH 5.4 16/69] watchdog: orion: use 0 for unset heartbeat
Date:   Mon, 18 Oct 2021 15:24:14 +0200
Message-Id: <20211018132330.000309595@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211018132329.453964125@linuxfoundation.org>
References: <20211018132329.453964125@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chris Packham <chris.packham@alliedtelesis.co.nz>

commit bb914088bd8a91c382f54d469367b2e5508b5493 upstream.

If the heartbeat module param is not specified we would get an error
message

  watchdog: f1020300.watchdog: driver supplied timeout (4294967295) out of range
  watchdog: f1020300.watchdog: falling back to default timeout (171)

This is because we were initialising heartbeat to -1. By removing the
initialisation (thus letting the C run time initialise it to 0) we
silence the warning message and the default timeout is still used.

Signed-off-by: Chris Packham <chris.packham@alliedtelesis.co.nz>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Link: https://lore.kernel.org/r/20200313031312.1485-1-chris.packham@alliedtelesis.co.nz
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Wim Van Sebroeck <wim@linux-watchdog.org>
Signed-off-by: Marek Behún <kabel@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/watchdog/orion_wdt.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/watchdog/orion_wdt.c
+++ b/drivers/watchdog/orion_wdt.c
@@ -52,7 +52,7 @@
 #define WDT_A370_RATIO		(1 << WDT_A370_RATIO_SHIFT)
 
 static bool nowayout = WATCHDOG_NOWAYOUT;
-static int heartbeat = -1;		/* module parameter (seconds) */
+static int heartbeat;		/* module parameter (seconds) */
 
 struct orion_watchdog;
 


