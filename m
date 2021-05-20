Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A84F538A80D
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 12:45:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237666AbhETKqC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 06:46:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:44958 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237912AbhETKoG (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 06:44:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BB96861C90;
        Thu, 20 May 2021 09:56:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621504620;
        bh=97YbxEaPhkNbzZCJI9dvPq3/hKx5CAZlYlzMlxBP67o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o7mrqCjG6wuaB8LXV7g+TPVkNQMwFbEQm2evhnWLhrSZMnBxgilVSDd0CQ1+mx0Ih
         cBYKnM9ESA/EmhXIoFpsz15pW4IDH/x+Hdb3vpxxmQTz+mfkMEP33qYOGHy7RNOxx9
         rmcTSPCqZ6v7+QqHuJzpXQgXWnmwyrSVsIg18fGQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tomas Melin <tomas.melin@vaisala.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 319/323] serial: 8250: fix potential deadlock in rs485-mode
Date:   Thu, 20 May 2021 11:23:31 +0200
Message-Id: <20210520092131.177575205@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092120.115153432@linuxfoundation.org>
References: <20210520092120.115153432@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tomas Melin <tomas.melin@vaisala.com>

[ Upstream commit b86f86e8e7c5264bb8f5835d60f9ec840d9f5a7a ]

Canceling hrtimer when holding uart spinlock can deadlock.

CPU0: syscall write
          -> get uart port spinlock
              -> write uart
                  -> start_tx_rs485
                      -> hrtimer_cancel
                          -> wait for hrtimer callback to finish

CPU1: hrtimer IRQ
          -> run hrtimer
              -> em485_handle_stop_tx
                  -> get uart port spinlock

CPU0 is waiting for the hrtimer callback to finish, but the hrtimer
callback running on CPU1 is waiting to get the uart port spinlock.

This deadlock can be avoided by not canceling the hrtimers in these paths.
Setting active_timer=NULL can be done without accessing hrtimer,
and that will effectively cancel operations that would otherwise have been
performed by the hrtimer callback.

Signed-off-by: Tomas Melin <tomas.melin@vaisala.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/8250/8250_port.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/drivers/tty/serial/8250/8250_port.c
+++ b/drivers/tty/serial/8250/8250_port.c
@@ -1527,7 +1527,6 @@ static inline void __stop_tx(struct uart
 			return;
 
 		em485->active_timer = NULL;
-		hrtimer_cancel(&em485->start_tx_timer);
 
 		__stop_tx_rs485(p);
 	}
@@ -1591,8 +1590,6 @@ static inline void start_tx_rs485(struct
 		serial8250_stop_rx(&up->port);
 
 	em485->active_timer = NULL;
-	if (hrtimer_is_queued(&em485->stop_tx_timer))
-		hrtimer_cancel(&em485->stop_tx_timer);
 
 	mcr = serial8250_in_MCR(up);
 	if (!!(up->port.rs485.flags & SER_RS485_RTS_ON_SEND) !=


