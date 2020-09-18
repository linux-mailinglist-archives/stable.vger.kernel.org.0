Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBD8926EDB2
	for <lists+stable@lfdr.de>; Fri, 18 Sep 2020 04:23:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729452AbgIRCWz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Sep 2020 22:22:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:47294 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729482AbgIRCRC (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 17 Sep 2020 22:17:02 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 95CE6239D4;
        Fri, 18 Sep 2020 02:17:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600395422;
        bh=Bv4NdRNFNxCHZraeIsHJIIhSpe22g8VMRyLUvFVf5jY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pjj2jfaekm3oDXIsWsWP/iFPNFxxdp7UakFCMr9DuL4aKQDtQApInnSs8qSS7BHWH
         f4360xUBSyJ4JYtkKieUQp+KrMlaHJ73z9n8xD4xDZ3e6TtyOIgMdrunkjQZ1cnzUY
         nPs+PpvVnIxPBfXYcxmUGJXXbAV/T5B8rsj6xHhU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>, linux-acpi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 16/64] ACPI: EC: Reference count query handlers under lock
Date:   Thu, 17 Sep 2020 22:15:55 -0400
Message-Id: <20200918021643.2067895-16-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200918021643.2067895-1-sashal@kernel.org>
References: <20200918021643.2067895-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>

[ Upstream commit 3df663a147fe077a6ee8444ec626738946e65547 ]

There is a race condition in acpi_ec_get_query_handler()
theoretically allowing query handlers to go away before refernce
counting them.

In order to avoid it, call kref_get() on query handlers under
ec->mutex.

Also simplify the code a bit while at it.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/ec.c | 16 ++++------------
 1 file changed, 4 insertions(+), 12 deletions(-)

diff --git a/drivers/acpi/ec.c b/drivers/acpi/ec.c
index 43f20328f830e..3096c087b7328 100644
--- a/drivers/acpi/ec.c
+++ b/drivers/acpi/ec.c
@@ -943,29 +943,21 @@ void acpi_ec_unblock_transactions_early(void)
 /* --------------------------------------------------------------------------
                                 Event Management
    -------------------------------------------------------------------------- */
-static struct acpi_ec_query_handler *
-acpi_ec_get_query_handler(struct acpi_ec_query_handler *handler)
-{
-	if (handler)
-		kref_get(&handler->kref);
-	return handler;
-}
-
 static struct acpi_ec_query_handler *
 acpi_ec_get_query_handler_by_value(struct acpi_ec *ec, u8 value)
 {
 	struct acpi_ec_query_handler *handler;
-	bool found = false;
 
 	mutex_lock(&ec->mutex);
 	list_for_each_entry(handler, &ec->list, node) {
 		if (value == handler->query_bit) {
-			found = true;
-			break;
+			kref_get(&handler->kref);
+			mutex_unlock(&ec->mutex);
+			return handler;
 		}
 	}
 	mutex_unlock(&ec->mutex);
-	return found ? acpi_ec_get_query_handler(handler) : NULL;
+	return NULL;
 }
 
 static void acpi_ec_query_handler_release(struct kref *kref)
-- 
2.25.1

