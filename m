Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D7C6493F0
	for <lists+stable@lfdr.de>; Mon, 17 Jun 2019 23:34:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729875AbfFQVYT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jun 2019 17:24:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:49820 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729885AbfFQVYT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Jun 2019 17:24:19 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 06B712063F;
        Mon, 17 Jun 2019 21:24:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560806658;
        bh=7Zh1OOww7Q92VDGSJE6zUFD1zJtvz2cSNRgLKcbty7Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uKvVhuPDlhPoZYSNp+JUr7Pw7JMqkzZ6T+x4XxvVDQcu6maBxHwnbkKvFwa3AlVP+
         pGM0s4sYqKWvVpHQPT6duu+Df1DbeWgDJMBAqb8h22MH/+/w8UEaZgNJ4D/V2ZWEUH
         1/Gx8isvKTNmAqa+dVgFY2Tgl2QFRYd+/fsUFQHI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 4.19 13/75] libata: Extend quirks for the ST1000LM024 drives with NOLPM quirk
Date:   Mon, 17 Jun 2019 23:09:24 +0200
Message-Id: <20190617210753.390377987@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190617210752.799453599@linuxfoundation.org>
References: <20190617210752.799453599@linuxfoundation.org>
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
@@ -4476,9 +4476,12 @@ static const struct ata_blacklist_entry
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


