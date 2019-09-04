Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B8750A901F
	for <lists+stable@lfdr.de>; Wed,  4 Sep 2019 21:37:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389274AbfIDSHs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Sep 2019 14:07:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:50376 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389666AbfIDSHs (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Sep 2019 14:07:48 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E121B2087E;
        Wed,  4 Sep 2019 18:07:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567620467;
        bh=5uk+51uu0Z02aMpaY4RrJs1/FVlS4vsGz6j6s1yrv74=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oF4z7BK5kJEcPBEg6sLeS0JD/DEgNmUnqM6C3ylc7zS7+tDWzkqsvAEuOFyJeQPos
         acxnbxGY7jmqVyShBoiU8tcyUR8qzx4WI5NaFabUFwuvCZ+OBbVUDZCkki3RxgHkre
         dLi4uejZegZ/5FkU9Jyfp05Ugdcey1rq5xxhDkqo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eddie James <eajames@linux.ibm.com>,
        Jeremy Kerr <jk@ozlabs.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Joel Stanley <joel@jms.id.au>
Subject: [PATCH 4.19 69/93] fsi: scom: Dont abort operations for minor errors
Date:   Wed,  4 Sep 2019 19:54:11 +0200
Message-Id: <20190904175309.006011103@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190904175302.845828956@linuxfoundation.org>
References: <20190904175302.845828956@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eddie James <eajames@linux.ibm.com>

commit 8919dfcb31161fae7d607bbef5247e5e82fd6457 upstream.

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
 drivers/fsi/fsi-scom.c |    8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

--- a/drivers/fsi/fsi-scom.c
+++ b/drivers/fsi/fsi-scom.c
@@ -47,8 +47,7 @@
 #define SCOM_STATUS_PIB_RESP_MASK	0x00007000
 #define SCOM_STATUS_PIB_RESP_SHIFT	12
 
-#define SCOM_STATUS_ANY_ERR		(SCOM_STATUS_ERR_SUMMARY | \
-					 SCOM_STATUS_PROTECTION | \
+#define SCOM_STATUS_ANY_ERR		(SCOM_STATUS_PROTECTION | \
 					 SCOM_STATUS_PARITY |	  \
 					 SCOM_STATUS_PIB_ABORT | \
 					 SCOM_STATUS_PIB_RESP_MASK)
@@ -260,11 +259,6 @@ static int handle_fsi2pib_status(struct
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
 


