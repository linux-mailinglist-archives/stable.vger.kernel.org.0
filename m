Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A173F371C2B
	for <lists+stable@lfdr.de>; Mon,  3 May 2021 18:51:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233499AbhECQvg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 May 2021 12:51:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:33096 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233923AbhECQtf (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 May 2021 12:49:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BD43D61883;
        Mon,  3 May 2021 16:40:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620060031;
        bh=lQFdE44tX/Z82/XVcLh++OVEn6ZepMmA1G9sUSQXwAI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kxgNSsklpdrR/RaTy/sjN99cBZK2b3naV4wNrTQMhHalsxHiG97aqKLAw7/yqvZHW
         IzumgWCEITGJ5GQDFDxwsLpJibzLx3+uz6VjcKLgWjEeIMm9v+q5ppaBNao3/741x0
         k0FIMIeL/7qhosLk8zpd2KrZ8ZunAIyg9TA6Isf6AGGpFkHy9WP9K3RoNPL8DVMzRD
         IJEsdrbPPffZvENJjnoVNNGLPPBPLTZHpjuLvpqWOndhP4d2XuBYqYHHOB8pNAgr4f
         ciM+zK/M2/DjnkYl20nFUmwEATjOYey1XXT6F/zxQz01pIi8HlVxnUXLZ1nj87HogY
         3J7MwT8Uej2VA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Ewan D. Milne" <emilne@redhat.com>,
        Hannes Reinecke <hare@suse.de>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 32/57] scsi: scsi_dh_alua: Remove check for ASC 24h in alua_rtpg()
Date:   Mon,  3 May 2021 12:39:16 -0400
Message-Id: <20210503163941.2853291-32-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210503163941.2853291-1-sashal@kernel.org>
References: <20210503163941.2853291-1-sashal@kernel.org>
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
index 308bda2e9c00..df5a3bbeba5e 100644
--- a/drivers/scsi/device_handler/scsi_dh_alua.c
+++ b/drivers/scsi/device_handler/scsi_dh_alua.c
@@ -565,10 +565,11 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_port_group *pg)
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

