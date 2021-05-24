Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D219138EF19
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 17:54:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235192AbhEXP4E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 11:56:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:39394 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235486AbhEXPzJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 May 2021 11:55:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3B1736109F;
        Mon, 24 May 2021 15:41:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621870894;
        bh=fFISBQGlswKV4ngHO+piUv/DQV2UOjaGUS2vzv1mwvs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1CEjtOkA40wWvmpBPA/8RcbxgWUv9QGSvcVXr3ai5z4/nQP6mm+/nlHcIx2sbkce5
         T2afi73x0ehPH7Nt4FvDPN49cmfXAn5FwXPiezEtTSgRW65cFazMTM4F1eqvJTde4u
         jp+ESFy1ebqwgrt/zkYwBduT4jLt6NoJOQUhXlGE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peter Rosin <peda@axentia.se>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.10 082/104] cdrom: gdrom: initialize global variable at init time
Date:   Mon, 24 May 2021 17:26:17 +0200
Message-Id: <20210524152335.572311639@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210524152332.844251980@linuxfoundation.org>
References: <20210524152332.844251980@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit 9183f01b5e6e32eb3f17b5f3f8d5ad5ac9786c49 upstream.

As Peter points out, if we were to disconnect and then reconnect this
driver from a device, the "global" state of the device would contain odd
values and could cause problems.  Fix this up by just initializing the
whole thing to 0 at probe() time.

Ideally this would be a per-device variable, but given the age and the
total lack of users of it, that would require a lot of s/./->/g changes
for really no good reason.

Reported-by: Peter Rosin <peda@axentia.se>
Cc: Jens Axboe <axboe@kernel.dk>
Reviewed-by: Peter Rosin <peda@axentia.se>
Link: https://lore.kernel.org/r/YJP2j6AU82MqEY2M@kroah.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/cdrom/gdrom.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/drivers/cdrom/gdrom.c
+++ b/drivers/cdrom/gdrom.c
@@ -743,6 +743,13 @@ static const struct blk_mq_ops gdrom_mq_
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
@@ -848,7 +855,7 @@ static struct platform_driver gdrom_driv
 static int __init init_gdrom(void)
 {
 	int rc;
-	gd.toc = NULL;
+
 	rc = platform_driver_register(&gdrom_driver);
 	if (rc)
 		return rc;


