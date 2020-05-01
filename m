Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DA9C1C13F2
	for <lists+stable@lfdr.de>; Fri,  1 May 2020 15:34:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729662AbgEANeX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 May 2020 09:34:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:60470 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730553AbgEANeS (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 1 May 2020 09:34:18 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9CDD824954;
        Fri,  1 May 2020 13:34:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588340058;
        bh=BL+iUwzCf3163pq7lcS691f60h7nMcprI631MupoxuI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0jB18A/2V7mpy02WKQlQLCvdIFF4NdSU5bRpyWFeZAMNtZhZlC5mB8YlCkUHHB7iI
         B83SeVG1rvnMmlGKGQnMx/1TqOmT6MIeppjh36IcEF5kJgzhU+Qj9OzKabF6yST0Xi
         UglaTwamuLH//LnmjfOkpDYfL3YYz6e5lrgleb6o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Oliver Neukum <oneukum@suse.com>,
        Jonas Karlsson <jonas.karlsson@actia.se>
Subject: [PATCH 4.14 077/117] cdc-acm: close race betrween suspend() and acm_softint
Date:   Fri,  1 May 2020 15:21:53 +0200
Message-Id: <20200501131554.085402615@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200501131544.291247695@linuxfoundation.org>
References: <20200501131544.291247695@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Oliver Neukum <oneukum@suse.com>

commit 0afccd7601514c4b83d8cc58c740089cc447051d upstream.

Suspend increments a counter, then kills the URBs,
then kills the scheduled work. The scheduled work, however,
may reschedule the URBs. Fix this by having the work
check the counter.

Signed-off-by: Oliver Neukum <oneukum@suse.com>
Cc: stable <stable@vger.kernel.org>
Tested-by: Jonas Karlsson <jonas.karlsson@actia.se>
Link: https://lore.kernel.org/r/20200415151358.32664-1-oneukum@suse.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/class/cdc-acm.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -575,14 +575,14 @@ static void acm_softint(struct work_stru
 	struct acm *acm = container_of(work, struct acm, work);
 
 	if (test_bit(EVENT_RX_STALL, &acm->flags)) {
-		if (!(usb_autopm_get_interface(acm->data))) {
+		smp_mb(); /* against acm_suspend() */
+		if (!acm->susp_count) {
 			for (i = 0; i < acm->rx_buflimit; i++)
 				usb_kill_urb(acm->read_urbs[i]);
 			usb_clear_halt(acm->dev, acm->in);
 			acm_submit_read_urbs(acm, GFP_KERNEL);
-			usb_autopm_put_interface(acm->data);
+			clear_bit(EVENT_RX_STALL, &acm->flags);
 		}
-		clear_bit(EVENT_RX_STALL, &acm->flags);
 	}
 
 	if (test_and_clear_bit(EVENT_TTY_WAKEUP, &acm->flags))


