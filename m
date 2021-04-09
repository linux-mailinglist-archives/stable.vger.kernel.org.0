Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 516FF359ABD
	for <lists+stable@lfdr.de>; Fri,  9 Apr 2021 12:02:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233054AbhDIKCW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Apr 2021 06:02:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:44346 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234015AbhDIKAF (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Apr 2021 06:00:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 751AE6121E;
        Fri,  9 Apr 2021 09:59:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617962350;
        bh=ZMIgxUyuyvzRy1ap1beSK8+1Wjeu7ewBPuop87BzI5w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=L3Ay2HV+hJiAPe4urk5sJm38CnLFQskB1RzBNC/QxCemLwQXHlSPQ51G4x6FgzcI0
         Uunsf8aAN9DjWbzRhMJOZWl1aFb6BWFEFgfqeXsBvQxWZaB56x1OEfBwrMkL0LtRSY
         BPu83WmbU1stuiMrSx6aRta+dGZNtBmyz4F0CLkg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Lee Duncan <lduncan@suse.com>, Martin Wilck <mwilck@suse.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 24/41] scsi: target: pscsi: Clean up after failure in pscsi_map_sg()
Date:   Fri,  9 Apr 2021 11:53:46 +0200
Message-Id: <20210409095305.601311444@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210409095304.818847860@linuxfoundation.org>
References: <20210409095304.818847860@linuxfoundation.org>
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
index 4e37fa9b409d..723a51a3f431 100644
--- a/drivers/target/target_core_pscsi.c
+++ b/drivers/target/target_core_pscsi.c
@@ -939,6 +939,14 @@ pscsi_map_sg(struct se_cmd *cmd, struct scatterlist *sgl, u32 sgl_nents,
 
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



