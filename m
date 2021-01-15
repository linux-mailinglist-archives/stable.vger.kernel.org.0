Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 811782F7AD1
	for <lists+stable@lfdr.de>; Fri, 15 Jan 2021 13:56:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387641AbhAOMzR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jan 2021 07:55:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:42472 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387643AbhAOMfV (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 15 Jan 2021 07:35:21 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8B1B823136;
        Fri, 15 Jan 2021 12:34:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610714081;
        bh=DXpiEc4h0HVA5+YwnioI9uEatc1ccXvj7bk9fvpLlrc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f/JCSH/yZzCKovKAWjcDghj9JzL4NOt1ynnAzPmE6+89vrPJx9NN/lX93JUBTTPYr
         3Y1pi8E7HRv5HmZS8vDKDNJADTUJeB6qRLP+7URpS8SerW2N/7dzCTmn4mLrjRg8Tz
         FS3Qlk6wyPypZUFmMTomay81MvA7ZyTYA5rFZiD0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Murphy <dmurphy@ti.com>,
        Sriram Dash <sriram.dash@samsung.com>,
        Sean Nyekjaer <sean@geanix.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 5.4 37/62] can: m_can: m_can_class_unregister(): remove erroneous m_can_clk_stop()
Date:   Fri, 15 Jan 2021 13:27:59 +0100
Message-Id: <20210115122000.190143068@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210115121958.391610178@linuxfoundation.org>
References: <20210115121958.391610178@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marc Kleine-Budde <mkl@pengutronix.de>

commit c4aec381ab98c9189d47b935832541d520f1f67f upstream.

In m_can_class_register() the clock is started, but stopped on exit. When
calling m_can_class_unregister(), the clock is stopped a second time.

This patch removes the erroneous m_can_clk_stop() in  m_can_class_unregister().

Fixes: f524f829b75a ("can: m_can: Create a m_can platform framework")
Cc: Dan Murphy <dmurphy@ti.com>
Cc: Sriram Dash <sriram.dash@samsung.com>
Reviewed-by: Sean Nyekjaer <sean@geanix.com>
Link: https://lore.kernel.org/r/20201215103238.524029-2-mkl@pengutronix.de
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/can/m_can/m_can.c |    2 --
 1 file changed, 2 deletions(-)

--- a/drivers/net/can/m_can/m_can.c
+++ b/drivers/net/can/m_can/m_can.c
@@ -1868,8 +1868,6 @@ void m_can_class_unregister(struct m_can
 {
 	unregister_candev(m_can_dev->net);
 
-	m_can_clk_stop(m_can_dev);
-
 	free_candev(m_can_dev->net);
 }
 EXPORT_SYMBOL_GPL(m_can_class_unregister);


