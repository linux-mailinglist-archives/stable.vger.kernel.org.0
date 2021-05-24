Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D71238EC5C
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 17:13:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235008AbhEXPOL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 11:14:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:40898 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234809AbhEXPJK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 May 2021 11:09:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EB00361923;
        Mon, 24 May 2021 14:51:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621867905;
        bh=3agf5KXNZ6/n5GIQRNy9BWouSZMCtDuiIdMlV8G2GjQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sL10FE4E0eHcHe7ikN2+aiPdgu+muEKSsCH9Yd0Qgl8b/8RaOLF48KQuACTgXXjWy
         0+UhRlO1GDkVZvJEbr/FcJR7XInVC4h1iErn0C4fUPXTH/aYPmrvnoX+wzkIhiaydf
         Y30jCyU/57RE1HM1HBA6QUhqQc6AXw9svor+jne/4LIkrb3ApfCrgBuiSAx7gXMTyZ
         RbfbHu2m13diPQweg8cbXcLqN64iq7LlOKqUvVMGhEQCvNEc4x1AQ03KqMMfqZtmxl
         l+jMfSJjsRceNolkYTlar5yMlYjv8ceS0F2o5I1xabWpZQbvngjcXfTJ/K8SgSZ9sN
         SGmQZ2sCb9eFA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Peter Rosin <peda@axentia.se>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.4 12/16] cdrom: gdrom: initialize global variable at init time
Date:   Mon, 24 May 2021 10:51:26 -0400
Message-Id: <20210524145130.2499829-12-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210524145130.2499829-1-sashal@kernel.org>
References: <20210524145130.2499829-1-sashal@kernel.org>
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
index 1852d19d0d7b..2a78aeea84a2 100644
--- a/drivers/cdrom/gdrom.c
+++ b/drivers/cdrom/gdrom.c
@@ -773,6 +773,13 @@ static int probe_gdrom_setupqueue(void)
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
@@ -865,7 +872,7 @@ static struct platform_driver gdrom_driver = {
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

