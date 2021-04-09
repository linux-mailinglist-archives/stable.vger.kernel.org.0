Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45B07359A24
	for <lists+stable@lfdr.de>; Fri,  9 Apr 2021 11:56:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233635AbhDIJ4W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Apr 2021 05:56:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:43822 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232042AbhDIJzy (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Apr 2021 05:55:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5BD8A61178;
        Fri,  9 Apr 2021 09:55:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617962141;
        bh=0u5+UMhNptSANNdmaVdBdoEgQtPb4PuhNmHsrUAniS4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kx4gdP03QB3hR1ojOojrTDHiWlQdbzo9MPB4y/mD8LboBSOXfIdWvcmmYwIrfoTyD
         N4ca5vw9oDWEDruliDhPB2c2YPJ58BjTDcRMrHZKI/XBiMpl+hyBL18h0/RcSMnSwC
         l+QHTs16WzW02bB0+Y+kHnuUJXzi1hmPkIUIdLsY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Lee Duncan <lduncan@suse.com>, Martin Wilck <mwilck@suse.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 06/13] scsi: target: pscsi: Clean up after failure in pscsi_map_sg()
Date:   Fri,  9 Apr 2021 11:53:26 +0200
Message-Id: <20210409095259.830909833@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210409095259.624577828@linuxfoundation.org>
References: <20210409095259.624577828@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Martin Wilck <mwilck@suse.com>

[ Upstream commit 36fa766faa0c822c860e636fe82b1affcd022974 ]

If pscsi_map_sg() fails, make sure to drop references to already allocated
bios.

Link: https://lore.kernel.org/r/20210323212431.15306-2-mwilck@suse.com
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Lee Duncan <lduncan@suse.com>
Signed-off-by: Martin Wilck <mwilck@suse.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/target/target_core_pscsi.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/target/target_core_pscsi.c b/drivers/target/target_core_pscsi.c
index ef1c8c158f66..079db0bd3917 100644
--- a/drivers/target/target_core_pscsi.c
+++ b/drivers/target/target_core_pscsi.c
@@ -951,6 +951,14 @@ pscsi_map_sg(struct se_cmd *cmd, struct scatterlist *sgl, u32 sgl_nents,
 
 	return 0;
 fail:
+	if (bio)
+		bio_put(bio);
+	while (req->bio) {
+		bio = req->bio;
+		req->bio = bio->bi_next;
+		bio_put(bio);
+	}
+	req->biotail = NULL;
 	return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
 }
 
-- 
2.30.2



