Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0914A27C987
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 14:11:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730222AbgI2ML0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 08:11:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:53442 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730176AbgI2Lhd (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:37:33 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C017C239EE;
        Tue, 29 Sep 2020 11:22:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601378546;
        bh=lPnOkEVay478y9gjrNSiigt93CRSArNgZBRn8dG9wLc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=y7EQoeJmCiG9S1JJWHoGeW+5frqL+B2YMzlIwxVfTUm4ZEn25YZrQNsQHuK0PR0tK
         YNEynDuAY9XO90UfYAN4lXDeqIa8y+Fwg8NsVqifBEbt38RrK9LN3whgSjDXJLEmte
         9uoALRRc4N1vg5iUfBqIj56HTnccNzMGTMSzAmTc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 053/245] ACPI: EC: Reference count query handlers under lock
Date:   Tue, 29 Sep 2020 12:58:24 +0200
Message-Id: <20200929105949.580680387@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929105946.978650816@linuxfoundation.org>
References: <20200929105946.978650816@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

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



