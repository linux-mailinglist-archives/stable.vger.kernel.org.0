Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 47DBF43FED
	for <lists+stable@lfdr.de>; Thu, 13 Jun 2019 18:01:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389005AbfFMQBg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jun 2019 12:01:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:36362 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731427AbfFMIsZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Jun 2019 04:48:25 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C07B421473;
        Thu, 13 Jun 2019 08:48:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560415705;
        bh=IqCO23bLOxZGkinFkV7sw2ebEJzfNo2BWSXEsk/kzfY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WtPsvqCRYcVIgDgcbejsIa3FtdoMnaEAXRpNk/bzYr0KJvfLWH6x1zynwaxj4iHiP
         eFXFCHLGAm3TEB3XOSlF2JOdiHqRcsBcSdLk2qQEf3Iaed46cXoy+A+0mrioEN7Cmv
         YJvyhBQYX1Tc2CpRhuB+QaONahy612YdvwzjEneE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Greg Kurz <groug@kaod.org>,
        Alexey Kardashevskiy <aik@ozlabs.ru>,
        Alex Williamson <alex.williamson@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 072/155] vfio-pci/nvlink2: Fix potential VMA leak
Date:   Thu, 13 Jun 2019 10:33:04 +0200
Message-Id: <20190613075657.001361799@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190613075652.691765927@linuxfoundation.org>
References: <20190613075652.691765927@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 2c85f2bd519457073444ec28bbb4743a4e4237a7 ]

If vfio_pci_register_dev_region() fails then we should rollback
previous changes, ie. unmap the ATSD registers.

Fixes: 7f92891778df ("vfio_pci: Add NVIDIA GV100GL [Tesla V100 SXM2] subdriver")
Signed-off-by: Greg Kurz <groug@kaod.org>
Reviewed-by: Alexey Kardashevskiy <aik@ozlabs.ru>
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vfio/pci/vfio_pci_nvlink2.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/vfio/pci/vfio_pci_nvlink2.c b/drivers/vfio/pci/vfio_pci_nvlink2.c
index 32f695ffe128..50fe3c4f7feb 100644
--- a/drivers/vfio/pci/vfio_pci_nvlink2.c
+++ b/drivers/vfio/pci/vfio_pci_nvlink2.c
@@ -472,6 +472,8 @@ int vfio_pci_ibm_npu2_init(struct vfio_pci_device *vdev)
 	return 0;
 
 free_exit:
+	if (data->base)
+		memunmap(data->base);
 	kfree(data);
 
 	return ret;
-- 
2.20.1



