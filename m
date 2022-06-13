Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CAA36548D3D
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:15:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381460AbiFMOIa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 10:08:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382630AbiFMOGI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 10:06:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DEFB95A1D;
        Mon, 13 Jun 2022 04:41:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 51A2F6124E;
        Mon, 13 Jun 2022 11:41:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 628FBC34114;
        Mon, 13 Jun 2022 11:41:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655120463;
        bh=HRL1W3H3oXzbvv3ZmLRhHB16qHoYyZT0QHPA9gHqHuw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FR5ocm3Wf35abg6wDK3WfvixYbvKvRki5Zxsch1QzuaHvAoDfs+6vKHDxExgugyqL
         onSf6xTWk/ekfHAyQG4h/Vkw6KB1i5K4N57tG3l6nAvn8mu4IZumUoveYCU2nAkBcN
         vDN9RFXzhM5qM9Hn5imKEocra50dsj7/qI/px1zA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaoqian Lin <linmq006@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 009/298] serial: 8250_aspeed_vuart: Fix potential NULL dereference in aspeed_vuart_probe
Date:   Mon, 13 Jun 2022 12:08:23 +0200
Message-Id: <20220613094925.205304903@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094924.913340374@linuxfoundation.org>
References: <20220613094924.913340374@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miaoqian Lin <linmq006@gmail.com>

[ Upstream commit 0e0fd55719fa081de6f9e5d9e6cef48efb04d34a ]

platform_get_resource() may fail and return NULL, so we should
better check it's return value to avoid a NULL pointer dereference.

Fixes: 54da3e381c2b ("serial: 8250_aspeed_vuart: use UPF_IOREMAP to set up register mapping")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Link: https://lore.kernel.org/r/20220404143842.16960-1-linmq006@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/8250/8250_aspeed_vuart.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/tty/serial/8250/8250_aspeed_vuart.c b/drivers/tty/serial/8250/8250_aspeed_vuart.c
index c2cecc6f47db..179bb1375636 100644
--- a/drivers/tty/serial/8250/8250_aspeed_vuart.c
+++ b/drivers/tty/serial/8250/8250_aspeed_vuart.c
@@ -429,6 +429,8 @@ static int aspeed_vuart_probe(struct platform_device *pdev)
 	timer_setup(&vuart->unthrottle_timer, aspeed_vuart_unthrottle_exp, 0);
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!res)
+		return -EINVAL;
 
 	memset(&port, 0, sizeof(port));
 	port.port.private_data = vuart;
-- 
2.35.1



