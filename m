Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB307498BF2
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 20:18:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344498AbiAXTRp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 14:17:45 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:40686 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237442AbiAXTPo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 14:15:44 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 601EAB81238;
        Mon, 24 Jan 2022 19:15:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E90EC340F6;
        Mon, 24 Jan 2022 19:15:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643051742;
        bh=gTiAsola0UWMwwPm3YlisJWsAT/oMqMZKVdHyRXMZh0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Aj4tcqTzhk4qx6Chu2TUgrf4Ox1BBkJRBFY2xL52SraFSbGbQuEzmNMsvCGBc1ei1
         RdrqsPjdSxRZQ3Zq8xObWdQY9VTCzaUPfEB3t+S0oGyHB6txgSTKzrbgV4GW7z0Jc7
         m78/GaTPJAfOe8IndmWx8LXhhjlEjDC/orVt5+1Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johan Hovold <johan@kernel.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 4.19 040/239] can: softing_cs: softingcs_probe(): fix memleak on registration failure
Date:   Mon, 24 Jan 2022 19:41:18 +0100
Message-Id: <20220124183944.415549225@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124183943.102762895@linuxfoundation.org>
References: <20220124183943.102762895@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Hovold <johan@kernel.org>

commit ced4913efb0acc844ed65cc01d091a85d83a2082 upstream.

In case device registration fails during probe, the driver state and
the embedded platform device structure needs to be freed using
platform_device_put() to properly free all resources (e.g. the device
name).

Fixes: 0a0b7a5f7a04 ("can: add driver for Softing card")
Link: https://lore.kernel.org/all/20211222104843.6105-1-johan@kernel.org
Cc: stable@vger.kernel.org # 2.6.38
Signed-off-by: Johan Hovold <johan@kernel.org>
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/can/softing/softing_cs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/can/softing/softing_cs.c
+++ b/drivers/net/can/softing/softing_cs.c
@@ -304,7 +304,7 @@ static int softingcs_probe(struct pcmcia
 	return 0;
 
 platform_failed:
-	kfree(dev);
+	platform_device_put(pdev);
 mem_failed:
 pcmcia_bad:
 pcmcia_failed:


