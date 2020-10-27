Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 301E029BCCE
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:41:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1811092AbgJ0QhO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 12:37:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:40460 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1801919AbgJ0PpC (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:45:02 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B253A2231B;
        Tue, 27 Oct 2020 15:44:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603813500;
        bh=sJdj1y2IIrk/4e9GcM3TwcMPmA8GTSIhJ/jnAqLCPvg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aVeVEx54XCcSeXZCOVkdetpmcwzOmZKACU+UysLoI5GXmuuGu/K6iHjShFyWVYQDL
         4//WQTMQeIJssASQTAp+Q6Y+wLXeQf+tUtJhYOqjZKQq33hfnkJCbtKakR+WJYK5ti
         LrtUf3OMdA254xxXUuAzuvNU57sEG6hdnmJJ2V0k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jing Xiangfeng <jingxiangfeng@huawei.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 571/757] scsi: bfa: Fix error return in bfad_pci_init()
Date:   Tue, 27 Oct 2020 14:53:41 +0100
Message-Id: <20201027135517.294174053@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jing Xiangfeng <jingxiangfeng@huawei.com>

[ Upstream commit f0f6c3a4fcb80fcbcce4ff6739996dd98c228afd ]

Fix to return error code -ENODEV from the error handling case instead of 0.

Link: https://lore.kernel.org/r/20200925062423.161504-1-jingxiangfeng@huawei.com
Fixes: 11ea3824140c ("scsi: bfa: fix calls to dma_set_mask_and_coherent()")
Signed-off-by: Jing Xiangfeng <jingxiangfeng@huawei.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/bfa/bfad.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/bfa/bfad.c b/drivers/scsi/bfa/bfad.c
index bc5d84f87d8fc..440ef32be048f 100644
--- a/drivers/scsi/bfa/bfad.c
+++ b/drivers/scsi/bfa/bfad.c
@@ -749,6 +749,7 @@ bfad_pci_init(struct pci_dev *pdev, struct bfad_s *bfad)
 
 	if (bfad->pci_bar0_kva == NULL) {
 		printk(KERN_ERR "Fail to map bar0\n");
+		rc = -ENODEV;
 		goto out_release_region;
 	}
 
-- 
2.25.1



