Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E44AC205EF2
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 22:32:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390331AbgFWU1q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 16:27:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:47346 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390788AbgFWU1o (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:27:44 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3D1F92064B;
        Tue, 23 Jun 2020 20:27:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592944064;
        bh=JT7YxV6z/6qiwExiVMHHGnzReWH50EhdvoD/VQr3wiI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=L67PAqsSR+ubxEcyUe2z43DLRaG/VrBr69465STczqROwaiGxU1qf2H7YxNXXReen
         pDnJPch0zGWVv/qY6ogh2Ht9ou+nIWjqPNyke3sNkpX2Bo3BR3wGPQn1ueOg+BjgBW
         uU4znbUkg3sBDMi3gT09GcNP+dRF2vSre3X8t+a8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Suganath Prabu S <suganath-prabu.subramani@broadcom.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 131/314] scsi: mpt3sas: Fix double free warnings
Date:   Tue, 23 Jun 2020 21:55:26 +0200
Message-Id: <20200623195345.120586545@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195338.770401005@linuxfoundation.org>
References: <20200623195338.770401005@linuxfoundation.org>
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
index 752b71cfbe12c..7fd1d731555f9 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -4777,7 +4777,9 @@ _base_release_memory_pools(struct MPT3SAS_ADAPTER *ioc)
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



