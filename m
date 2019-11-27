Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7EE0A10BCBD
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 22:23:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731875AbfK0VEi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 16:04:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:58172 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730714AbfK0VEi (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 16:04:38 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 58E92215F1;
        Wed, 27 Nov 2019 21:04:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574888677;
        bh=kqAp3QBxVhcqTGJGRtkpTNDA19iAjS9CSm45alVTbgM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2cJupqUuzDAP8POlmmnB8GEN46i+pwiRBKlKkert/cvjrsIQvslv66mGnoDymFY/n
         C1YFTV8gQ5LtRoyLH/SWVJzgcDzXslyevTGlABW1en2cYxCW1HGQLso9KI6v9PDF1k
         U3twfU/f4p5W9hgOif5tKUHEdkLL7Kw1V6uyCziE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Suganath Prabu <suganath-prabu.subramani@broadcom.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 226/306] scsi: mpt3sas: Fix driver modifying persistent data in Manufacturing page11
Date:   Wed, 27 Nov 2019 21:31:16 +0100
Message-Id: <20191127203131.550624748@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127203114.766709977@linuxfoundation.org>
References: <20191127203114.766709977@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Suganath Prabu <suganath-prabu.subramani@broadcom.com>

[ Upstream commit 97f35194093362a63b33caba2485521ddabe2c95 ]

Currently driver is modifying both current & NVRAM/persistent data in
Manufacturing page11. Driver should change only current copy of
Manufacturing page11. It should not modify the persistent data.

So removed the section of code where driver is modifying the persistent
data of Manufacturing page11.

Signed-off-by: Suganath Prabu <suganath-prabu.subramani@broadcom.com>
Reviewed-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/mpt3sas/mpt3sas_config.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_config.c b/drivers/scsi/mpt3sas/mpt3sas_config.c
index d29a2dcc7d0ec..9b01c5a7aebd9 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_config.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_config.c
@@ -692,10 +692,6 @@ mpt3sas_config_set_manufacturing_pg11(struct MPT3SAS_ADAPTER *ioc,
 	r = _config_request(ioc, &mpi_request, mpi_reply,
 	    MPT3_CONFIG_PAGE_DEFAULT_TIMEOUT, config_page,
 	    sizeof(*config_page));
-	mpi_request.Action = MPI2_CONFIG_ACTION_PAGE_WRITE_NVRAM;
-	r = _config_request(ioc, &mpi_request, mpi_reply,
-	    MPT3_CONFIG_PAGE_DEFAULT_TIMEOUT, config_page,
-	    sizeof(*config_page));
  out:
 	return r;
 }
-- 
2.20.1



