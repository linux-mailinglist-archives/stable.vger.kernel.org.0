Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B9F038EAA1
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 16:55:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233709AbhEXO5D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 10:57:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:34062 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234060AbhEXOyT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 May 2021 10:54:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 105A7613EE;
        Mon, 24 May 2021 14:48:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621867717;
        bh=GCSWZC8tZVJfp4+fAEFZL+brxp7ayg9ziCucMRpG96E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=obRNjfEemdkt1mr/dvFtD4wa8bdNnE86cd9Xz64DQzwdsAEYWieAOUnRFYeku7O7c
         YxNzeYNSi7GqA+SZGeM9F+clf3azzaJyGvq0/v2JJHH8LbqtAidiG7Y7vSRNx/NjK4
         9n0Rcm1rGjffcpKSdefkacx2oU4J44FQA/HjS9dZAgx5sfwkqO1gmXCGDpDxY6eFOE
         eqnJcZFAC0RFZndJziSlVETw5lj4lKD7vW2MbNP/gJwfHXXi8zF7PPcFBmeqfFZSga
         3McbRJrUIlWbnH6L60zobqe2pmL/c8KePQYeyxbXANrdWIUG70FacLiCzomhLnL279
         2/MrZDbT8A+wg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Peter Rosin <peda@axentia.se>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.10 43/62] cdrom: gdrom: initialize global variable at init time
Date:   Mon, 24 May 2021 10:47:24 -0400
Message-Id: <20210524144744.2497894-43-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210524144744.2497894-1-sashal@kernel.org>
References: <20210524144744.2497894-1-sashal@kernel.org>
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
index 9874fc1c815b..ecc99dd8b899 100644
--- a/drivers/cdrom/gdrom.c
+++ b/drivers/cdrom/gdrom.c
@@ -743,6 +743,13 @@ static const struct blk_mq_ops gdrom_mq_ops = {
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
@@ -846,7 +853,7 @@ static struct platform_driver gdrom_driver = {
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

