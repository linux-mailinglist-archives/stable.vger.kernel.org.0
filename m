Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9094E40E5F6
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 19:28:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344604AbhIPRQx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 13:16:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:40900 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1351204AbhIPRPQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 13:15:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 72DC061B72;
        Thu, 16 Sep 2021 16:39:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631810374;
        bh=rVbJicvufnTgq6rdOiSTUkXmOj2eBIsyPYolO4fq+Q4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HBaW4GOFw8sLq3FrQn41w/S3AsCEHjjTiMv3yRbYWp8oLHLGOdzracUJYSk6v8MrA
         A4B9Zfsyj3w+phT1zCjbqlTlCQViO27RbChzcAWM9hxpb+xNBMMZ4FAi/NUqWnC8s6
         SUhzM1uEakMZUTR6Vo77R3WbEyPOOpw0YyL/k7+0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 117/432] scsi: smartpqi: Fix an error code in pqi_get_raid_map()
Date:   Thu, 16 Sep 2021 17:57:46 +0200
Message-Id: <20210916155814.731243786@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155810.813340753@linuxfoundation.org>
References: <20210916155810.813340753@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit d1f6581a6796c4e9fd8a4a24e8b77463d18f0df1 ]

Return -EINVAL on failure instead of success.

Link: https://lore.kernel.org/r/20210810084613.GB23810@kili
Fixes: a91aaae0243b ("scsi: smartpqi: allow for larger raid maps")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/smartpqi/smartpqi_init.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index dcc0b9618a64..8819a407c02b 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -1322,6 +1322,7 @@ static int pqi_get_raid_map(struct pqi_ctrl_info *ctrl_info,
 				"requested %u bytes, received %u bytes\n",
 				raid_map_size,
 				get_unaligned_le32(&raid_map->structure_size));
+			rc = -EINVAL;
 			goto error;
 		}
 	}
-- 
2.30.2



