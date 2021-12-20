Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B02447AC8B
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 15:45:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235751AbhLTOpk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 09:45:40 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:36618 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233010AbhLTOnH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 09:43:07 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5C7F861165;
        Mon, 20 Dec 2021 14:43:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44D0DC36AE8;
        Mon, 20 Dec 2021 14:43:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640011386;
        bh=Xy1wf4sQNBvT+lQFKcsRYvPTdpZa9xSe1DG/PMBNC14=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bJCxn+rxb4Te7wccKMzmipA7eiByA5KcXitMDjN8KPAilj98ziV2DCQGf00XKQOOK
         8kVRe6ORtgFvjpT/m1g5jXKysvgGb5GSf1J1o5Zoal8mmjHq09xSEVPXGFhNbMGKu2
         MFwi2imbDUF821C0LoMbxN2j6/OIjjkJnyAqiUic=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, syzkaller <syzkaller@googlegroups.com>,
        George Kennedy <george.kennedy@oracle.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>
Subject: [PATCH 4.19 37/56] libata: if T_LENGTH is zero, dma direction should be DMA_NONE
Date:   Mon, 20 Dec 2021 15:34:30 +0100
Message-Id: <20211220143024.664992623@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211220143023.451982183@linuxfoundation.org>
References: <20211220143023.451982183@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: George Kennedy <george.kennedy@oracle.com>

commit 5da5231bb47864e5dd6c6731151e98b6ee498827 upstream.

Avoid data corruption by rejecting pass-through commands where
T_LENGTH is zero (No data is transferred) and the dma direction
is not DMA_NONE.

Cc: <stable@vger.kernel.org>
Reported-by: syzkaller<syzkaller@googlegroups.com>
Signed-off-by: George Kennedy<george.kennedy@oracle.com>
Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/ata/libata-scsi.c |   15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -3181,8 +3181,19 @@ static unsigned int ata_scsi_pass_thru(s
 		goto invalid_fld;
 	}
 
-	if (ata_is_ncq(tf->protocol) && (cdb[2 + cdb_offset] & 0x3) == 0)
-		tf->protocol = ATA_PROT_NCQ_NODATA;
+	if ((cdb[2 + cdb_offset] & 0x3) == 0) {
+		/*
+		 * When T_LENGTH is zero (No data is transferred), dir should
+		 * be DMA_NONE.
+		 */
+		if (scmd->sc_data_direction != DMA_NONE) {
+			fp = 2 + cdb_offset;
+			goto invalid_fld;
+		}
+
+		if (ata_is_ncq(tf->protocol))
+			tf->protocol = ATA_PROT_NCQ_NODATA;
+	}
 
 	/* enable LBA */
 	tf->flags |= ATA_TFLAG_LBA;


