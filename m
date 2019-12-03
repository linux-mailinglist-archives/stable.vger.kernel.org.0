Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D752111D20
	for <lists+stable@lfdr.de>; Tue,  3 Dec 2019 23:51:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729436AbfLCWu3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Dec 2019 17:50:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:42064 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729756AbfLCWu1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Dec 2019 17:50:27 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 13DC020863;
        Tue,  3 Dec 2019 22:50:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575413426;
        bh=ewg2iAP8wiQOEAN1Lo6n0e2slYRIgf4B8vDxOHN64Eo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kKj92l1Yenj5Ic3YTpfXyLMupP04341Chl0NHnh+0wo/QHcAWl6ZmLA8/VgtuXuGw
         GqPa6CVVpYPDMW9nfbaWt5P4RcFEM8BB53FZ68xEpezmE1+ectEEHeJbG+mWnRYpDE
         csoVDewh+Cz8NYjBihx8An62TbEvMs9Be+r4RB9k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 122/321] serial: sh-sci: Fix crash in rx_timer_fn() on PIO fallback
Date:   Tue,  3 Dec 2019 23:33:08 +0100
Message-Id: <20191203223433.502621112@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191203223427.103571230@linuxfoundation.org>
References: <20191203223427.103571230@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit 2e948218b7c1262a3830823d6620eb227e3d4e3a ]

When falling back to PIO, active_rx must be set to a different value
than cookie_rx[i], else sci_dma_rx_find_active() will incorrectly find a
match, leading to a NULL pointer dereference in rx_timer_fn() later.

Use zero instead, which is the same value as after driver
initialization.

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/sh-sci.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/tty/serial/sh-sci.c b/drivers/tty/serial/sh-sci.c
index 5550289e6678b..9e1a6af23ca2b 100644
--- a/drivers/tty/serial/sh-sci.c
+++ b/drivers/tty/serial/sh-sci.c
@@ -1359,7 +1359,7 @@ fail:
 		dmaengine_terminate_async(chan);
 	for (i = 0; i < 2; i++)
 		s->cookie_rx[i] = -EINVAL;
-	s->active_rx = -EINVAL;
+	s->active_rx = 0;
 	s->chan_rx = NULL;
 	sci_start_rx(port);
 	if (!port_lock_held)
-- 
2.20.1



