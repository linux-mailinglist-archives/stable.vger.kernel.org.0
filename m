Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 706B388D34
	for <lists+stable@lfdr.de>; Sat, 10 Aug 2019 22:43:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726201AbfHJUnr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Aug 2019 16:43:47 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:53730 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726014AbfHJUnr (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 10 Aug 2019 16:43:47 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1hwYDI-00052s-Ks; Sat, 10 Aug 2019 21:43:44 +0100
Received: from ben by deadeye with local (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1hwYDI-0003Xk-CL; Sat, 10 Aug 2019 21:43:44 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Markus Elfring" <elfring@users.sourceforge.net>,
        "Jonathan Cameron" <jic23@kernel.org>
Date:   Sat, 10 Aug 2019 21:40:07 +0100
Message-ID: <lsq.1565469607.57202441@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 004/157] iio: Use kmalloc_array() in iio_scan_mask_set()
In-Reply-To: <lsq.1565469607.188083258@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.72-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Markus Elfring <elfring@users.sourceforge.net>

commit 057ac1acdfc4743f066fcefe359385cad00549eb upstream.

A multiplication for the size determination of a memory allocation
indicated that an array data structure should be processed.
Thus use the corresponding function "kmalloc_array".

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
Signed-off-by: Jonathan Cameron <jic23@kernel.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/iio/industrialio-buffer.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/drivers/iio/industrialio-buffer.c
+++ b/drivers/iio/industrialio-buffer.c
@@ -836,10 +836,9 @@ int iio_scan_mask_set(struct iio_dev *in
 	const unsigned long *mask;
 	unsigned long *trialmask;
 
-	trialmask = kmalloc(sizeof(*trialmask)*
-			    BITS_TO_LONGS(indio_dev->masklength),
-			    GFP_KERNEL);
-
+	trialmask = kmalloc_array(BITS_TO_LONGS(indio_dev->masklength),
+				  sizeof(*trialmask),
+				  GFP_KERNEL);
 	if (trialmask == NULL)
 		return -ENOMEM;
 	if (!indio_dev->masklength) {

