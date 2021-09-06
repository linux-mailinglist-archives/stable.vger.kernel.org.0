Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5441D401BAC
	for <lists+stable@lfdr.de>; Mon,  6 Sep 2021 14:57:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242868AbhIFM6m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Sep 2021 08:58:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:35164 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242879AbhIFM6S (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 6 Sep 2021 08:58:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8291660F43;
        Mon,  6 Sep 2021 12:57:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1630933034;
        bh=KtZMGk+XiYo0AJyQWlhdYYB1Vxc0m0xAFz1Z7VeIKz0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QxJvuTJyC7Ay/0+gv6OS/hamlUQ1QBfYdR0YRLvxMMJKyhHGxd22XbehkFjeSCQjs
         +/KyAfZ+Qs6d5yjjJaAYuycLniuGP6qiX49WZ/eECDm/U3q57fApaJ+NWVOYYnPTn3
         OElMSxksw1u4Y2ZJMypfVT0gZfvCieveN27vU7DA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Naresh Kamboju <naresh.kamboju@linaro.org>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        "Nobuhiro Iwamatsu (CIP)" <nobuhiro1.iwamatsu@toshiba.co.jp>
Subject: [PATCH 5.10 25/29] serial: 8250: 8250_omap: Fix possible array out of bounds access
Date:   Mon,  6 Sep 2021 14:55:40 +0200
Message-Id: <20210906125450.618585679@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210906125449.756437409@linuxfoundation.org>
References: <20210906125449.756437409@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vignesh Raghavendra <vigneshr@ti.com>

commit d4548b14dd7e5c698f81ce23ce7b69a896373b45 upstream.

k3_soc_devices array is missing a sentinel entry which may result in out
of bounds access as reported by kernel KASAN.

Fix this by adding a sentinel entry.

Fixes: 439c7183e5b9 ("serial: 8250: 8250_omap: Disable RX interrupt after DMA enable")
Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>
Signed-off-by: Vignesh Raghavendra <vigneshr@ti.com>
Link: https://lore.kernel.org/r/20201111112653.2710-1-vigneshr@ti.com
Signed-off-by: Nobuhiro Iwamatsu (CIP) <nobuhiro1.iwamatsu@toshiba.co.jp>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/8250/8250_omap.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/tty/serial/8250/8250_omap.c
+++ b/drivers/tty/serial/8250/8250_omap.c
@@ -1211,6 +1211,7 @@ static int omap8250_no_handle_irq(struct
 static const struct soc_device_attribute k3_soc_devices[] = {
 	{ .family = "AM65X",  },
 	{ .family = "J721E", .revision = "SR1.0" },
+	{ /* sentinel */ }
 };
 
 static struct omap8250_dma_params am654_dma = {


