Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCE9640162B
	for <lists+stable@lfdr.de>; Mon,  6 Sep 2021 08:05:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238941AbhIFGGa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Sep 2021 02:06:30 -0400
Received: from mo-csw1114.securemx.jp ([210.130.202.156]:56392 "EHLO
        mo-csw.securemx.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230046AbhIFGG3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Sep 2021 02:06:29 -0400
Received: by mo-csw.securemx.jp (mx-mo-csw1114) id 18665OTI001342; Mon, 6 Sep 2021 15:05:24 +0900
X-Iguazu-Qid: 2wHH6p2Z5wNq93JvTX
X-Iguazu-QSIG: v=2; s=0; t=1630908324; q=2wHH6p2Z5wNq93JvTX; m=IBk0ow9+6eQiwzWPNmbwY5PAVXFm5nzwVfWUXOn9bJg=
Received: from imx2-a.toshiba.co.jp (imx2-a.toshiba.co.jp [106.186.93.35])
        by relay.securemx.jp (mx-mr1111) id 18665Na7012743
        (version=TLSv1.2 cipher=AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 6 Sep 2021 15:05:24 +0900
Received: from enc01.toshiba.co.jp (enc01.toshiba.co.jp [106.186.93.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by imx2-a.toshiba.co.jp (Postfix) with ESMTPS id B2B6B1000D9
        for <stable@vger.kernel.org>; Mon,  6 Sep 2021 15:05:23 +0900 (JST)
Received: from hop001.toshiba.co.jp ([133.199.164.63])
        by enc01.toshiba.co.jp  with ESMTP id 18665NBM017821
        for <stable@vger.kernel.org>; Mon, 6 Sep 2021 15:05:23 +0900
From:   Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
To:     stable@vger.kernel.org
Cc:     gregkh@linuxfoundation.org, sashal@kernel.org,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Naresh Kamboju <naresh.kamboju@linaro.org>,
        Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
Subject: [PATCH for 5.10.y] serial: 8250: 8250_omap: Fix possible array out of bounds access
Date:   Mon,  6 Sep 2021 15:05:12 +0900
X-TSB-HOP: ON
Message-Id: <20210906060512.2913106-1-nobuhiro1.iwamatsu@toshiba.co.jp>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Nobuhiro Iwamatsu (CIP) <nobuhiro1.iwamatsu@toshiba.co.jp>
---
 drivers/tty/serial/8250/8250_omap.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/tty/serial/8250/8250_omap.c b/drivers/tty/serial/8250/8250_omap.c
index 95e2d6de4f2134..ad0549dac7d792 100644
--- a/drivers/tty/serial/8250/8250_omap.c
+++ b/drivers/tty/serial/8250/8250_omap.c
@@ -1211,6 +1211,7 @@ static int omap8250_no_handle_irq(struct uart_port *port)
 static const struct soc_device_attribute k3_soc_devices[] = {
 	{ .family = "AM65X",  },
 	{ .family = "J721E", .revision = "SR1.0" },
+	{ /* sentinel */ }
 };
 
 static struct omap8250_dma_params am654_dma = {
-- 
2.33.0


