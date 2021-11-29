Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E86DA46254F
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 23:34:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233423AbhK2Whv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 17:37:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233332AbhK2WhZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 17:37:25 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B3C9C0800D6;
        Mon, 29 Nov 2021 10:38:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6223AB815E0;
        Mon, 29 Nov 2021 18:38:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B9D9C53FAD;
        Mon, 29 Nov 2021 18:38:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638211134;
        bh=jxWdCZKE5faMX1OHns8SDll9sYz3TwCmkl0k0W22p/I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CZKgJ9D8bM8bgmtWZcVC6unRwlQiIwtU60xSzBwaQrN4sTcWddTWjR83URposex/W
         dbXCNYePvJRDwHhiN+ZHHkpzuWvgK8sTVdgUV0LoSJe2kN30DsDw2jost0pCzCo4n8
         CdSj2gku3kGmR9Bzwgz+zYCFmzOcQaKCP7Dwvl/w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Douglas Gilbert <dgilbert@interlog.com>,
        Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 116/179] scsi: scsi_debug: Zero clear zones at reset write pointer
Date:   Mon, 29 Nov 2021 19:18:30 +0100
Message-Id: <20211129181722.779457122@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211129181718.913038547@linuxfoundation.org>
References: <20211129181718.913038547@linuxfoundation.org>
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
index ead65cdfb522e..1b1a63a467816 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -4649,6 +4649,7 @@ static void zbc_rwp_zone(struct sdebug_dev_info *devip,
 			 struct sdeb_zone_state *zsp)
 {
 	enum sdebug_z_cond zc;
+	struct sdeb_store_info *sip = devip2sip(devip, false);
 
 	if (zbc_zone_is_conv(zsp))
 		return;
@@ -4660,6 +4661,10 @@ static void zbc_rwp_zone(struct sdebug_dev_info *devip,
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



