Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BF2CA19901F
	for <lists+stable@lfdr.de>; Tue, 31 Mar 2020 11:09:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731313AbgCaJJO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Mar 2020 05:09:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:52180 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731202AbgCaJJM (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 31 Mar 2020 05:09:12 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 601AF20675;
        Tue, 31 Mar 2020 09:09:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585645751;
        bh=Ne9+LlSQFMWHN1DGAzP8M7ivWUlamrWM9ZR/Ae2AiRA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RZl/TOb0Ohz9+cv7C7LtfXVOZV8lr1z0PMoJuKiJP6/DyKDyIwXP7RUu2pxXZ8L0q
         4SV6hhkTBUPb4YMMfbmg2mvy/45dUFq04/BAiNn2BPjRQdSgVLjTmlfB0Vvw3Ie80t
         u6UAoc2nV58O+N/UlWnfUyg4WHdWHalgcV8C2THg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Anthony Mallet <anthony.mallet@laas.fr>,
        Oliver Neukum <oneukum@suse.com>,
        Matthias Reichl <hias@horus.com>
Subject: [PATCH 5.5 152/170] USB: cdc-acm: restore capability check order
Date:   Tue, 31 Mar 2020 10:59:26 +0200
Message-Id: <20200331085439.279687524@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200331085423.990189598@linuxfoundation.org>
References: <20200331085423.990189598@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Matthias Reichl <hias@horus.com>

commit 62d65bdd9d05158aa2547f8ef72375535f3bc6e3 upstream.

commit b401f8c4f492c ("USB: cdc-acm: fix rounding error in TIOCSSERIAL")
introduced a regression by changing the order of capability and close
settings change checks. When running with CAP_SYS_ADMIN setting the
close settings to the values already set resulted in -EOPNOTSUPP.

Fix this by changing the check order back to how it was before.

Fixes: b401f8c4f492c ("USB: cdc-acm: fix rounding error in TIOCSSERIAL")
Cc: Anthony Mallet <anthony.mallet@laas.fr>
Cc: stable <stable@vger.kernel.org>
Cc: Oliver Neukum <oneukum@suse.com>
Signed-off-by: Matthias Reichl <hias@horus.com>
Link: https://lore.kernel.org/r/20200327150350.3657-1-hias@horus.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/class/cdc-acm.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -923,16 +923,16 @@ static int set_serial_info(struct tty_st
 
 	mutex_lock(&acm->port.mutex);
 
-	if ((ss->close_delay != old_close_delay) ||
-            (ss->closing_wait != old_closing_wait)) {
-		if (!capable(CAP_SYS_ADMIN))
+	if (!capable(CAP_SYS_ADMIN)) {
+		if ((ss->close_delay != old_close_delay) ||
+		    (ss->closing_wait != old_closing_wait))
 			retval = -EPERM;
-		else {
-			acm->port.close_delay  = close_delay;
-			acm->port.closing_wait = closing_wait;
-		}
-	} else
-		retval = -EOPNOTSUPP;
+		else
+			retval = -EOPNOTSUPP;
+	} else {
+		acm->port.close_delay  = close_delay;
+		acm->port.closing_wait = closing_wait;
+	}
 
 	mutex_unlock(&acm->port.mutex);
 	return retval;


