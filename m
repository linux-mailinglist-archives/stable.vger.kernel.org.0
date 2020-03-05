Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8D82417AC19
	for <lists+stable@lfdr.de>; Thu,  5 Mar 2020 18:19:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726981AbgCERSd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Mar 2020 12:18:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:42314 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728095AbgCERPb (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 5 Mar 2020 12:15:31 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C11B52166E;
        Thu,  5 Mar 2020 17:15:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583428530;
        bh=GcU1V1irnlHb0FoLOQTl4tLyKbgG4+amY4C1QXTp9nE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZO/1/ESi0jULp2l0HM7GWuwVYuLXMVY7bTD0PdEmFCx3moInkw6xN2jJhE2x16uGB
         UZVjw/kM/d9BoGBWYYxZpkP1Ms0VaoOmIvGCjKDmW8OL8jzN32x2QfGfXopdQJZZr0
         VwAa2ANzBB95E2Zw6dy5DtUnqTW5lLmYxlfNCuiY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Igor Druzhinin <igor.druzhinin@citrix.com>,
        Hannes Reinecke <hare@suse.de>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 11/31] scsi: libfc: free response frame from GPN_ID
Date:   Thu,  5 Mar 2020 12:14:55 -0500
Message-Id: <20200305171516.30028-11-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200305171516.30028-1-sashal@kernel.org>
References: <20200305171516.30028-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Igor Druzhinin <igor.druzhinin@citrix.com>

[ Upstream commit ff6993bb79b9f99bdac0b5378169052931b65432 ]

fc_disc_gpn_id_resp() should be the last function using it so free it here
to avoid memory leak.

Link: https://lore.kernel.org/r/1579013000-14570-2-git-send-email-igor.druzhinin@citrix.com
Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Igor Druzhinin <igor.druzhinin@citrix.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/libfc/fc_disc.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/libfc/fc_disc.c b/drivers/scsi/libfc/fc_disc.c
index f969a71348ef1..8839f509b19ab 100644
--- a/drivers/scsi/libfc/fc_disc.c
+++ b/drivers/scsi/libfc/fc_disc.c
@@ -640,6 +640,8 @@ static void fc_disc_gpn_id_resp(struct fc_seq *sp, struct fc_frame *fp,
 	}
 out:
 	kref_put(&rdata->kref, fc_rport_destroy);
+	if (!IS_ERR(fp))
+		fc_frame_free(fp);
 }
 
 /**
-- 
2.20.1

