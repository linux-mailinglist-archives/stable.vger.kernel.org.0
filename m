Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 676B43C4B5E
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:36:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238371AbhGLG4u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:56:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:48258 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238665AbhGLGtJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:49:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 02B65610D0;
        Mon, 12 Jul 2021 06:44:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626072297;
        bh=B4modiCHNILEbjx7vHdMmuC7bKCSL9wWF9zJsy2tG9s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0vGvSaZmU9J4Mb3gXB5+XAO2Kxa+Iqktv0PDJs7pe52k8w6qEOTzC21MmDdvdW/AM
         IHJYCNSvfe+JMQ9KulBmhfCxxkx/ocQcm514zpF5ESS+H6JZnlW6kEe5hXitlkPM4C
         V8EAgtOAFjHDOPOAkTg2/5qP7EDyDPdzQAyUrj48=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alexander Sverdlin <alexander.sverdlin@gmail.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 439/593] serial: 8250_omap: fix a timeout loop condition
Date:   Mon, 12 Jul 2021 08:09:59 +0200
Message-Id: <20210712060937.076064465@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060843.180606720@linuxfoundation.org>
References: <20210712060843.180606720@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit d7e325aaa8c3593b5a572b583ecad79e95f32e7f ]

This loop ends on -1 so the error message will never be printed.

Fixes: 4bcf59a5dea0 ("serial: 8250: 8250_omap: Account for data in flight during DMA teardown")
Reviewed-by: Alexander Sverdlin <alexander.sverdlin@gmail.com>
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Link: https://lore.kernel.org/r/YIpd+kOpXKMpEXPf@mwanda
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/8250/8250_omap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/tty/serial/8250/8250_omap.c b/drivers/tty/serial/8250/8250_omap.c
index 0cc6d35a0815..f284c6f77a6c 100644
--- a/drivers/tty/serial/8250/8250_omap.c
+++ b/drivers/tty/serial/8250/8250_omap.c
@@ -784,7 +784,7 @@ static void __dma_rx_do_complete(struct uart_8250_port *p)
 			       poll_count--)
 				cpu_relax();
 
-			if (!poll_count)
+			if (poll_count == -1)
 				dev_err(p->port.dev, "teardown incomplete\n");
 		}
 	}
-- 
2.30.2



