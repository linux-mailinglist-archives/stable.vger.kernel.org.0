Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 367863C553F
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:55:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355451AbhGLIJo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 04:09:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:56278 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1353361AbhGLIB7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 04:01:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 40B60619C5;
        Mon, 12 Jul 2021 07:54:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626076482;
        bh=U4HjI47KCJIYgnxN+fCf3OzxKHp2GiTPZRHIoYr9Cqw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=L2wu7otWMlvSBRlEHSICPf/ZxMR+VhxkKC0a5hPgRYbq5b7CTTGbsAIihTqe/Zh1V
         UtI+crZJUKKyBRzEK/G+pudSoQK7UYXAbG5x2X9/Bhtesdixb2Csw3BpflLdt++7rR
         OXxg47JYKyw2v7Kis0vWR0QJCHM3HFbYdX6XQ90U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alexander Sverdlin <alexander.sverdlin@gmail.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 609/800] serial: 8250_omap: fix a timeout loop condition
Date:   Mon, 12 Jul 2021 08:10:32 +0200
Message-Id: <20210712061032.057211236@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
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
index 8ac11eaeca51..c06631ced414 100644
--- a/drivers/tty/serial/8250/8250_omap.c
+++ b/drivers/tty/serial/8250/8250_omap.c
@@ -813,7 +813,7 @@ static void __dma_rx_do_complete(struct uart_8250_port *p)
 			       poll_count--)
 				cpu_relax();
 
-			if (!poll_count)
+			if (poll_count == -1)
 				dev_err(p->port.dev, "teardown incomplete\n");
 		}
 	}
-- 
2.30.2



