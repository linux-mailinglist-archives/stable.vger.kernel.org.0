Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9964138EB58
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 17:01:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234305AbhEXPC3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 11:02:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:37282 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234565AbhEXPAG (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 May 2021 11:00:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5A0FA613E1;
        Mon, 24 May 2021 14:49:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621867793;
        bh=zn9f4oYkoliiUUPuFD+/FEofeqOsIbxKWQGGp6BPPLo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JcxPF4ryUfmr9mc1BSv18liTp6E/kpVPopMEGBA5rKuzBx9Sw509rmXWe7fyyKJ/p
         OxnlF9U9YNZE7gSD3aRUHV70A6etpFqDfgfgvWYPKNuRuRUnFqinbGxm1XX3tOwrwA
         3Ucj5o43WBjKojQNn+KdOQjyuJdt0xsAXG52vls2Gd2Lx6pzXleqfyjESnwdC6G8wx
         RWEP78Y9+82Mc3OCREArTggWH9VSojDbHH0UKb8F2l07nvzIpkHfIqbGc1Mf0mCsp0
         wixk5/AWQxCJj+TK9FybRSbA6XNcXzw2GgbDg78YTuIFiDKDgUSSGnTtPSqnHI2bDd
         1Zya65gN3r1dQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Peter Rosin <peda@axentia.se>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.4 40/52] cdrom: gdrom: initialize global variable at init time
Date:   Mon, 24 May 2021 10:48:50 -0400
Message-Id: <20210524144903.2498518-40-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210524144903.2498518-1-sashal@kernel.org>
References: <20210524144903.2498518-1-sashal@kernel.org>
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
index 6626c84f66d1..88dc80ae0488 100644
--- a/drivers/cdrom/gdrom.c
+++ b/drivers/cdrom/gdrom.c
@@ -740,6 +740,13 @@ static const struct blk_mq_ops gdrom_mq_ops = {
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
@@ -843,7 +850,7 @@ static struct platform_driver gdrom_driver = {
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

