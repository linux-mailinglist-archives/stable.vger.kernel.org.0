Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 467BAF5714
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 21:05:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387835AbfKHTRR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 14:17:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:58734 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390163AbfKHTBX (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 14:01:23 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B4FF721D7F;
        Fri,  8 Nov 2019 19:01:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573239682;
        bh=3zR5LJ09aUw6Xp7NTfJ2jsB8JLyk4o3y5+Lz4rXqc+k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mQWbDgAa7czG2wha/yXZ/CKjjBhEiJe0yYtUO4ZgXNQybT8+3KQ1UiAd+Bt2t1koI
         2iqUoHqyifDT3w/l0Obtm+8LTyKM7WTbPBnZOLSUQb0iYUurJB0oV1PDQmd0w11aqY
         YXu/Fj+VfJ25VbnXiNiGyTZSoKRhaagRCzmUQKbQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bodo Stroesser <bstroesser@ts.fujitsu.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Hannes Reinecke <hare@suse.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 25/79] scsi: target: core: Do not overwrite CDB byte 1
Date:   Fri,  8 Nov 2019 19:50:05 +0100
Message-Id: <20191108174759.866798759@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191108174745.495640141@linuxfoundation.org>
References: <20191108174745.495640141@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bodo Stroesser <bstroesser@ts.fujitsu.com>

[ Upstream commit 27e84243cb63601a10e366afe3e2d05bb03c1cb5 ]

passthrough_parse_cdb() - used by TCMU and PSCSI - attepts to reset the LUN
field of SCSI-2 CDBs (bits 5,6,7 of byte 1).  The current code is wrong as
for newer commands not having the LUN field it overwrites relevant command
bits (e.g. for SECURITY PROTOCOL IN / OUT). We think this code was
unnecessary from the beginning or at least it is no longer useful. So we
remove it entirely.

Link: https://lore.kernel.org/r/12498eab-76fd-eaad-1316-c2827badb76a@ts.fujitsu.com
Signed-off-by: Bodo Stroesser <bstroesser@ts.fujitsu.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Hannes Reinecke <hare@suse.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/target/target_core_device.c | 21 ---------------------
 1 file changed, 21 deletions(-)

diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
index 47b5ef153135c..e9ff2a7c0c0e6 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -1128,27 +1128,6 @@ passthrough_parse_cdb(struct se_cmd *cmd,
 	struct se_device *dev = cmd->se_dev;
 	unsigned int size;
 
-	/*
-	 * Clear a lun set in the cdb if the initiator talking to use spoke
-	 * and old standards version, as we can't assume the underlying device
-	 * won't choke up on it.
-	 */
-	switch (cdb[0]) {
-	case READ_10: /* SBC - RDProtect */
-	case READ_12: /* SBC - RDProtect */
-	case READ_16: /* SBC - RDProtect */
-	case SEND_DIAGNOSTIC: /* SPC - SELF-TEST Code */
-	case VERIFY: /* SBC - VRProtect */
-	case VERIFY_16: /* SBC - VRProtect */
-	case WRITE_VERIFY: /* SBC - VRProtect */
-	case WRITE_VERIFY_12: /* SBC - VRProtect */
-	case MAINTENANCE_IN: /* SPC - Parameter Data Format for SA RTPG */
-		break;
-	default:
-		cdb[1] &= 0x1f; /* clear logical unit number */
-		break;
-	}
-
 	/*
 	 * For REPORT LUNS we always need to emulate the response, for everything
 	 * else, pass it up.
-- 
2.20.1



