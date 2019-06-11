Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0DC863CECD
	for <lists+stable@lfdr.de>; Tue, 11 Jun 2019 16:33:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391155AbfFKOdC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Jun 2019 10:33:02 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59154 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391127AbfFKOdC (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 11 Jun 2019 10:33:02 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 89907307D965;
        Tue, 11 Jun 2019 14:33:02 +0000 (UTC)
Received: from shalem.localdomain.com (ovpn-117-112.ams2.redhat.com [10.36.117.112])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 95754608CD;
        Tue, 11 Jun 2019 14:33:01 +0000 (UTC)
From:   Hans de Goede <hdegoede@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Hans de Goede <hdegoede@redhat.com>, linux-ide@vger.kernel.org,
        stable@vger.kernel.org
Subject: [PATCH] libata: Extend quirks for the ST1000LM024 drives with NOLPM quirk
Date:   Tue, 11 Jun 2019 16:32:59 +0200
Message-Id: <20190611143259.28647-1-hdegoede@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.48]); Tue, 11 Jun 2019 14:33:02 +0000 (UTC)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

We've received a bugreport that using LPM with ST1000LM024 drives leads
to system lockups. So it seems that these models are buggy in more then
1 way. Add NOLPM quirk to the existing quirks entry for BROKEN_FPDMA_AA.

BugLink: https://bugzilla.redhat.com/show_bug.cgi?id=1571330
Cc: stable@vger.kernel.org
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 drivers/ata/libata-core.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index aaa57e0c809d..4a2dff303865 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -4460,9 +4460,12 @@ static const struct ata_blacklist_entry ata_device_blacklist [] = {
 	{ "ST3320[68]13AS",	"SD1[5-9]",	ATA_HORKAGE_NONCQ |
 						ATA_HORKAGE_FIRMWARE_WARN },
 
-	/* drives which fail FPDMA_AA activation (some may freeze afterwards) */
-	{ "ST1000LM024 HN-M101MBB", "2AR10001",	ATA_HORKAGE_BROKEN_FPDMA_AA },
-	{ "ST1000LM024 HN-M101MBB", "2BA30001",	ATA_HORKAGE_BROKEN_FPDMA_AA },
+	/* drives which fail FPDMA_AA activation (some may freeze afterwards)
+	   the ST disks also have LPM issues */
+	{ "ST1000LM024 HN-M101MBB", "2AR10001",	ATA_HORKAGE_BROKEN_FPDMA_AA |
+						ATA_HORKAGE_NOLPM, },
+	{ "ST1000LM024 HN-M101MBB", "2BA30001",	ATA_HORKAGE_BROKEN_FPDMA_AA |
+						ATA_HORKAGE_NOLPM, },
 	{ "VB0250EAVER",	"HPG7",		ATA_HORKAGE_BROKEN_FPDMA_AA },
 
 	/* Blacklist entries taken from Silicon Image 3124/3132
-- 
2.21.0

