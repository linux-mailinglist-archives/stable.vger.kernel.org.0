Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F03815C1A0
	for <lists+stable@lfdr.de>; Thu, 13 Feb 2020 16:25:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728862AbgBMPY4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Feb 2020 10:24:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:39440 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728858AbgBMPYz (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Feb 2020 10:24:55 -0500
Received: from localhost (unknown [104.132.1.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5447E246A4;
        Thu, 13 Feb 2020 15:24:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581607495;
        bh=XBzjrddAAyUu1vsIm5IwAqfqOvGPpOdXctWjSZOa7YI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Dtkk8ASgIGVzzoKwMH5mZyJdz6+ImB1bS+uKv9VG+/mJT8G+OdufufbpcxP9R/WvY
         Oq87bL7MNFqxkHgJFFeDfOqGvs5F/kNgnlLoQXtWxLE07+8PsXbugAkidpTiDrQSkF
         MFkUkXYIM2B4sVBxnr14zuHrCaVLYUIU7mS3TzXs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Quinn Tran <qutran@marvell.com>,
        Himanshu Madhani <hmadhani@marvell.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 4.14 047/173] scsi: qla2xxx: Fix mtcp dump collection failure
Date:   Thu, 13 Feb 2020 07:19:10 -0800
Message-Id: <20200213151945.853627319@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200213151931.677980430@linuxfoundation.org>
References: <20200213151931.677980430@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Quinn Tran <qutran@marvell.com>

commit 641e0efddcbde52461e017136acd3ce7f2ef0c14 upstream.

MTCP dump failed due to MB Reg 10 was picking garbage data from stack
memory.

Fixes: 81178772b636a ("[SCSI] qla2xxx: Implemetation of mctp.")
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20191217220617.28084-14-hmadhani@marvell.com
Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Himanshu Madhani <hmadhani@marvell.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/scsi/qla2xxx/qla_mbx.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -5853,9 +5853,8 @@ qla2x00_dump_mctp_data(scsi_qla_host_t *
 	mcp->mb[7] = LSW(MSD(req_dma));
 	mcp->mb[8] = MSW(addr);
 	/* Setting RAM ID to valid */
-	mcp->mb[10] |= BIT_7;
 	/* For MCTP RAM ID is 0x40 */
-	mcp->mb[10] |= 0x40;
+	mcp->mb[10] = BIT_7 | 0x40;
 
 	mcp->out_mb |= MBX_10|MBX_8|MBX_7|MBX_6|MBX_5|MBX_4|MBX_3|MBX_2|MBX_1|
 	    MBX_0;


