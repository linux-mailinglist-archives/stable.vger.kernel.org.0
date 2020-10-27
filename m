Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF99529B09B
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 15:22:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2901236AbgJ0OVa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 10:21:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:45730 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1757412AbgJ0OV2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:21:28 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 75205206F7;
        Tue, 27 Oct 2020 14:21:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603808487;
        bh=FN5dYjy+owldN5tlXjOVb1OYFx0gVwjUZM6Wq1r+HFI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kgoxcfs01yGqMSeZQMBJepNZZ/VPZsAap7rySYb/JkXHZysaMAodbzKZmS/y27kGr
         ObQsqCLYZe4DxLktfA0Jy39dLMdAMkqIFyhUjqqavguSdZfqG6cUY3a4ufzcpwaM4j
         ZcZ27CGt6g5t12J3uA6MV0qh+a1kS37PEoyxCAZU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Praveen Madhavan <praveenm@chelsio.com>,
        Tianjia Zhang <tianjia.zhang@linux.alibaba.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 080/264] scsi: csiostor: Fix wrong return value in csio_hw_prep_fw()
Date:   Tue, 27 Oct 2020 14:52:18 +0100
Message-Id: <20201027135434.459755470@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135430.632029009@linuxfoundation.org>
References: <20201027135430.632029009@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>

[ Upstream commit 44f4daf8678ae5f08c93bbe70792f90cd88e4649 ]

On an error exit path, a negative error code should be returned instead of
a positive return value.

Link: https://lore.kernel.org/r/20200802111531.5065-1-tianjia.zhang@linux.alibaba.com
Fixes: f40e74ffa3de ("csiostor:firmware upgrade fix")
Cc: Praveen Madhavan <praveenm@chelsio.com>
Signed-off-by: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/csiostor/csio_hw.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/csiostor/csio_hw.c b/drivers/scsi/csiostor/csio_hw.c
index e519238864758..1b6f9351b43f9 100644
--- a/drivers/scsi/csiostor/csio_hw.c
+++ b/drivers/scsi/csiostor/csio_hw.c
@@ -2384,7 +2384,7 @@ static int csio_hw_prep_fw(struct csio_hw *hw, struct fw_info *fw_info,
 			FW_HDR_FW_VER_MICRO_G(c), FW_HDR_FW_VER_BUILD_G(c),
 			FW_HDR_FW_VER_MAJOR_G(k), FW_HDR_FW_VER_MINOR_G(k),
 			FW_HDR_FW_VER_MICRO_G(k), FW_HDR_FW_VER_BUILD_G(k));
-		ret = EINVAL;
+		ret = -EINVAL;
 		goto bye;
 	}
 
-- 
2.25.1



