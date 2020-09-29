Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCB0427CA41
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 14:19:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732339AbgI2MRl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 08:17:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:53442 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729320AbgI2Lgx (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:36:53 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5534323E52;
        Tue, 29 Sep 2020 11:31:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601379117;
        bh=ZnLj/QanGbny801H/qtAJkF9ao4X/iYTvxHzv8kHxjU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cvnSOtpJHDVeIk+jR/ZkDhvn9qnrJA/2dcUL/LGo021Fz8OHzvwlY6BilXeblZ3Wy
         U+OxtAyYE0dur/rQ2nPdaIJ01EaOCWp3nTHscNnh/ph2HUVtEuzDGq5zd3/w3NLTwO
         DbKnnOFkU8GWnPbYSX5ds82j8FCOxuVyOOxQq3As=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 003/388] scsi: mpt3sas: Free diag buffer without any status check
Date:   Tue, 29 Sep 2020 12:55:34 +0200
Message-Id: <20200929110010.645141512@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929110010.467764689@linuxfoundation.org>
References: <20200929110010.467764689@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sreekanth Reddy <sreekanth.reddy@broadcom.com>

[ Upstream commit 764f472ba4a7a0c18107ebfbe1a9f1f5f5a1e411 ]

Memory leak can happen when diag buffer is released but not unregistered
(where buffer is deallocated) by the user. During module unload time driver
is not deallocating the buffer if the buffer is in released state.

Deallocate the diag buffer during module unload time without any diag
buffer status checks.

Link: https://lore.kernel.org/r/1568379890-18347-5-git-send-email-sreekanth.reddy@broadcom.com
Signed-off-by: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/mpt3sas/mpt3sas_ctl.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_ctl.c b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
index d5a62fea8fe3e..bae7cf70ee177 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_ctl.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
@@ -3717,12 +3717,6 @@ mpt3sas_ctl_exit(ushort hbas_to_enumerate)
 		for (i = 0; i < MPI2_DIAG_BUF_TYPE_COUNT; i++) {
 			if (!ioc->diag_buffer[i])
 				continue;
-			if (!(ioc->diag_buffer_status[i] &
-			    MPT3_DIAG_BUFFER_IS_REGISTERED))
-				continue;
-			if ((ioc->diag_buffer_status[i] &
-			    MPT3_DIAG_BUFFER_IS_RELEASED))
-				continue;
 			dma_free_coherent(&ioc->pdev->dev,
 					  ioc->diag_buffer_sz[i],
 					  ioc->diag_buffer[i],
-- 
2.25.1



