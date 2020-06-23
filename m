Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48AB8205FEE
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 22:47:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391883AbgFWUhr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 16:37:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:33052 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391881AbgFWUho (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:37:44 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A21EE20781;
        Tue, 23 Jun 2020 20:37:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592944665;
        bh=RMqzzt01BOikjN8ADoywgLVHGqM1ozO+nzBrEdGYpv4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LFEJsMbvsfnrxkLjTH2VS1LXnhenSQSZ04oO0x+8vOqGHBBE7DyJgYbFFho/bgO+S
         0MCZ0SDxu6VbanQdXT9EoG87YkanPewl2MkLWFq6Yp05stNNzmA74LIVBzMBCzfM0n
         j0ns7B4LD7jr//GX1e0yN63RqAbCE1+OH73d/JOA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Suganath Prabu S <suganath-prabu.subramani@broadcom.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 078/206] scsi: mpt3sas: Fix double free warnings
Date:   Tue, 23 Jun 2020 21:56:46 +0200
Message-Id: <20200623195320.784649884@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195316.864547658@linuxfoundation.org>
References: <20200623195316.864547658@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Suganath Prabu S <suganath-prabu.subramani@broadcom.com>

[ Upstream commit cbbfdb2a2416c9f0cde913cf09670097ac281282 ]

Fix following warning from Smatch static analyser:

drivers/scsi/mpt3sas/mpt3sas_base.c:5256 _base_allocate_memory_pools()
warn: 'ioc->hpr_lookup' double freed

drivers/scsi/mpt3sas/mpt3sas_base.c:5256 _base_allocate_memory_pools()
warn: 'ioc->internal_lookup' double freed

Link: https://lore.kernel.org/r/20200508110738.30732-1-suganath-prabu.subramani@broadcom.com
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/mpt3sas/mpt3sas_base.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index 2c556c7fcf0dc..9fbe20e38ad07 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -4284,7 +4284,9 @@ _base_release_memory_pools(struct MPT3SAS_ADAPTER *ioc)
 	}
 
 	kfree(ioc->hpr_lookup);
+	ioc->hpr_lookup = NULL;
 	kfree(ioc->internal_lookup);
+	ioc->internal_lookup = NULL;
 	if (ioc->chain_lookup) {
 		for (i = 0; i < ioc->scsiio_depth; i++) {
 			for (j = ioc->chains_per_prp_buffer;
-- 
2.25.1



