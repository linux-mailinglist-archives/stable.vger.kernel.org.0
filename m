Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4B01817F8D3
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 13:51:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728891AbgCJMvZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 08:51:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:56532 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728900AbgCJMvZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Mar 2020 08:51:25 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4F0C724686;
        Tue, 10 Mar 2020 12:51:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583844684;
        bh=sY5bfK+8ITb+dpGrs5Z9/t0hnwNG9E2OWdcwrAl2K48=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2VViqOXme7r1PCpRE9ahNVpLD1Bqs3OTGB1HQA27MMk606mmSYcTByrNwDpma6n8p
         XrsH7t4pcPUCrzXx5/JPB7JfN63rmJ/pwkfNptULaG9UJ10PdJVMUhgclhZTLtPHWI
         dIOghBIIP2HQIKAE2CIm+s2gJDCAI1EqCNNNmG0c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, tangbin <tangbin@cmss.chinamobile.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 5.4 082/168] tty:serial:mvebu-uart:fix a wrong return
Date:   Tue, 10 Mar 2020 13:38:48 +0100
Message-Id: <20200310123643.585056004@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200310123635.322799692@linuxfoundation.org>
References: <20200310123635.322799692@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: tangbin <tangbin@cmss.chinamobile.com>

commit 4a3e208474204e879d22a310b244cb2f39e5b1f8 upstream.

in this place, the function should return a
negative value and the PTR_ERR already returns
a negative,so return -PTR_ERR() is wrong.

Signed-off-by: tangbin <tangbin@cmss.chinamobile.com>
Cc: stable <stable@vger.kernel.org>
Acked-by: Jiri Slaby <jslaby@suse.cz>
Link: https://lore.kernel.org/r/20200305013823.20976-1-tangbin@cmss.chinamobile.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/tty/serial/mvebu-uart.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/tty/serial/mvebu-uart.c
+++ b/drivers/tty/serial/mvebu-uart.c
@@ -851,7 +851,7 @@ static int mvebu_uart_probe(struct platf
 
 	port->membase = devm_ioremap_resource(&pdev->dev, reg);
 	if (IS_ERR(port->membase))
-		return -PTR_ERR(port->membase);
+		return PTR_ERR(port->membase);
 
 	mvuart = devm_kzalloc(&pdev->dev, sizeof(struct mvebu_uart),
 			      GFP_KERNEL);


