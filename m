Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7AED29C1E3
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 18:31:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1761116AbgJ0OiA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 10:38:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:37176 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1761112AbgJ0Oh7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:37:59 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B1F1422202;
        Tue, 27 Oct 2020 14:37:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603809479;
        bh=N9ZZqb4Wkg37PqufQ2y5tFtrYw9JGWQ7EOeCVPoA6T0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JhqxhHVAVxavMBnQcv9xDPC7CniW77tQ9LcMGoldOkNtrIbsdgIQKC4TXhgekmhtE
         MA5m9KxBdWF3vdDkI2MfvtEov1OgDxFh5ZqkCXL9obxmGvuQkKDinI5oO5gUs0oxT8
         1tYY5aNBbN/ygZlQFQlyikVDxTdyXJ5DYR1/e6z8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mike Christie <michael.christie@oracle.com>,
        John Donnelly <john.p.donnelly@oracle.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 183/408] scsi: target: tcmu: Fix warning: page may be used uninitialized
Date:   Tue, 27 Oct 2020 14:52:01 +0100
Message-Id: <20201027135503.579752661@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135455.027547757@linuxfoundation.org>
References: <20201027135455.027547757@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: John Donnelly <john.p.donnelly@oracle.com>

[ Upstream commit 61741d8699e1fc764a309ebd20211bb1cb193110 ]

Corrects drivers/target/target_core_user.c:688:6: warning: 'page' may be
used uninitialized.

Link: https://lore.kernel.org/r/20200924001920.43594-1-john.p.donnelly@oracle.com
Fixes: 3c58f737231e ("scsi: target: tcmu: Optimize use of flush_dcache_page")
Cc: Mike Christie <michael.christie@oracle.com>
Acked-by: Mike Christie <michael.christie@oracle.com>
Signed-off-by: John Donnelly <john.p.donnelly@oracle.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/target/target_core_user.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
index ea925b102b322..d6634baebb474 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -669,7 +669,7 @@ static void scatter_data_area(struct tcmu_dev *udev,
 	void *from, *to = NULL;
 	size_t copy_bytes, to_offset, offset;
 	struct scatterlist *sg;
-	struct page *page;
+	struct page *page = NULL;
 
 	for_each_sg(data_sg, sg, data_nents, i) {
 		int sg_remaining = sg->length;
-- 
2.25.1



