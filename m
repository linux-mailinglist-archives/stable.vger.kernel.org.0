Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EA5A43A050
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 21:27:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235856AbhJYT3u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 15:29:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:45600 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234574AbhJYT1s (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Oct 2021 15:27:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9A38960724;
        Mon, 25 Oct 2021 19:24:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635189872;
        bh=aSmZfjkgSa7Iut3ph86BQ+Tim2lJcrhYwRH/lVerHc4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ARyGncWfidVZdCIxg2/RlWc+6ltKQSDXPuuH5gHh8FXUPDfKUSvVUkASBTd9Ed3hN
         GOrqZru7Mem32d0Puoxy+pFM6YkdBjtmdETxB0pDYRpohFCasfLsx5Mq+jt6YVPtac
         apINfiZTQwLXs2lVrqq2tErAcqO4/oNavbdLf6jw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Stephane Grosjean <s.grosjean@peak-system.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 4.19 13/37] can: peak_usb: pcan_usb_fd_decode_status(): fix back to ERROR_ACTIVE state notification
Date:   Mon, 25 Oct 2021 21:14:38 +0200
Message-Id: <20211025190930.850232086@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211025190926.680827862@linuxfoundation.org>
References: <20211025190926.680827862@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stephane Grosjean <s.grosjean@peak-system.com>

commit 3d031abc7e7249573148871180c28ecedb5e27df upstream.

This corrects the lack of notification of a return to ERROR_ACTIVE
state for USB - CANFD devices from PEAK-System.

Fixes: 0a25e1f4f185 ("can: peak_usb: add support for PEAK new CANFD USB adapters")
Link: https://lore.kernel.org/all/20210929142111.55757-1-s.grosjean@peak-system.com
Cc: stable@vger.kernel.org
Signed-off-by: Stephane Grosjean <s.grosjean@peak-system.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/can/usb/peak_usb/pcan_usb_fd.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/drivers/net/can/usb/peak_usb/pcan_usb_fd.c
+++ b/drivers/net/can/usb/peak_usb/pcan_usb_fd.c
@@ -559,11 +559,10 @@ static int pcan_usb_fd_decode_status(str
 	} else if (sm->channel_p_w_b & PUCAN_BUS_WARNING) {
 		new_state = CAN_STATE_ERROR_WARNING;
 	} else {
-		/* no error bit (so, no error skb, back to active state) */
-		dev->can.state = CAN_STATE_ERROR_ACTIVE;
+		/* back to (or still in) ERROR_ACTIVE state */
+		new_state = CAN_STATE_ERROR_ACTIVE;
 		pdev->bec.txerr = 0;
 		pdev->bec.rxerr = 0;
-		return 0;
 	}
 
 	/* state hasn't changed */


