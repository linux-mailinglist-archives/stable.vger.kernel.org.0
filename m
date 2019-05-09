Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9F29E19225
	for <lists+stable@lfdr.de>; Thu,  9 May 2019 21:05:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728036AbfEISsh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 May 2019 14:48:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:41564 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728054AbfEISsh (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 May 2019 14:48:37 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 47E9B217D7;
        Thu,  9 May 2019 18:48:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557427716;
        bh=scQnLSil0ImaITJO60dTpxacwCQbUf+OJuPDTSNB3n4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F/Zub/svBLIJuzNH8bW276utS1VGp8N8hbc9bFEOjCWdm6E407pGbDu3mqrmSNGAH
         byjRIn8FgmMrgv7ut2Dxscdz8OWVBWtep8VJmaWhmNQ/6Gx8D77wZme0PmPU1WmaQO
         uLaa1NrzSynaEOIZ0OIfc723goEIob2Sew0+bIis=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Varun Prakash <varun@chelsio.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 42/66] scsi: csiostor: fix missing data copy in csio_scsi_err_handler()
Date:   Thu,  9 May 2019 20:42:17 +0200
Message-Id: <20190509181306.349125189@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190509181301.719249738@linuxfoundation.org>
References: <20190509181301.719249738@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 5c2442fd78998af60e13aba506d103f7f43f8701 ]

If scsi cmd sglist is not suitable for DDP then csiostor driver uses
preallocated buffers for DDP, because of this data copy is required from
DDP buffer to scsi cmd sglist before calling ->scsi_done().

Signed-off-by: Varun Prakash <varun@chelsio.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/csiostor/csio_scsi.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/csiostor/csio_scsi.c b/drivers/scsi/csiostor/csio_scsi.c
index dab0d3f9bee13..e09c7f360dbde 100644
--- a/drivers/scsi/csiostor/csio_scsi.c
+++ b/drivers/scsi/csiostor/csio_scsi.c
@@ -1713,8 +1713,11 @@ csio_scsi_err_handler(struct csio_hw *hw, struct csio_ioreq *req)
 	}
 
 out:
-	if (req->nsge > 0)
+	if (req->nsge > 0) {
 		scsi_dma_unmap(cmnd);
+		if (req->dcopy && (host_status == DID_OK))
+			host_status = csio_scsi_copy_to_sgl(hw, req);
+	}
 
 	cmnd->result = (((host_status) << 16) | scsi_status);
 	cmnd->scsi_done(cmnd);
-- 
2.20.1



