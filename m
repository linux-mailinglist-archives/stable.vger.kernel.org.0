Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E497440DF23
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 18:06:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233070AbhIPQHF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 12:07:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:45880 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232046AbhIPQGe (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 12:06:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 96BBB6124B;
        Thu, 16 Sep 2021 16:05:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631808314;
        bh=ag+uAeWKPVFNvafpIGu/c0r020QZZsSQcstWyrND3a0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kMjRJYoX3x1upYWDVcGgDJYkhnfscFHikN72FiM2P4gc1VADMgwTVfHoXY/heBw2R
         +3Sza1LS2+FrsOwPnyF4BfRJiYgGdaUpNDVSk6xmQQJ1ONBzJXQgGanjWNIIjcrjsu
         vUBrXLhDTW1Us4WyxGzRqGk0krkWpi7UPr3eTJwc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kate Hsuan <hpa@redhat.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.10 043/306] libata: add ATA_HORKAGE_NO_NCQ_TRIM for Samsung 860 and 870 SSDs
Date:   Thu, 16 Sep 2021 17:56:28 +0200
Message-Id: <20210916155755.412749543@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155753.903069397@linuxfoundation.org>
References: <20210916155753.903069397@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

commit 8a6430ab9c9c87cb64c512e505e8690bbaee190b upstream.

Commit ca6bfcb2f6d9 ("libata: Enable queued TRIM for Samsung SSD 860")
limited the existing ATA_HORKAGE_NO_NCQ_TRIM quirk from "Samsung SSD 8*",
covering all Samsung 800 series SSDs, to only apply to "Samsung SSD 840*"
and "Samsung SSD 850*" series based on information from Samsung.

But there is a large number of users which is still reporting issues
with the Samsung 860 and 870 SSDs combined with Intel, ASmedia or
Marvell SATA controllers and all reporters also report these problems
going away when disabling queued trims.

Note that with AMD SATA controllers users are reporting even worse
issues and only completely disabling NCQ helps there, this will be
addressed in a separate patch.

Fixes: ca6bfcb2f6d9 ("libata: Enable queued TRIM for Samsung SSD 860")
BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=203475
Cc: stable@vger.kernel.org
Cc: Kate Hsuan <hpa@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Reviewed-by: Damien Le Moal <damien.lemoal@wdc.com>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
Link: https://lore.kernel.org/r/20210823095220.30157-1-hdegoede@redhat.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/ata/libata-core.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -3950,6 +3950,10 @@ static const struct ata_blacklist_entry
 						ATA_HORKAGE_ZERO_AFTER_TRIM, },
 	{ "Samsung SSD 850*",		NULL,	ATA_HORKAGE_NO_NCQ_TRIM |
 						ATA_HORKAGE_ZERO_AFTER_TRIM, },
+	{ "Samsung SSD 860*",		NULL,	ATA_HORKAGE_NO_NCQ_TRIM |
+						ATA_HORKAGE_ZERO_AFTER_TRIM, },
+	{ "Samsung SSD 870*",		NULL,	ATA_HORKAGE_NO_NCQ_TRIM |
+						ATA_HORKAGE_ZERO_AFTER_TRIM, },
 	{ "FCCT*M500*",			NULL,	ATA_HORKAGE_NO_NCQ_TRIM |
 						ATA_HORKAGE_ZERO_AFTER_TRIM, },
 


