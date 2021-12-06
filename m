Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0C53469E30
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:36:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356479AbhLFPg5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:36:57 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:38648 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1388472AbhLFPdf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:33:35 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 026D2B8101B;
        Mon,  6 Dec 2021 15:30:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4859CC34901;
        Mon,  6 Dec 2021 15:30:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638804601;
        bh=rEaYd+Mlr/fu49cqq+Ij9EUvl1pdGwEAy6sEPn6lXss=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zNtkaMLwhdDGf++e17r2AYPEnkjNQ3w4YvbjLHXpkMsB1OrP6DuBF4yOJIt3xK0LB
         cbU77YO/TMWsieJIbC5RbosdVCP3r1IOdZfLGJFT53B0pAjRH/qWsCwjvyj90n2H2x
         K3m4wXiqpiCXysjqoh5suKHDfqX/t2dcM58JvwDc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johan Hovold <johan@kernel.org>,
        Ilia Sergachev <silia@ethz.ch>
Subject: [PATCH 5.15 204/207] serial: liteuart: Fix NULL pointer dereference in ->remove()
Date:   Mon,  6 Dec 2021 15:57:38 +0100
Message-Id: <20211206145617.350450491@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211206145610.172203682@linuxfoundation.org>
References: <20211206145610.172203682@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ilia Sergachev <silia@ethz.ch>

commit 0f55f89d98c8b3e12b4f55f71c127a173e29557c upstream.

drvdata has to be set in _probe() - otherwise platform_get_drvdata()
causes null pointer dereference BUG in _remove().

Fixes: 1da81e5562fa ("drivers/tty/serial: add LiteUART driver")
Cc: stable <stable@vger.kernel.org>
Reviewed-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Ilia Sergachev <silia@ethz.ch>
Link: https://lore.kernel.org/r/20211115224944.23f8c12b@dtkw
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/liteuart.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/tty/serial/liteuart.c
+++ b/drivers/tty/serial/liteuart.c
@@ -285,6 +285,8 @@ static int liteuart_probe(struct platfor
 	port->line = dev_id;
 	spin_lock_init(&port->lock);
 
+	platform_set_drvdata(pdev, port);
+
 	return uart_add_one_port(&liteuart_driver, &uart->port);
 }
 


