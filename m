Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EAF61FB762
	for <lists+stable@lfdr.de>; Tue, 16 Jun 2020 17:47:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732102AbgFPPpi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Jun 2020 11:45:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:36976 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731071AbgFPPpe (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Jun 2020 11:45:34 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 20B162071A;
        Tue, 16 Jun 2020 15:45:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592322334;
        bh=IjT3crjofXBEWl5YFK02GjcaGpsi+bu/BrXFmNZ2GZo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tHUaJKIt4J/+X4FhtPbe8o26OdH9WLEfFPIKbeCR2xz3CkDrPO9opAjXI7cVkUjXr
         OehfOmZ99f75cqxiDASqx23j2AKJE1Iwc/RxCIZSUkxqV02HayJXKSaZ1/kKUyLHal
         1QxRxWH8adMdswwh6FWuwwk04g9ll9jEaNhyaofo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 5.7 061/163] serial: imx: Initialize lock for non-registered console
Date:   Tue, 16 Jun 2020 17:33:55 +0200
Message-Id: <20200616153109.772076964@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200616153106.849127260@linuxfoundation.org>
References: <20200616153106.849127260@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

commit 8f065acec7573672dd15916e31d1e9b2e785566c upstream.

The commit a3cb39d258ef
("serial: core: Allow detach and attach serial device for console")
changed a bit logic behind lock initialization since for most of the console
driver it's supposed to have lock already initialized even if console is not
enabled. However, it's not the case for Freescale IMX console.

Initialize lock explicitly in the ->probe().

Note, there is still an open question should or shouldn't not this driver
register console properly.

Fixes: a3cb39d258ef ("serial: core: Allow detach and attach serial device for console")
Reported-by: Guenter Roeck <linux@roeck-us.net>
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://lore.kernel.org/r/20200525105952.13744-1-andriy.shevchenko@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/tty/serial/imx.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/tty/serial/imx.c
+++ b/drivers/tty/serial/imx.c
@@ -2398,6 +2398,9 @@ static int imx_uart_probe(struct platfor
 		}
 	}
 
+	/* We need to initialize lock even for non-registered console */
+	spin_lock_init(&sport->port.lock);
+
 	imx_uart_ports[sport->port.line] = sport;
 
 	platform_set_drvdata(pdev, sport);


