Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 918272E38BF
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 14:16:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732512AbgL1NOe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:14:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:42616 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732440AbgL1NOd (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:14:33 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 563DF20776;
        Mon, 28 Dec 2020 13:13:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609161232;
        bh=1HKm8A/RJzXlQcgNFDpF2YbZ7UZI3cbSrbp3YAdUJyg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F5yTuuaG1fX/h++/dESBq1ZSUCD3oom2k3xuqdZX2P7T/dHsMeYKoFB/hr6k5D75E
         85w3ir0I6xtA/udQPr+K7q5zLSLA01Q7eP5F7I32xaoWtkd/WYODP7FQGg23Y6Pd28
         2wL/On0vy0Ms676rR+BeRuvUENf/NadKA2dtZIUY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Karan Tilak Kumar <kartilak@cisco.com>,
        Zhang Changzhong <zhangchangzhong@huawei.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 147/242] scsi: fnic: Fix error return code in fnic_probe()
Date:   Mon, 28 Dec 2020 13:49:12 +0100
Message-Id: <20201228124911.941490459@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124904.654293249@linuxfoundation.org>
References: <20201228124904.654293249@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhang Changzhong <zhangchangzhong@huawei.com>

[ Upstream commit d4fc94fe65578738ded138e9fce043db6bfc3241 ]

Return a negative error code from the error handling case instead of 0 as
done elsewhere in this function.

Link: https://lore.kernel.org/r/1607068060-31203-1-git-send-email-zhangchangzhong@huawei.com
Fixes: 5df6d737dd4b ("[SCSI] fnic: Add new Cisco PCI-Express FCoE HBA")
Reported-by: Hulk Robot <hulkci@huawei.com>
Reviewed-by: Karan Tilak Kumar <kartilak@cisco.com>
Signed-off-by: Zhang Changzhong <zhangchangzhong@huawei.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/fnic/fnic_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/fnic/fnic_main.c b/drivers/scsi/fnic/fnic_main.c
index aacadbf20b695..878e486762729 100644
--- a/drivers/scsi/fnic/fnic_main.c
+++ b/drivers/scsi/fnic/fnic_main.c
@@ -746,6 +746,7 @@ static int fnic_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	for (i = 0; i < FNIC_IO_LOCKS; i++)
 		spin_lock_init(&fnic->io_req_lock[i]);
 
+	err = -ENOMEM;
 	fnic->io_req_pool = mempool_create_slab_pool(2, fnic_io_req_cache);
 	if (!fnic->io_req_pool)
 		goto err_out_free_resources;
-- 
2.27.0



