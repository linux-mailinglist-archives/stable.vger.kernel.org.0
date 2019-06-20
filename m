Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1865A4D5CD
	for <lists+stable@lfdr.de>; Thu, 20 Jun 2019 20:01:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726245AbfFTSBJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Jun 2019 14:01:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:50446 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727161AbfFTSBI (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Jun 2019 14:01:08 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6F9F82089C;
        Thu, 20 Jun 2019 18:01:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561053667;
        bh=8EyeSjUpQh19iCE24F3U8olC8MptdrzOxFATJHzEoSY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AwiEU7p0Y4TdxUOXamE/WiZGJlYIGSZeKxuT+C3s3e60VvIJm6gzD7UqBrG4KAzxk
         b78/HVDq1GsSsKj+jgy2CXGIyyIB9h5avF9MgnLQkC/KPhnV0wB1EEOUxLRw2MvmPB
         PMWgVRPqN8shT8ySk9mxOAcYcN3jP60aw/yi1vMk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 4.4 41/84] libata: Extend quirks for the ST1000LM024 drives with NOLPM quirk
Date:   Thu, 20 Jun 2019 19:56:38 +0200
Message-Id: <20190620174344.378289560@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190620174337.538228162@linuxfoundation.org>
References: <20190620174337.538228162@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

commit 31f6264e225fb92cf6f4b63031424f20797c297d upstream.

We've received a bugreport that using LPM with ST1000LM024 drives leads
to system lockups. So it seems that these models are buggy in more then
1 way. Add NOLPM quirk to the existing quirks entry for BROKEN_FPDMA_AA.

BugLink: https://bugzilla.redhat.com/show_bug.cgi?id=1571330
Cc: stable@vger.kernel.org
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/ata/libata-core.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -4176,9 +4176,12 @@ static const struct ata_blacklist_entry
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


