Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 941642E3E43
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:27:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503342AbgL1O0O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:26:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:33622 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2503276AbgL1OZo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:25:44 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D3CCD2245C;
        Mon, 28 Dec 2020 14:25:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609165503;
        bh=g2Zt8DLmwegqzrGW2W4zZDFBNp5yfj7K/uAC3UoCwFo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kVfxP8vwUr/mnr2CGUntk0rYs8yuQ0ZtdPduj7Eo6aOqkpJgBEk5LRpYGXgxBZcOQ
         RAAjhm1sSYUH/TWf2uovKawuNB1jQt8atqPFi9PChNHFyDGGML38rXsa4KbYurf/35
         SRX6Dn/wHevBgYh7eR7FjyeXUMOX1c6ckwz85OxA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stefan Haberland <sth@linux.ibm.com>,
        Jan Hoeppner <hoeppner@linux.ibm.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.10 555/717] s390/dasd: fix hanging device offline processing
Date:   Mon, 28 Dec 2020 13:49:13 +0100
Message-Id: <20201228125047.523184966@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stefan Haberland <sth@linux.ibm.com>

commit 658a337a606f48b7ebe451591f7681d383fa115e upstream.

For an LCU update a read unit address configuration IO is required.
This is started using sleep_on(), which has early exit paths in case the
device is not usable for IO. For example when it is in offline processing.

In those cases the LCU update should fail and not be retried.
Therefore lcu_update_work checks if EOPNOTSUPP is returned or not.

Commit 41995342b40c ("s390/dasd: fix endless loop after read unit address configuration")
accidentally removed the EOPNOTSUPP return code from
read_unit_address_configuration(), which in turn might lead to an endless
loop of the LCU update in offline processing.

Fix by returning EOPNOTSUPP again if the device is not able to perform the
request.

Fixes: 41995342b40c ("s390/dasd: fix endless loop after read unit address configuration")
Cc: stable@vger.kernel.org #5.3
Signed-off-by: Stefan Haberland <sth@linux.ibm.com>
Reviewed-by: Jan Hoeppner <hoeppner@linux.ibm.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/s390/block/dasd_alias.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- a/drivers/s390/block/dasd_alias.c
+++ b/drivers/s390/block/dasd_alias.c
@@ -462,11 +462,19 @@ static int read_unit_address_configurati
 	spin_unlock_irqrestore(&lcu->lock, flags);
 
 	rc = dasd_sleep_on(cqr);
-	if (rc && !suborder_not_supported(cqr)) {
+	if (!rc)
+		goto out;
+
+	if (suborder_not_supported(cqr)) {
+		/* suborder not supported or device unusable for IO */
+		rc = -EOPNOTSUPP;
+	} else {
+		/* IO failed but should be retried */
 		spin_lock_irqsave(&lcu->lock, flags);
 		lcu->flags |= NEED_UAC_UPDATE;
 		spin_unlock_irqrestore(&lcu->lock, flags);
 	}
+out:
 	dasd_sfree_request(cqr, cqr->memdev);
 	return rc;
 }


