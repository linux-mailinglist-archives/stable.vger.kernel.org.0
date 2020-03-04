Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0BB34178AEF
	for <lists+stable@lfdr.de>; Wed,  4 Mar 2020 07:52:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726233AbgCDGwr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Mar 2020 01:52:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:57710 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725892AbgCDGwr (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Mar 2020 01:52:47 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BFAD3215A4;
        Wed,  4 Mar 2020 06:52:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583304765;
        bh=CZGVBpl8QzzhtEGUSOA6fnaNG4ta+X1YZ/oCOoRbRbo=;
        h=Subject:To:From:Date:From;
        b=XOpeGCrklVJAZ3jr/H2FvtjBLClsqXhGTTNY6cfH/eHRRlENYYt7rUSSv6cSaX9QZ
         si7N2nvDZRQ+35JEGknV3Ew/2VBof/pWIz8C5OvSRgcMwTT/lrN+3vBoru53ypK0zG
         O9E4kl+EQrIj+ZPtcrSl3t+juyO64yRcfBZXqiLU=
Subject: patch "staging: kpc2000: prevent underflow in cpld_reconfigure()" added to staging-testing
To:     dan.carpenter@oracle.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 04 Mar 2020 07:52:43 +0100
Message-ID: <1583304763011@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    staging: kpc2000: prevent underflow in cpld_reconfigure()

to my staging git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
in the staging-testing branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will be merged to the staging-next branch sometime soon,
after it passes testing, and the merge window is open.

If you have any questions about this process, please let me know.


From 72db61d7d17a475d3cc9de1a7c871d518fcd82f0 Mon Sep 17 00:00:00 2001
From: Dan Carpenter <dan.carpenter@oracle.com>
Date: Mon, 24 Feb 2020 13:33:25 +0300
Subject: staging: kpc2000: prevent underflow in cpld_reconfigure()

This function should not allow negative values of "wr_val".  If
negatives are allowed then capping the upper bound at 7 is
meaningless.  Let's make it unsigned.

Fixes: 7dc7967fc39a ("staging: kpc2000: add initial set of Daktronics drivers")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20200224103325.hrxdnaeqsthplu42@kili.mountain
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/kpc2000/kpc2000/core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/kpc2000/kpc2000/core.c b/drivers/staging/kpc2000/kpc2000/core.c
index 93cf28febdf6..7b00d7069e21 100644
--- a/drivers/staging/kpc2000/kpc2000/core.c
+++ b/drivers/staging/kpc2000/kpc2000/core.c
@@ -110,10 +110,10 @@ static ssize_t cpld_reconfigure(struct device *dev,
 				const char *buf, size_t count)
 {
 	struct kp2000_device *pcard = dev_get_drvdata(dev);
-	long wr_val;
+	unsigned long wr_val;
 	int rv;
 
-	rv = kstrtol(buf, 0, &wr_val);
+	rv = kstrtoul(buf, 0, &wr_val);
 	if (rv < 0)
 		return rv;
 	if (wr_val > 7)
-- 
2.25.1


