Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9120037554B
	for <lists+stable@lfdr.de>; Thu,  6 May 2021 16:00:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234550AbhEFOBs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 May 2021 10:01:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:37248 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234303AbhEFOBr (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 6 May 2021 10:01:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3832B610FC;
        Thu,  6 May 2021 14:00:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620309649;
        bh=iq4hOzh6K2US8KJMLeXxFDLRjf5bYv2Fq5efxCMz7yI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=FH03nBluc5WCGvlxaUmU7xgUh3uEJaz377/KWmzp1HrHitOoiCR8Hwhj9/MGWMrla
         bpOJX3RXB/sn9k62a2BAjMDJOUUtocUEhIE/EXRUjs0S8+XpmTyfq8K/tdpFzs3oLZ
         4TVzrvPE1g7mvfh5+ZTUAhcZ9jFyVC5vWHF+XtZo=
Date:   Thu, 6 May 2021 16:00:47 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Peter Rosin <peda@axentia.se>
Cc:     linux-kernel@vger.kernel.org,
        Atul Gopinathan <atulgopinathan@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, stable <stable@vger.kernel.org>
Subject: [PATCH] cdrom: gdrom: initialize global variable at init time
Message-ID: <YJP2j6AU82MqEY2M@kroah.com>
References: <20210503115736.2104747-1-gregkh@linuxfoundation.org>
 <20210503115736.2104747-28-gregkh@linuxfoundation.org>
 <223d5bda-bf02-a4a8-ab1d-de25e32b8d47@axentia.se>
 <YJPDzqAAnP0jDRDF@kroah.com>
 <dd716d04-b9fa-986a-50dd-5c385ea745b2@axentia.se>
 <YJPybgcWYKLpyBdK@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YJPybgcWYKLpyBdK@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

As Peter points out, if we were to disconnect and then reconnect this
driver from a device, the "global" state of the device would contain odd
values and could cause problems.  Fix this up by just initializing the
whole thing to 0 at probe() time.

Ideally this would be a per-device variable, but given the age and the
total lack of users of it, that would require a lot of s/./->/g changes
for really no good reason.

Reported-by: Peter Rosin <peda@axentia.se>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---

Note, this goes on top of my previous "gdrom" patch submitted here:
	https://lore.kernel.org/lkml/20210503115736.2104747-28-gregkh@linuxfoundation.org/

And I'll just take it in the same series.

 drivers/cdrom/gdrom.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/cdrom/gdrom.c b/drivers/cdrom/gdrom.c
index 6c4f6139f853..c6d8c0f59722 100644
--- a/drivers/cdrom/gdrom.c
+++ b/drivers/cdrom/gdrom.c
@@ -744,6 +744,13 @@ static const struct blk_mq_ops gdrom_mq_ops = {
 static int probe_gdrom(struct platform_device *devptr)
 {
 	int err;
+
+	/*
+	 * Ensure our "one" device is initialized properly in case of previous
+	 * usages of it
+	 */
+	memset(&gd, 0, sizeof(gd));
+
 	/* Start the device */
 	if (gdrom_execute_diagnostic() != 1) {
 		pr_warn("ATA Probe for GDROM failed\n");
@@ -847,7 +854,7 @@ static struct platform_driver gdrom_driver = {
 static int __init init_gdrom(void)
 {
 	int rc;
-	gd.toc = NULL;
+
 	rc = platform_driver_register(&gdrom_driver);
 	if (rc)
 		return rc;
-- 
2.31.1

