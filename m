Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95FC929AE69
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 15:00:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1753241AbgJ0N7U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 09:59:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:46790 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753239AbgJ0N7T (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 09:59:19 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 56BDB218AC;
        Tue, 27 Oct 2020 13:59:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603807157;
        bh=3TadBh0ChBLdE/OoitLzKEq7k8MBSDGCCFHdu6BOMfU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZRv/YgeqJ2f3WNbRgDXuun1WNuZZXOe2YG+yEMCGLKzmRCPnW0vnrxfCftZfKoSa7
         xE1qotfkYE5cKbgRjtXi9/HxJQP84vLyPYql46qE5oHUFVg+aYG9Sp9csEgd5Kv010
         di76iKJbd9VHJMvIissfxzGVj1vowhwjsln0ENCM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Praveen Madhavan <praveenm@chelsio.com>,
        Tianjia Zhang <tianjia.zhang@linux.alibaba.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 033/112] scsi: csiostor: Fix wrong return value in csio_hw_prep_fw()
Date:   Tue, 27 Oct 2020 14:49:03 +0100
Message-Id: <20201027134902.125418743@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027134900.532249571@linuxfoundation.org>
References: <20201027134900.532249571@linuxfoundation.org>
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
index dab195f04da78..06ca0495f3e8e 100644
--- a/drivers/scsi/csiostor/csio_hw.c
+++ b/drivers/scsi/csiostor/csio_hw.c
@@ -1973,7 +1973,7 @@ static int csio_hw_prep_fw(struct csio_hw *hw, struct fw_info *fw_info,
 			FW_HDR_FW_VER_MICRO_G(c), FW_HDR_FW_VER_BUILD_G(c),
 			FW_HDR_FW_VER_MAJOR_G(k), FW_HDR_FW_VER_MINOR_G(k),
 			FW_HDR_FW_VER_MICRO_G(k), FW_HDR_FW_VER_BUILD_G(k));
-		ret = EINVAL;
+		ret = -EINVAL;
 		goto bye;
 	}
 
-- 
2.25.1



