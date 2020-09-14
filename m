Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96FB7269267
	for <lists+stable@lfdr.de>; Mon, 14 Sep 2020 19:03:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725994AbgINPJC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Sep 2020 11:09:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:32952 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726621AbgINNF3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Sep 2020 09:05:29 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8492C2222D;
        Mon, 14 Sep 2020 13:04:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600088679;
        bh=nj04gQ2nO4VIAL2d7c7u/+7BBIF7UPrKHeahbNgg3hw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xr0uzeSO/sqmMkePVP09eccWv23Pqd6XLdVonwSLreL7Y5TmA5CYkgzBs1ZiA87jw
         b4ltAssWZZ/pCcDt59VReBWoNuFwBEu0amwSkSTiaiVK2HnRpKuq7f6P5KFTT/vIa5
         QUapyeG6/I6NDVQvNZfkbsSjT7laaf8JjuG9VAJc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Javed Hasan <jhasan@marvell.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 03/22] scsi: libfc: Fix for double free()
Date:   Mon, 14 Sep 2020 09:04:15 -0400
Message-Id: <20200914130434.1804478-3-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200914130434.1804478-1-sashal@kernel.org>
References: <20200914130434.1804478-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Javed Hasan <jhasan@marvell.com>

[ Upstream commit 5a5b80f98534416b3b253859897e2ba1dc241e70 ]

Fix for '&fp->skb' double free.

Link:
https://lore.kernel.org/r/20200825093940.19612-1-jhasan@marvell.com
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Javed Hasan <jhasan@marvell.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/libfc/fc_disc.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/scsi/libfc/fc_disc.c b/drivers/scsi/libfc/fc_disc.c
index e00dc4693fcbd..589ddf003886e 100644
--- a/drivers/scsi/libfc/fc_disc.c
+++ b/drivers/scsi/libfc/fc_disc.c
@@ -634,8 +634,6 @@ static void fc_disc_gpn_id_resp(struct fc_seq *sp, struct fc_frame *fp,
 	fc_frame_free(fp);
 out:
 	kref_put(&rdata->kref, fc_rport_destroy);
-	if (!IS_ERR(fp))
-		fc_frame_free(fp);
 }
 
 /**
-- 
2.25.1

