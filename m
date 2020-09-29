Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03DCB27C480
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 13:14:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728783AbgI2LOc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 07:14:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:57246 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729413AbgI2LOV (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:14:21 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DB00522262;
        Tue, 29 Sep 2020 11:14:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601378060;
        bh=X7bnE5uynvYKEtswHr7q+4KIlMgYGOBnPmOIZlhFaIY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pZhFgJtG7LEc8Euv7mcx5jrhNz3aPJJpsJiOgeIWeIbGzj32y7awefWMIVDB+K7+Q
         hT6XsUwUvFiS+/f0KweZf9NmdeTVnfJSmwAWNto7oe1lJDXDh+DZsrFTGOtYMfr9ln
         gSNQq6LPU2RFEt8oG3Q/fqDq5io9PiYmMMkH2i7w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 047/166] ACPI: EC: Reference count query handlers under lock
Date:   Tue, 29 Sep 2020 12:59:19 +0200
Message-Id: <20200929105937.556170654@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929105935.184737111@linuxfoundation.org>
References: <20200929105935.184737111@linuxfoundation.org>
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
index ebfc06f29f7b2..37aacb39e6922 100644
--- a/drivers/acpi/ec.c
+++ b/drivers/acpi/ec.c
@@ -1062,29 +1062,21 @@ void acpi_ec_unblock_transactions(void)
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



