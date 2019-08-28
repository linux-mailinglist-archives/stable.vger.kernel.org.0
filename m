Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3DB1BA0BF0
	for <lists+stable@lfdr.de>; Wed, 28 Aug 2019 23:00:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726787AbfH1VAx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Aug 2019 17:00:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:60658 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726400AbfH1VAx (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 28 Aug 2019 17:00:53 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CF7CC217F5;
        Wed, 28 Aug 2019 21:00:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567026052;
        bh=hMaq4d88zgmeEINc0kzV6TAs/bsilbcEliJEqAMkOwE=;
        h=Subject:To:From:Date:From;
        b=QuklLNq5LnYNm5H7LhrnknnnGbhXycIMlluUVXrz6bq1Pl7WOpGNGxIA5gXqtjFop
         Ghx6+iLexuF46g/WSCLx9cN+GDqhls3xmgu8Y4n1mF+j5kD0iBLv41qGBAuO9S4NAM
         yWq7aRmrB3NuUV+T0csW5JIMJc2/8MA02pfuzL74=
Subject: patch "fsi: scom: Don't abort operations for minor errors" added to char-misc-linus
To:     eajames@linux.ibm.com, benh@kernel.crashing.org,
        gregkh@linuxfoundation.org, jk@ozlabs.org, joel@jms.id.au,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 28 Aug 2019 23:00:49 +0200
Message-ID: <156702604917936@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    fsi: scom: Don't abort operations for minor errors

to my char-misc git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
in the char-misc-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 8919dfcb31161fae7d607bbef5247e5e82fd6457 Mon Sep 17 00:00:00 2001
From: Eddie James <eajames@linux.ibm.com>
Date: Tue, 27 Aug 2019 12:12:49 +0800
Subject: fsi: scom: Don't abort operations for minor errors

The scom driver currently fails out of operations if certain system
errors are flagged in the status register; system checkstop, special
attention, or recoverable error. These errors won't impact the ability
of the scom engine to perform operations, so the driver should continue
under these conditions.
Also, don't do a PIB reset for these conditions, since it won't help.

Fixes: 6b293258cded ("fsi: scom: Major overhaul")
Signed-off-by: Eddie James <eajames@linux.ibm.com>
Cc: stable <stable@vger.kernel.org>
Acked-by: Jeremy Kerr <jk@ozlabs.org>
Acked-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Joel Stanley <joel@jms.id.au>
Link: https://lore.kernel.org/r/20190827041249.13381-1-jk@ozlabs.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/fsi/fsi-scom.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/drivers/fsi/fsi-scom.c b/drivers/fsi/fsi-scom.c
index 343153d47e5b..004dc03ccf09 100644
--- a/drivers/fsi/fsi-scom.c
+++ b/drivers/fsi/fsi-scom.c
@@ -38,8 +38,7 @@
 #define SCOM_STATUS_PIB_RESP_MASK	0x00007000
 #define SCOM_STATUS_PIB_RESP_SHIFT	12
 
-#define SCOM_STATUS_ANY_ERR		(SCOM_STATUS_ERR_SUMMARY | \
-					 SCOM_STATUS_PROTECTION | \
+#define SCOM_STATUS_ANY_ERR		(SCOM_STATUS_PROTECTION | \
 					 SCOM_STATUS_PARITY |	  \
 					 SCOM_STATUS_PIB_ABORT | \
 					 SCOM_STATUS_PIB_RESP_MASK)
@@ -251,11 +250,6 @@ static int handle_fsi2pib_status(struct scom_device *scom, uint32_t status)
 	/* Return -EBUSY on PIB abort to force a retry */
 	if (status & SCOM_STATUS_PIB_ABORT)
 		return -EBUSY;
-	if (status & SCOM_STATUS_ERR_SUMMARY) {
-		fsi_device_write(scom->fsi_dev, SCOM_FSI2PIB_RESET_REG, &dummy,
-				 sizeof(uint32_t));
-		return -EIO;
-	}
 	return 0;
 }
 
-- 
2.23.0


