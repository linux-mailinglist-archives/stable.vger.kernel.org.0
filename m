Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54CEB2475B7
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 21:27:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732148AbgHQT1T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 15:27:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:35296 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730368AbgHQPdS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 11:33:18 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4BAF622DD3;
        Mon, 17 Aug 2020 15:33:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597678397;
        bh=DTe92InpxRqfPQxpIm07sLBWL8mODR2YUc+SJgOrp04=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dPZP+z0tvwKrDgFsIYTJf0YQck7UZBtKmY5pR/6ikdr2bRJ2lwmxkfWqvWvcKEGEz
         C5krUxLdx3mGexYEuFlkdfVPn9/Kikz7Nz270b29fdH2caUz+i53+gNzdIg2oPtcFO
         2QAN+smhDUiKWFicmWskoldlfQqS5uXOuoU0qQps=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ye Bin <yebin10@huawei.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 290/464] scsi: core: Add missing scsi_device_put() in scsi_host_block()
Date:   Mon, 17 Aug 2020 17:14:03 +0200
Message-Id: <20200817143847.645336277@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143833.737102804@linuxfoundation.org>
References: <20200817143833.737102804@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ye Bin <yebin10@huawei.com>

[ Upstream commit f30785db7546520acd53aac7497d42352ff031e0 ]

The scsi_host_block() case was missing in commit 4dea170f4fb2 ("scsi: core:
Fix incorrect usage of shost_for_each_device").

Link: https://lore.kernel.org/r/20200717090921.29243-1-yebin10@huawei.com
Fixes: 2bb955840c1d ("scsi: core: add scsi_host_(block,unblock) helper function")
Fixes: 4dea170f4fb2 ("scsi: core: Fix incorrect usage of shost_for_each_device")
Signed-off-by: Ye Bin <yebin10@huawei.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/scsi_lib.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 06056e9ec3335..ae620dada8ce5 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -2841,8 +2841,10 @@ scsi_host_block(struct Scsi_Host *shost)
 		mutex_lock(&sdev->state_mutex);
 		ret = scsi_internal_device_block_nowait(sdev);
 		mutex_unlock(&sdev->state_mutex);
-		if (ret)
+		if (ret) {
+			scsi_device_put(sdev);
 			break;
+		}
 	}
 
 	/*
-- 
2.25.1



