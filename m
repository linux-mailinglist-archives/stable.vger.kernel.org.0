Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AA89A12EF7D
	for <lists+stable@lfdr.de>; Thu,  2 Jan 2020 23:46:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729641AbgABWah (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jan 2020 17:30:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:34632 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729864AbgABWag (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Jan 2020 17:30:36 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1324F21D7D;
        Thu,  2 Jan 2020 22:30:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578004236;
        bh=UlIrjS1VdleJiidbkoDs/wX9bcdlxfb/lXPxLMDuuM4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xnJn1kGfDWDl/9PsW6a9BiIHO+5p6doVMKJLYMa5OFgpcb5SJ0YRaYNbZHgL610np
         JB5A/gCE2BhnnXZlpVpowQBlGmhn3vTw9MwXxA3NBTaD3EQHQD+oav6arpzqDtbc+F
         Ql0dT5JGlnct6BxqgxHgqM0coJfvOwN0ydgM1RFw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chuhong Yuan <hslester96@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.9 094/171] fjes: fix missed check in fjes_acpi_add
Date:   Thu,  2 Jan 2020 23:07:05 +0100
Message-Id: <20200102220600.231348306@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200102220546.960200039@linuxfoundation.org>
References: <20200102220546.960200039@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chuhong Yuan <hslester96@gmail.com>

[ Upstream commit a288f105a03a7e0e629a8da2b31f34ebf0343ee2 ]

fjes_acpi_add() misses a check for platform_device_register_simple().
Add a check to fix it.

Fixes: 658d439b2292 ("fjes: Introduce FUJITSU Extended Socket Network Device driver")
Signed-off-by: Chuhong Yuan <hslester96@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/fjes/fjes_main.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/net/fjes/fjes_main.c
+++ b/drivers/net/fjes/fjes_main.c
@@ -148,6 +148,9 @@ static int fjes_acpi_add(struct acpi_dev
 	/* create platform_device */
 	plat_dev = platform_device_register_simple(DRV_NAME, 0, fjes_resource,
 						   ARRAY_SIZE(fjes_resource));
+	if (IS_ERR(plat_dev))
+		return PTR_ERR(plat_dev);
+
 	device->driver_data = plat_dev;
 
 	return 0;


