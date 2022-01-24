Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2C824998A8
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:38:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353017AbiAXV2i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:28:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1392046AbiAXVRG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:17:06 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CA11C067A4B;
        Mon, 24 Jan 2022 12:12:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 191756090A;
        Mon, 24 Jan 2022 20:12:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 153C9C340E5;
        Mon, 24 Jan 2022 20:12:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643055135;
        bh=iQYvZKOwn04GejAiJzx17eTC96LSLpLWKisII9IwQuA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bR42Fc8U6cmMmt5st1Te/qsONvq2UnlGX/nkQrwNpKeO4K2U9rD79O00AJkN4eTm5
         jj68I27OtxQ43JshMOgbp5PnZI94QbtMhUWxEqUfXSXrRqAjx5ncbUb+WSqKfTaIyj
         8y9KrA96BN0zErhzwL3jhQECl2u3CgGTEXWZ1+f4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johan Hovold <johan@kernel.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 5.15 053/846] can: softing_cs: softingcs_probe(): fix memleak on registration failure
Date:   Mon, 24 Jan 2022 19:32:50 +0100
Message-Id: <20220124184102.789483048@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
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
@@ -293,7 +293,7 @@ static int softingcs_probe(struct pcmcia
 	return 0;
 
 platform_failed:
-	kfree(dev);
+	platform_device_put(pdev);
 mem_failed:
 pcmcia_bad:
 pcmcia_failed:


