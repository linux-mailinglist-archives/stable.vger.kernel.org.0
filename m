Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 542C6371C9F
	for <lists+stable@lfdr.de>; Mon,  3 May 2021 18:56:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234340AbhECQxp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 May 2021 12:53:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:58932 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233199AbhECQvn (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 May 2021 12:51:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 94D4560230;
        Mon,  3 May 2021 16:41:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620060095;
        bh=/4GhULaCE9YdChzHJoUbC8Q199hYMk3FyX8bH+Blr5w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=m8mXZ5QuXL5Bq390kN323hjW2s4i29zaYKYa4KIagjQC8OB2hGtCVOmNYPuXhUz6P
         Ld4fAW/r84WW/cjoYndoIC8PUxSfvklqVa+DUMxU/N13XGNw84FrJPYGAr5+CHiqEt
         LHPwD8eTExC6FxyN7anL6x5CrmGZoDAg3+3XZVQdyoOCV4vaFr5dscGqpDGgqwvHXE
         uiy8yRlAv1Hn7OkGpILEAnSZ1sXvtRoFa/PqFv761jnjN07LHuU5kl4MjbMq6Qfa2c
         j5XSHJCqcvh5N2GkjSjZp7WjjFhr6UWDUgrByJlrmwEDYgC/qqTN8jRMJ19085uh+D
         3kIizZgGQDuUQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Ewan D. Milne" <emilne@redhat.com>,
        Hannes Reinecke <hare@suse.de>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 17/35] scsi: scsi_dh_alua: Remove check for ASC 24h in alua_rtpg()
Date:   Mon,  3 May 2021 12:40:51 -0400
Message-Id: <20210503164109.2853838-17-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210503164109.2853838-1-sashal@kernel.org>
References: <20210503164109.2853838-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Ewan D. Milne" <emilne@redhat.com>

[ Upstream commit bc3f2b42b70eb1b8576e753e7d0e117bbb674496 ]

Some arrays return ILLEGAL_REQUEST with ASC 00h if they don't support the
RTPG extended header so remove the check for INVALID FIELD IN CDB.

Link: https://lore.kernel.org/r/20210331201154.20348-1-emilne@redhat.com
Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Ewan D. Milne <emilne@redhat.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/device_handler/scsi_dh_alua.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
index 60c48dc5d945..efd2b4312528 100644
--- a/drivers/scsi/device_handler/scsi_dh_alua.c
+++ b/drivers/scsi/device_handler/scsi_dh_alua.c
@@ -579,10 +579,11 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_port_group *pg)
 		 * even though it shouldn't according to T10.
 		 * The retry without rtpg_ext_hdr_req set
 		 * handles this.
+		 * Note:  some arrays return a sense key of ILLEGAL_REQUEST
+		 * with ASC 00h if they don't support the extended header.
 		 */
 		if (!(pg->flags & ALUA_RTPG_EXT_HDR_UNSUPP) &&
-		    sense_hdr.sense_key == ILLEGAL_REQUEST &&
-		    sense_hdr.asc == 0x24 && sense_hdr.ascq == 0) {
+		    sense_hdr.sense_key == ILLEGAL_REQUEST) {
 			pg->flags |= ALUA_RTPG_EXT_HDR_UNSUPP;
 			goto retry;
 		}
-- 
2.30.2

