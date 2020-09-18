Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E3C626F139
	for <lists+stable@lfdr.de>; Fri, 18 Sep 2020 04:49:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727482AbgIRCtp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Sep 2020 22:49:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:60668 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726614AbgIRCJA (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 17 Sep 2020 22:09:00 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 92E6F2311A;
        Fri, 18 Sep 2020 02:08:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600394940;
        bh=7LF6/4oznZ2tJv2xUTQ/4w4eX7xZx53xXP/6Q+5r9Hw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZnI/IUaB/r3OV9gYiAV8MeLGJnNRXHgP4lhsxXZhBjAcnG5iQyfWXhpEOHXzXaWA+
         Bm2L27GvdeDh0kvyZ+WZFCxIH3spJxrxtCWstt5dp/sd67BU5rJWPL7eOAG+kCUXtt
         OXC7t4s+xtB2IRn5odNr0fbWlpsK+ibYFN4MrY10=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>, linux-acpi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 049/206] ACPI: EC: Reference count query handlers under lock
Date:   Thu, 17 Sep 2020 22:05:25 -0400
Message-Id: <20200918020802.2065198-49-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200918020802.2065198-1-sashal@kernel.org>
References: <20200918020802.2065198-1-sashal@kernel.org>
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
index 49e16f0090957..9415a0041aaf7 100644
--- a/drivers/acpi/ec.c
+++ b/drivers/acpi/ec.c
@@ -1080,29 +1080,21 @@ void acpi_ec_dispatch_gpe(void)
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

