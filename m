Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B8901B40E7
	for <lists+stable@lfdr.de>; Wed, 22 Apr 2020 12:49:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729459AbgDVKtD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Apr 2020 06:49:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:48026 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729442AbgDVKNv (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Apr 2020 06:13:51 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2DAE92071E;
        Wed, 22 Apr 2020 10:13:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587550430;
        bh=LXPWYG4z5+vvrhoERwmekrRYM9JEuLFtWYJbqt8j26E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wjjKUA1V5I64t8yLb/fcs5uSpUQRJiati7mY8XF/9LnBbWVl30a+vy2rlCz4+wjp0
         nKlC/E29h7YoUqVHciK2v42+jNAy/XnvnMPo1z719hZEsp24sxlZGwuMtKWSd/5tXq
         HTNEF5nHbkhV8dNwjogeZ4rXZu/KUCQ6+Q5W8+cI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Walle <michael@walle.cc>,
        Guenter Roeck <linux@roeck-us.net>,
        Wim Van Sebroeck <wim@linux-watchdog.org>
Subject: [PATCH 4.19 05/64] watchdog: sp805: fix restart handler
Date:   Wed, 22 Apr 2020 11:56:49 +0200
Message-Id: <20200422095013.224193329@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200422095008.799686511@linuxfoundation.org>
References: <20200422095008.799686511@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Walle <michael@walle.cc>

commit ea104a9e4d3e9ebc26fb78dac35585b142ee288b upstream.

The restart handler is missing two things, first, the registers
has to be unlocked and second there is no synchronization for the
write_relaxed() calls.

This was tested on a custom board with the NXP LS1028A SoC.

Fixes: 6c5c0d48b686c ("watchdog: sp805: add restart handler")
Signed-off-by: Michael Walle <michael@walle.cc>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Link: https://lore.kernel.org/r/20200327162450.28506-1-michael@walle.cc
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Wim Van Sebroeck <wim@linux-watchdog.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/watchdog/sp805_wdt.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/watchdog/sp805_wdt.c
+++ b/drivers/watchdog/sp805_wdt.c
@@ -137,10 +137,14 @@ wdt_restart(struct watchdog_device *wdd,
 {
 	struct sp805_wdt *wdt = watchdog_get_drvdata(wdd);
 
+	writel_relaxed(UNLOCK, wdt->base + WDTLOCK);
 	writel_relaxed(0, wdt->base + WDTCONTROL);
 	writel_relaxed(0, wdt->base + WDTLOAD);
 	writel_relaxed(INT_ENABLE | RESET_ENABLE, wdt->base + WDTCONTROL);
 
+	/* Flush posted writes. */
+	readl_relaxed(wdt->base + WDTLOCK);
+
 	return 0;
 }
 


