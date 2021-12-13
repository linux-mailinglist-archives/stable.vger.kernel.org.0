Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98B2B4726F6
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 10:57:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234067AbhLMJ4e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 04:56:34 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:40552 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235887AbhLMJya (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 04:54:30 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 186F0B80E62;
        Mon, 13 Dec 2021 09:54:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 465FFC34602;
        Mon, 13 Dec 2021 09:54:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639389266;
        bh=Nr/FUe7+bnrkEBnwcHVcN1SVK2Sl+aX4hUUv3BbxLQc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rPV607Ojy+HPMJjRYVQoJZXe7K0GTkFe1NKWzVPWNZL979nOifLwjurU8gH+VJCez
         O5BXmdN1OuKYeNhleSr8Y6Rtvfwnl4DKxtP1wzO5fZHYb+kuIeDFHxlCTl5UWxl1sz
         lmPycRb7Pp3TE9d+4AheM6FucDbRb8oqm6FqouQ4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 5.15 023/171] can: sja1000: fix use after free in ems_pcmcia_add_card()
Date:   Mon, 13 Dec 2021 10:28:58 +0100
Message-Id: <20211213092945.852408856@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211213092945.091487407@linuxfoundation.org>
References: <20211213092945.091487407@linuxfoundation.org>
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
@@ -234,7 +234,12 @@ static int ems_pcmcia_add_card(struct pc
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


