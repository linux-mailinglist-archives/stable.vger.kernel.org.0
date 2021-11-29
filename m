Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E87D461E7A
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 19:34:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379590AbhK2Sg1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 13:36:27 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:39422 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379565AbhK2Se0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 13:34:26 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8B0B3B815E0;
        Mon, 29 Nov 2021 18:31:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B737EC53FC7;
        Mon, 29 Nov 2021 18:30:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638210660;
        bh=6RL4Owx+//WhEBUmpiLTRE/JU85TjLHH0oXFSLNUmIA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JCFT9xLnxI8WNREMx6aZ8w26vCOxpQ6tShsFtQBpxhn+Cl5uDCRDwpL+zYP/aaFWf
         S3oe7gNIOHWy/8AP69DToSJbYue5ze01L99Fp1FoZP+BEPoRQrO+Hjp/C4OOw1YOoE
         WdeSCW3ChvMeV3AkTkkiMelkm0VvtQMOIuP93x+g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Douglas Gilbert <dgilbert@interlog.com>,
        Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 073/121] scsi: scsi_debug: Zero clear zones at reset write pointer
Date:   Mon, 29 Nov 2021 19:18:24 +0100
Message-Id: <20211129181714.105533357@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211129181711.642046348@linuxfoundation.org>
References: <20211129181711.642046348@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>

[ Upstream commit 2d62253eb1b60f4ce8b39125eee282739b519297 ]

When a reset is requested the position of the write pointer is updated but
the data in the corresponding zone is not cleared. Instead scsi_debug
returns any data written before the write pointer was reset. This is an
error and prevents using scsi_debug for stale page cache testing of the
BLKRESETZONE ioctl.

Zero written data in the zone when resetting the write pointer.

Link: https://lore.kernel.org/r/20211122061223.298890-1-shinichiro.kawasaki@wdc.com
Fixes: f0d1cf9378bd ("scsi: scsi_debug: Add ZBC zone commands")
Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Acked-by: Douglas Gilbert <dgilbert@interlog.com>
Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/scsi_debug.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 3fc7c2a31c191..1a3f5adc68849 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -4628,6 +4628,7 @@ static void zbc_rwp_zone(struct sdebug_dev_info *devip,
 			 struct sdeb_zone_state *zsp)
 {
 	enum sdebug_z_cond zc;
+	struct sdeb_store_info *sip = devip2sip(devip, false);
 
 	if (zbc_zone_is_conv(zsp))
 		return;
@@ -4639,6 +4640,10 @@ static void zbc_rwp_zone(struct sdebug_dev_info *devip,
 	if (zsp->z_cond == ZC4_CLOSED)
 		devip->nr_closed--;
 
+	if (zsp->z_wp > zsp->z_start)
+		memset(sip->storep + zsp->z_start * sdebug_sector_size, 0,
+		       (zsp->z_wp - zsp->z_start) * sdebug_sector_size);
+
 	zsp->z_non_seq_resource = false;
 	zsp->z_wp = zsp->z_start;
 	zsp->z_cond = ZC1_EMPTY;
-- 
2.33.0



