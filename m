Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C09353C4BA9
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:37:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237422AbhGLG6l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:58:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:58974 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239817AbhGLG6B (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:58:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 45C68613EB;
        Mon, 12 Jul 2021 06:55:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626072908;
        bh=isnSSOi9t/7E3k0sfD83D9sSb2OIubB7DPFcAezP1fU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QmOjvRc14JcDBP4jDe0d23yoPAcRxFes68rb8M3rg3CznlbVB+8QjdNZzntGWuEuF
         5xZOKf63zlGouwDqdPiFys8Ot9nhguDcBhpzn31zSjel/30ReSVbZyTipDRNmGSaJt
         pYCjxNVVc2x+rZcK7kBOT7qQS3oTvDUwuDKAFuqs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Stephane Grosjean <s.grosjean@peak-system.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 5.12 061/700] can: peak_pciefd: pucan_handle_status(): fix a potential starvation issue in TX path
Date:   Mon, 12 Jul 2021 08:02:24 +0200
Message-Id: <20210712060933.362297811@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060924.797321836@linuxfoundation.org>
References: <20210712060924.797321836@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stephane Grosjean <s.grosjean@peak-system.com>

commit b17233d385d0b6b43ecf81d43008cb1bbb008166 upstream.

Rather than just indicating that transmission can start, this patch
requires the explicit flushing of the network TX queue when the driver
is informed by the device that it can transmit, next to its
configuration.

In this way, if frames have already been written by the application,
they will actually be transmitted.

Fixes: ffd137f7043c ("can: peak/pcie_fd: remove useless code when interface starts")
Link: https://lore.kernel.org/r/20210623142600.149904-1-s.grosjean@peak-system.com
Cc: linux-stable <stable@vger.kernel.org>
Signed-off-by: Stephane Grosjean <s.grosjean@peak-system.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/can/peak_canfd/peak_canfd.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/net/can/peak_canfd/peak_canfd.c
+++ b/drivers/net/can/peak_canfd/peak_canfd.c
@@ -351,8 +351,8 @@ static int pucan_handle_status(struct pe
 				return err;
 		}
 
-		/* start network queue (echo_skb array is empty) */
-		netif_start_queue(ndev);
+		/* wake network queue up (echo_skb array is empty) */
+		netif_wake_queue(ndev);
 
 		return 0;
 	}


