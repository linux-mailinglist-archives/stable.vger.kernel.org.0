Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8C7F814001F
	for <lists+stable@lfdr.de>; Fri, 17 Jan 2020 00:48:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390548AbgAPXUD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 18:20:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:46274 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390543AbgAPXUC (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 18:20:02 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D21352073A;
        Thu, 16 Jan 2020 23:20:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579216802;
        bh=zRGvNmywoR/9q+AHuoeFvd//FzZkNZYoznVN35C7pjk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nzzoEQhI2xrFNurbBjwhrRb86g8IcvgcrGZ7inrkv1yVLcCzDvoH+F04iUW5EUk5k
         LapCoAme1GZ3v8sUNqMClrvDOZITPMsJbCcIAp38tkuwM4YeFIP39W8E/K4ISXO9L5
         RLpRIrhsRLgs+5BbYzTzYJQEWxXHUZH9V1tr3qMQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.4 025/203] scsi: mpt3sas: Fix double free in attach error handling
Date:   Fri, 17 Jan 2020 00:15:42 +0100
Message-Id: <20200116231746.670187422@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200116231745.218684830@linuxfoundation.org>
References: <20200116231745.218684830@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

commit ee560e7bbab0c10cf3f0e71997fbc354ab2ee5cb upstream.

The caller also calls _base_release_memory_pools() on error so it leads to
a number of double frees:

drivers/scsi/mpt3sas/mpt3sas_base.c:7207 mpt3sas_base_attach() warn: 'ioc->chain_dma_pool' double freed
drivers/scsi/mpt3sas/mpt3sas_base.c:7207 mpt3sas_base_attach() warn: 'ioc->hpr_lookup' double freed
drivers/scsi/mpt3sas/mpt3sas_base.c:7207 mpt3sas_base_attach() warn: 'ioc->internal_lookup' double freed
drivers/scsi/mpt3sas/mpt3sas_base.c:7207 mpt3sas_base_attach() warn: 'ioc->pcie_sgl_dma_pool' double freed
drivers/scsi/mpt3sas/mpt3sas_base.c:7207 mpt3sas_base_attach() warn: 'ioc->reply_dma_pool' double freed
drivers/scsi/mpt3sas/mpt3sas_base.c:7207 mpt3sas_base_attach() warn: 'ioc->reply_free_dma_pool' double freed
drivers/scsi/mpt3sas/mpt3sas_base.c:7207 mpt3sas_base_attach() warn: 'ioc->reply_post_free_array_dma_pool' double freed
drivers/scsi/mpt3sas/mpt3sas_base.c:7207 mpt3sas_base_attach() warn: 'ioc->reply_post_free_dma_pool' double freed
drivers/scsi/mpt3sas/mpt3sas_base.c:7207 mpt3sas_base_attach() warn: 'ioc->sense_dma_pool' double freed

Fixes: 74522a92bbf0 ("scsi: mpt3sas: Optimize I/O memory consumption in driver.")
Link: https://lore.kernel.org/r/20191203093652.gyntgvnkw2udatyc@kili.mountain
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Acked-by: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/scsi/mpt3sas/mpt3sas_base.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -5234,7 +5234,6 @@ _base_allocate_memory_pools(struct MPT3S
 					&ct->chain_buffer_dma);
 			if (!ct->chain_buffer) {
 				ioc_err(ioc, "chain_lookup: pci_pool_alloc failed\n");
-				_base_release_memory_pools(ioc);
 				goto out;
 			}
 		}


