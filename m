Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EB5038EBBB
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 17:06:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234040AbhEXPGx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 11:06:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:37038 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233686AbhEXPDA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 May 2021 11:03:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D528F61463;
        Mon, 24 May 2021 14:50:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621867828;
        bh=vhhxpzbKU/r5BRm8W5nj/mHAZi+NTOQ/VaGwI6zNK00=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=akJPnrApJZ7vBxejm9hSc5PvO/L4ibJOq5Ux5iD0RxeKsjim7OW/38garI3ZuF92L
         sOHYBO59m3SqrTrTaI+JHaHPuLwNcAa5nWJhwS3gFulNMTA5t7VeIIodaSXQoA1mZg
         7y9mJDN/lAi2Qs6HMo1cBbdKB+h7Jyepqp++7j3tDkoQFHcoOLU3l7MwzydXFZyYoM
         ZlGXJyDzs2OfrzQ4xl4fsEYRYW7OJcvYZOq/mqHpcGuvcrsIrwdSHyzmyE59NVMBU8
         I1n+ePRhMhkjoOeCvMlZ3B871ynOfuIShvWonPfcr4XAl+ye7e+PAIOUxsFm3dbf0H
         XCk6Na3ASD8Bw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Peter Rosin <peda@axentia.se>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 16/25] cdrom: gdrom: initialize global variable at init time
Date:   Mon, 24 May 2021 10:49:59 -0400
Message-Id: <20210524145008.2499049-16-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210524145008.2499049-1-sashal@kernel.org>
References: <20210524145008.2499049-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

[ Upstream commit 9183f01b5e6e32eb3f17b5f3f8d5ad5ac9786c49 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cdrom/gdrom.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/cdrom/gdrom.c b/drivers/cdrom/gdrom.c
index 72cd96a8eb19..5474357beb23 100644
--- a/drivers/cdrom/gdrom.c
+++ b/drivers/cdrom/gdrom.c
@@ -775,6 +775,13 @@ static int probe_gdrom_setupqueue(void)
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
 		pr_warning("ATA Probe for GDROM failed\n");
@@ -872,7 +879,7 @@ static struct platform_driver gdrom_driver = {
 static int __init init_gdrom(void)
 {
 	int rc;
-	gd.toc = NULL;
+
 	rc = platform_driver_register(&gdrom_driver);
 	if (rc)
 		return rc;
-- 
2.30.2

