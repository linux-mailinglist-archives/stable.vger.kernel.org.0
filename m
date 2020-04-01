Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F1CEB19B44C
	for <lists+stable@lfdr.de>; Wed,  1 Apr 2020 19:00:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732978AbgDAQWT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Apr 2020 12:22:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:45340 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387476AbgDAQWS (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Apr 2020 12:22:18 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7455E20857;
        Wed,  1 Apr 2020 16:22:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585758137;
        bh=XUZVInl2yIRIheP1ctm3J4tTtc4UpxGu/clhuSn6aSc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1eSwn0hVygkN5PHSnUwXRueo80NKEJsq+VVMLJ4f3ec2dqCcb9mhUbNa3npYjN/0N
         il1ePRJrC7Dl12/mr/Ndgu09jQA+FUFIYCib5kWjWOGPF4UEfALQaZufbcezmo46eE
         Mu/yC0RrWZPqSQE5ChV62TEcs90Ts2FwmoeRRQNo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Lanqing Liu <liuhhome@gmail.com>
Subject: [PATCH 5.4 03/27] serial: sprd: Fix a dereference warning
Date:   Wed,  1 Apr 2020 18:17:31 +0200
Message-Id: <20200401161417.599861325@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200401161414.352722470@linuxfoundation.org>
References: <20200401161414.352722470@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lanqing Liu <liuhhome@gmail.com>

commit efc176929a3505a30c3993ddd393b40893649bd2 upstream.

We should validate if the 'sup' is NULL or not before freeing DMA
memory, to fix below warning.

"drivers/tty/serial/sprd_serial.c:1141 sprd_remove()
 error: we previously assumed 'sup' could be null (see line 1132)"

Fixes: f4487db58eb7 ("serial: sprd: Add DMA mode support")
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Lanqing Liu <liuhhome@gmail.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/e2bd92691538e95b04a2c2a728f3292e1617018f.1584325957.git.liuhhome@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/tty/serial/sprd_serial.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/tty/serial/sprd_serial.c
+++ b/drivers/tty/serial/sprd_serial.c
@@ -1103,14 +1103,13 @@ static int sprd_remove(struct platform_d
 	if (sup) {
 		uart_remove_one_port(&sprd_uart_driver, &sup->port);
 		sprd_port[sup->port.line] = NULL;
+		sprd_rx_free_buf(sup);
 		sprd_ports_num--;
 	}
 
 	if (!sprd_ports_num)
 		uart_unregister_driver(&sprd_uart_driver);
 
-	sprd_rx_free_buf(sup);
-
 	return 0;
 }
 


