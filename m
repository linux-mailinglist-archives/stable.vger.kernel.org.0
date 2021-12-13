Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78A2747298F
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 11:24:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241312AbhLMKXY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 05:23:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236804AbhLMJrb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 04:47:31 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6DEBC0698D7;
        Mon, 13 Dec 2021 01:42:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 2F7B1CE0B59;
        Mon, 13 Dec 2021 09:42:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF52DC00446;
        Mon, 13 Dec 2021 09:42:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639388548;
        bh=qDXaSaxmEZateudXlrVulZq1YeE+yl3kbgOZBcV7Xho=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u0rQD8k0jA2G4ImzcSCvQD+QKw64HHjuuKlZCV6nmE6JLSkI3zN/qQivE7sN24lbq
         SlvBiQyvBjJD60LJlYLTkkmWtpYC9reEZQsQBH9o1yaatXUnVv5HOQrjhPoybL6djP
         qERSlqHgfsw4NUHFjuqbafmvwoamwcTyaa6rTbWc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 5.4 14/88] can: sja1000: fix use after free in ems_pcmcia_add_card()
Date:   Mon, 13 Dec 2021 10:29:44 +0100
Message-Id: <20211213092933.709848670@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211213092933.250314515@linuxfoundation.org>
References: <20211213092933.250314515@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

commit 3ec6ca6b1a8e64389f0212b5a1b0f6fed1909e45 upstream.

If the last channel is not available then "dev" is freed.  Fortunately,
we can just use "pdev->irq" instead.

Also we should check if at least one channel was set up.

Fixes: fd734c6f25ae ("can/sja1000: add driver for EMS PCMCIA card")
Link: https://lore.kernel.org/all/20211124145041.GB13656@kili
Cc: stable@vger.kernel.org
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Acked-by: Oliver Hartkopp <socketcan@hartkopp.net>
Tested-by: Oliver Hartkopp <socketcan@hartkopp.net>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/can/sja1000/ems_pcmcia.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/drivers/net/can/sja1000/ems_pcmcia.c
+++ b/drivers/net/can/sja1000/ems_pcmcia.c
@@ -235,7 +235,12 @@ static int ems_pcmcia_add_card(struct pc
 			free_sja1000dev(dev);
 	}
 
-	err = request_irq(dev->irq, &ems_pcmcia_interrupt, IRQF_SHARED,
+	if (!card->channels) {
+		err = -ENODEV;
+		goto failure_cleanup;
+	}
+
+	err = request_irq(pdev->irq, &ems_pcmcia_interrupt, IRQF_SHARED,
 			  DRV_NAME, card);
 	if (!err)
 		return 0;


