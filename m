Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5660371D1A
	for <lists+stable@lfdr.de>; Mon,  3 May 2021 18:57:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234577AbhECQ6C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 May 2021 12:58:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:44506 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235178AbhECQzy (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 May 2021 12:55:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E371961970;
        Mon,  3 May 2021 16:43:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620060188;
        bh=YlKpnJAbLfOMsqHv5PumUIlf9SETs2XxlTwg9eWUif0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AjyIKam+pyrXcPWpq20iyP+e0yKXVMpTk5w4MmyW0osGBNvHqjxGK83ujzd3oLS7V
         0QXqplNbygqnphJ4qKo7gYq02rJUiPu7k3B7dA64LPF9d7kDVHle4oTjDAe97zINe1
         5UDxCXS5Mhl/P9uTfxPvUpc4E96fvR+iFt9Xpdgg2HAcPzSk1FgVc6UVl0xKXNwSmZ
         UMNC6xrDOlvyqaUbiBx0hQU1Pt8cE008hTPnKNteyJQ8wuH9U/iOIdSlofP4C0RQBN
         ZnESQDL4D+kEMZa4HV9IuxfzXv+qacNZealjSoTA299T8mL/9ETwzuiNADz3Mb4YIG
         n06RVGIhdCHtw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Ewan D. Milne" <emilne@redhat.com>,
        Hannes Reinecke <hare@suse.de>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 11/24] scsi: scsi_dh_alua: Remove check for ASC 24h in alua_rtpg()
Date:   Mon,  3 May 2021 12:42:39 -0400
Message-Id: <20210503164252.2854487-11-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210503164252.2854487-1-sashal@kernel.org>
References: <20210503164252.2854487-1-sashal@kernel.org>
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
index 2bc3dc6244a5..dce885276235 100644
--- a/drivers/scsi/device_handler/scsi_dh_alua.c
+++ b/drivers/scsi/device_handler/scsi_dh_alua.c
@@ -564,10 +564,11 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_port_group *pg)
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

