Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55B8734CB18
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:46:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232395AbhC2InR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:43:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:35470 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234781AbhC2IkU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:40:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2666561929;
        Mon, 29 Mar 2021 08:40:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617007209;
        bh=s8CUAHcMwZfuDDepr7QRjFqa0TeI3nPx9MDno/VgD8A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nMiUCUqgHFV73AWHPT/2Rid8q2yHGQhK1Dv82kOm5pt+8g2b1y356pfeyEpt0Pzty
         nuVTqpN5E0uE+UJtAIs+XcItVb3fCdmbWqCwLeS1Yr+4gOpz66QWCWo5iDAOANzjFX
         Ep6AcmZ7dgp+Bx+yQ1KDAfp+oeay3tDbVMRh4elI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, TOTE Robot <oslab@tsinghua.edu.cn>,
        Jia-Ju Bai <baijiaju1990@gmail.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 238/254] scsi: mpt3sas: Fix error return code of mpt3sas_base_attach()
Date:   Mon, 29 Mar 2021 09:59:14 +0200
Message-Id: <20210329075640.899721386@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210329075633.135869143@linuxfoundation.org>
References: <20210329075633.135869143@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jia-Ju Bai <baijiaju1990@gmail.com>

[ Upstream commit 3401ecf7fc1b9458a19d42c0e26a228f18ac7dda ]

When kzalloc() returns NULL, no error return code of mpt3sas_base_attach()
is assigned. To fix this bug, r is assigned with -ENOMEM in this case.

Link: https://lore.kernel.org/r/20210308035241.3288-1-baijiaju1990@gmail.com
Fixes: c696f7b83ede ("scsi: mpt3sas: Implement device_remove_in_progress check in IOCTL path")
Reported-by: TOTE Robot <oslab@tsinghua.edu.cn>
Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/mpt3sas/mpt3sas_base.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index 6e23dc3209fe..340d435ac0ce 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -7789,14 +7789,18 @@ mpt3sas_base_attach(struct MPT3SAS_ADAPTER *ioc)
 		ioc->pend_os_device_add_sz++;
 	ioc->pend_os_device_add = kzalloc(ioc->pend_os_device_add_sz,
 	    GFP_KERNEL);
-	if (!ioc->pend_os_device_add)
+	if (!ioc->pend_os_device_add) {
+		r = -ENOMEM;
 		goto out_free_resources;
+	}
 
 	ioc->device_remove_in_progress_sz = ioc->pend_os_device_add_sz;
 	ioc->device_remove_in_progress =
 		kzalloc(ioc->device_remove_in_progress_sz, GFP_KERNEL);
-	if (!ioc->device_remove_in_progress)
+	if (!ioc->device_remove_in_progress) {
+		r = -ENOMEM;
 		goto out_free_resources;
+	}
 
 	ioc->fwfault_debug = mpt3sas_fwfault_debug;
 
-- 
2.30.1



