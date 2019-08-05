Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E914C81C9F
	for <lists+stable@lfdr.de>; Mon,  5 Aug 2019 15:26:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730217AbfHENZ4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Aug 2019 09:25:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:34474 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730776AbfHENZy (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Aug 2019 09:25:54 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E9B2620644;
        Mon,  5 Aug 2019 13:25:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565011554;
        bh=Vl6OPnb9Fexr5uG2WQcqeRCcoYoD+Utx6wUVCjijQ8Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fFJgRje0shTaJa9RKCrRFemPPPnD6X++0X23GtrOqqo78us2RNBSsWjGaj2rpjk11
         7i3Tsxc5uIQoFFxTyBor0QRQEbTsRlUc5U8JIcsoyNBvrv0x9XQpVDbD5sqMlXQrT/
         TCuuDDyNFnbToc0ea1SNDI95xVrH31mJvOQ38zS4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stefan Haberland <sth@linux.ibm.com>,
        Jan Hoeppner <hoeppner@linux.ibm.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.2 106/131] s390/dasd: fix endless loop after read unit address configuration
Date:   Mon,  5 Aug 2019 15:03:13 +0200
Message-Id: <20190805124959.070635530@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190805124951.453337465@linuxfoundation.org>
References: <20190805124951.453337465@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stefan Haberland <sth@linux.ibm.com>

commit 41995342b40c418a47603e1321256d2c4a2ed0fb upstream.

After getting a storage server event that causes the DASD device driver
to update its unit address configuration during a device shutdown there is
the possibility of an endless loop in the device driver.

In the system log there will be ongoing DASD error messages with RC: -19.

The reason is that the loop starting the ruac request only terminates when
the retry counter is decreased to 0. But in the sleep_on function there are
early exit paths that do not decrease the retry counter.

Prevent an endless loop by handling those cases separately.

Remove the unnecessary do..while loop since the sleep_on function takes
care of retries by itself.

Fixes: 8e09f21574ea ("[S390] dasd: add hyper PAV support to DASD device driver, part 1")
Cc: stable@vger.kernel.org # 2.6.25+
Signed-off-by: Stefan Haberland <sth@linux.ibm.com>
Reviewed-by: Jan Hoeppner <hoeppner@linux.ibm.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/s390/block/dasd_alias.c |   22 ++++++++++++++++------
 1 file changed, 16 insertions(+), 6 deletions(-)

--- a/drivers/s390/block/dasd_alias.c
+++ b/drivers/s390/block/dasd_alias.c
@@ -383,6 +383,20 @@ suborder_not_supported(struct dasd_ccw_r
 	char msg_format;
 	char msg_no;
 
+	/*
+	 * intrc values ENODEV, ENOLINK and EPERM
+	 * will be optained from sleep_on to indicate that no
+	 * IO operation can be started
+	 */
+	if (cqr->intrc == -ENODEV)
+		return 1;
+
+	if (cqr->intrc == -ENOLINK)
+		return 1;
+
+	if (cqr->intrc == -EPERM)
+		return 1;
+
 	sense = dasd_get_sense(&cqr->irb);
 	if (!sense)
 		return 0;
@@ -447,12 +461,8 @@ static int read_unit_address_configurati
 	lcu->flags &= ~NEED_UAC_UPDATE;
 	spin_unlock_irqrestore(&lcu->lock, flags);
 
-	do {
-		rc = dasd_sleep_on(cqr);
-		if (rc && suborder_not_supported(cqr))
-			return -EOPNOTSUPP;
-	} while (rc && (cqr->retries > 0));
-	if (rc) {
+	rc = dasd_sleep_on(cqr);
+	if (rc && !suborder_not_supported(cqr)) {
 		spin_lock_irqsave(&lcu->lock, flags);
 		lcu->flags |= NEED_UAC_UPDATE;
 		spin_unlock_irqrestore(&lcu->lock, flags);


