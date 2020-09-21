Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8949D272F8D
	for <lists+stable@lfdr.de>; Mon, 21 Sep 2020 18:58:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730221AbgIUQ5w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Sep 2020 12:57:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:46866 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729274AbgIUQmj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Sep 2020 12:42:39 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2661523A34;
        Mon, 21 Sep 2020 16:42:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600706558;
        bh=KyBewu4rqNQvL0E8Ij9C6evBSZUlxIIxfZdxMbppqz8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zy/a0qHVC6aNH1qlHxByacf6ETBREfFmKlU8oWKa7CjUSO4pPhB9pG5jZdyDRmxAb
         A6k2tQYKtaY+PQq9xYjo5ZO3+9BTRds7OYRKbZpuNL3S6GTZ9Lm2rDdn2o3N3/pd8K
         h0sMLkh4Rz5mmT0VRTuZoq2pmF5imOQ46BUUFfjg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Javed Hasan <jhasan@marvell.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 11/49] scsi: libfc: Fix for double free()
Date:   Mon, 21 Sep 2020 18:27:55 +0200
Message-Id: <20200921162035.181075189@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200921162034.660953761@linuxfoundation.org>
References: <20200921162034.660953761@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
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
index 78cf5b32bca67..0b3f4538c1d4d 100644
--- a/drivers/scsi/libfc/fc_disc.c
+++ b/drivers/scsi/libfc/fc_disc.c
@@ -646,8 +646,6 @@ free_fp:
 	fc_frame_free(fp);
 out:
 	kref_put(&rdata->kref, fc_rport_destroy);
-	if (!IS_ERR(fp))
-		fc_frame_free(fp);
 }
 
 /**
-- 
2.25.1



