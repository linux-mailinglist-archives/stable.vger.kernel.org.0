Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF593378293
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 12:35:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231300AbhEJKgR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 06:36:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:41940 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232098AbhEJKcq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 06:32:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 16F2D616EC;
        Mon, 10 May 2021 10:27:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620642448;
        bh=XO+B8z6GztA2pPJlVufK5druNW5Q9Lf6Yy5u/W6beqE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xLbfyyn6e4kA72NWzQbifLYeGhXNeepRUpmUrRfbFEOt5fFDwHUiUR4e/xM3HWgPp
         joAKnfYbbfsX/hDZMk6mATtbmmK31gqfrEEYTBYPoLL1t7PYKKrn3K0rFzpUAX/PNS
         G4/DZPdwD+vTWA5zNJCpNUMXSR4R4unokrd3G8Ak=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        "Ewan D. Milne" <emilne@redhat.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 099/184] scsi: scsi_dh_alua: Remove check for ASC 24h in alua_rtpg()
Date:   Mon, 10 May 2021 12:19:53 +0200
Message-Id: <20210510101953.439988696@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510101950.200777181@linuxfoundation.org>
References: <20210510101950.200777181@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ewan D. Milne <emilne@redhat.com>

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



