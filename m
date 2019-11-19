Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C16241018FF
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 07:12:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727104AbfKSFXW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 00:23:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:38980 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727963AbfKSFXW (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 00:23:22 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AF7F62231A;
        Tue, 19 Nov 2019 05:23:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574141001;
        bh=sKIeWLn1mX4A/aVFN2Vpovh/sCUJHX5zLURb9S6+bdk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jf46VhDUzVOQEN91L0FoUFkagEH4xMGxTMBrZpjIW3ivoqbrXXfr9b76f55hMJyuo
         iDtX6RFj4YM3YCcu0zE6SAaWxis8UbL+ATsgdsaKI8mnh+EIxQiiQ49orB1QVpXF8f
         I93CBkqDmXshhkmeFjLf8DV3f+7CCEZLjNYYJn9k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Finn Thain <fthain@telegraphics.com.au>,
        Michael Schmitz <schmitzmic@gmail.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 4.19 003/422] scsi: core: Handle drivers which set sg_tablesize to zero
Date:   Tue, 19 Nov 2019 06:13:20 +0100
Message-Id: <20191119051400.455734877@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191119051400.261610025@linuxfoundation.org>
References: <20191119051400.261610025@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Schmitz <schmitzmic@gmail.com>

commit 9393c8de628cf0968d81a17cc11841e42191e041 upstream.

In scsi_mq_setup_tags(), cmd_size is calculated based on zero size for the
scatter-gather list in case the low level driver uses SG_NONE in its host
template.

cmd_size is passed on to the block layer for calculation of the request
size, and we've seen NULL pointer dereference errors from the block layer
in drivers where SG_NONE is used and a mq IO scheduler is active,
apparently as a consequence of this (see commit 68ab2d76e4be ("scsi:
cxlflash: Set sg_tablesize to 1 instead of SG_NONE"), and a recent patch by
Finn Thain converting the three m68k NFR5380 drivers to avoid setting
SG_NONE).

Try to avoid these errors by accounting for at least one sg list entry when
calculating cmd_size, regardless of whether the low level driver set a zero
sg_tablesize.

Tested on 030 m68k with the atari_scsi driver - setting sg_tablesize to
SG_NONE no longer results in a crash when loading this driver.

CC: Finn Thain <fthain@telegraphics.com.au>
Link: https://lore.kernel.org/r/1572922150-4358-1-git-send-email-schmitzmic@gmail.com
Signed-off-by: Michael Schmitz <schmitzmic@gmail.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>


---
 drivers/scsi/scsi_lib.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -2371,7 +2371,8 @@ int scsi_mq_setup_tags(struct Scsi_Host
 {
 	unsigned int cmd_size, sgl_size;
 
-	sgl_size = scsi_mq_sgl_size(shost);
+	sgl_size = max_t(unsigned int, sizeof(struct scatterlist),
+			scsi_mq_sgl_size(shost));
 	cmd_size = sizeof(struct scsi_cmnd) + shost->hostt->cmd_size + sgl_size;
 	if (scsi_host_get_prot(shost))
 		cmd_size += sizeof(struct scsi_data_buffer) + sgl_size;


