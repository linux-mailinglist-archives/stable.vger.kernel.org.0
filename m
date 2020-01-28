Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 689C314B954
	for <lists+stable@lfdr.de>; Tue, 28 Jan 2020 15:33:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728066AbgA1OaZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jan 2020 09:30:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:57528 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728028AbgA1O3K (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Jan 2020 09:29:10 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ABDF224692;
        Tue, 28 Jan 2020 14:29:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580221750;
        bh=Rz4cxySQyiJR1dS4W5KqaCzgtzfhUbD97rFXyY6jhhg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hSQFx7NhGTBETYNCy8sEq9Yo5dRiadDQlm8i4Th/zb99EZUS2qsUd1iGkoL2XACRs
         r/SVkYpduXLrEbYyNG/d3sgCqpzHtlhs9tM8tZZ4j6xqMKycINNiOiVgWG/9yj96YE
         rx1vUQu9KTPEc/BHfRzyUeaqegVeKFTvfLSLqgSA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Damien Le Moal <damien.lemoal@wdc.com>,
        Masato Suzuki <masato.suzuki@wdc.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 4.19 59/92] sd: Fix REQ_OP_ZONE_REPORT completion handling
Date:   Tue, 28 Jan 2020 15:08:27 +0100
Message-Id: <20200128135816.802992447@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200128135809.344954797@linuxfoundation.org>
References: <20200128135809.344954797@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masato Suzuki <masato.suzuki@wdc.com>


ZBC/ZAC report zones command may return less bytes than requested if the
number of matching zones for the report request is small. However, unlike
read or write commands, the remainder of incomplete report zones commands
cannot be automatically requested by the block layer: the start sector of
the next report cannot be known, and the report reply may not be 512B
aligned for SAS drives (a report zone reply size is always a multiple of
64B). The regular request completion code executing bio_advance() and
restart of the command remainder part currently causes invalid zone
descriptor data to be reported to the caller if the report zone size is
smaller than 512B (a case that can happen easily for a report of the last
zones of a SAS drive for example).

Since blkdev_report_zones() handles report zone command processing in a
loop until completion (no more zones are being reported), we can safely
avoid that the block layer performs an incorrect bio_advance() call and
restart of the remainder of incomplete report zone BIOs. To do so, always
indicate a full completion of REQ_OP_ZONE_REPORT by setting good_bytes to
the request buffer size and by setting the command resid to 0. This does
not affect the post processing of the report zone reply done by
sd_zbc_complete() since the reply header indicates the number of zones
reported.

Fixes: 89d947561077 ("sd: Implement support for ZBC devices")
Cc: <stable@vger.kernel.org> # 4.19
Cc: <stable@vger.kernel.org> # 4.14
Signed-off-by: Masato Suzuki <masato.suzuki@wdc.com>
Reviewed-by: Damien Le Moal <damien.lemoal@wdc.com>
Acked-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/scsi/sd.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1969,9 +1969,13 @@ static int sd_done(struct scsi_cmnd *SCp
 		}
 		break;
 	case REQ_OP_ZONE_REPORT:
+		/* To avoid that the block layer performs an incorrect
+		 * bio_advance() call and restart of the remainder of
+		 * incomplete report zone BIOs, always indicate a full
+		 * completion of REQ_OP_ZONE_REPORT.
+		 */
 		if (!result) {
-			good_bytes = scsi_bufflen(SCpnt)
-				- scsi_get_resid(SCpnt);
+			good_bytes = scsi_bufflen(SCpnt);
 			scsi_set_resid(SCpnt, 0);
 		} else {
 			good_bytes = 0;


