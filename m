Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8AE7F37C570
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 17:40:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235631AbhELPkL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 11:40:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:54422 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235063AbhELPfP (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:35:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A236561995;
        Wed, 12 May 2021 15:17:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620832666;
        bh=mYhmyNGue0YNL3Jph8tkYFHnO4GoSpZVEKE1p7sTGWk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lWrN3cjBoQ5GTUAYuWyE1je23xele3B9OAD5nbwMIQsFecF7+5xNgHSiecrgc8o/W
         Cu2hClTFjlZ9GyUs8zNv4FsQLUspjQpExLuK56fHcYQt+/RFPpV+Usy1m4LF3uJsu3
         nWXWUGw8MgDZ0DRabtAcUnj6UyrhGtNQ2vsoR5VE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Vishakha Channapattan <vishakhavc@google.com>,
        Jack Wang <jinpu.wang@ionos.com>,
        Igor Pylypiv <ipylypiv@google.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 328/530] scsi: pm80xx: Increase timeout for pm80xx mpi_uninit_check()
Date:   Wed, 12 May 2021 16:47:18 +0200
Message-Id: <20210512144830.586304527@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144819.664462530@linuxfoundation.org>
References: <20210512144819.664462530@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Igor Pylypiv <ipylypiv@google.com>

[ Upstream commit 3f744a14f331f56703a9d74e86520db045f11831 ]

The mpi_uninit_check() takes longer for inbound doorbell register to be
cleared. Increase the timeout substantially so that the driver does not
fail to load.

Previously, the inbound doorbell wait time was mistakenly increased in the
mpi_init_check() instead of mpi_uninit_check(). It is okay to leave the
mpi_init_check() wait time as-is as these are timeout values and if there
is a failure, waiting longer is not an issue.

Link: https://lore.kernel.org/r/20210406180534.1924345-2-ipylypiv@google.com
Fixes: e90e236250e9 ("scsi: pm80xx: Increase timeout for pm80xx mpi_uninit_check")
Reviewed-by: Vishakha Channapattan <vishakhavc@google.com>
Acked-by: Jack Wang <jinpu.wang@ionos.com>
Signed-off-by: Igor Pylypiv <ipylypiv@google.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/pm8001/pm80xx_hwi.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80xx_hwi.c
index 055f7649676e..27b354860a16 100644
--- a/drivers/scsi/pm8001/pm80xx_hwi.c
+++ b/drivers/scsi/pm8001/pm80xx_hwi.c
@@ -1488,9 +1488,9 @@ static int mpi_uninit_check(struct pm8001_hba_info *pm8001_ha)
 
 	/* wait until Inbound DoorBell Clear Register toggled */
 	if (IS_SPCV_12G(pm8001_ha->pdev)) {
-		max_wait_count = 4 * 1000 * 1000;/* 4 sec */
+		max_wait_count = 30 * 1000 * 1000; /* 30 sec */
 	} else {
-		max_wait_count = 2 * 1000 * 1000;/* 2 sec */
+		max_wait_count = 15 * 1000 * 1000; /* 15 sec */
 	}
 	do {
 		udelay(1);
-- 
2.30.2



