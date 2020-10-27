Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A9B229C299
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 18:38:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1760570AbgJ0OfN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 10:35:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:33886 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1760560AbgJ0OfK (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:35:10 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2DDAA20773;
        Tue, 27 Oct 2020 14:35:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603809309;
        bh=fAUpmm08gN4J9wtUSzSkK+j6Tl/1sD2jHmgwo+379/s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vgAGGErUtIOVbwPcop/juGkOWiPEz6sSFcgmOEu5YZJb6GgkOqbIf+wq4N3/grsxC
         bm9sDmM6gFisF+WjFEtx2mxHaCOCv2KdmNP5g0YmeltSER6mN/ROb1gzL4SUfApIPB
         jTpaz9QdBfjDRv7rmggM5w6S7lim97A6HBLtztsE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Quinn Tran <quinn.tran@cavium.com>,
        Tianjia Zhang <tianjia.zhang@linux.alibaba.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 120/408] scsi: qla2xxx: Fix wrong return value in qla_nvme_register_hba()
Date:   Tue, 27 Oct 2020 14:50:58 +0100
Message-Id: <20201027135500.676068294@linuxfoundation.org>
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

From: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>

[ Upstream commit ca4fb89a3d714a770e9c73c649da830f3f4a5326 ]

On an error exit path, a negative error code should be returned instead of
a positive return value.

Link: https://lore.kernel.org/r/20200802111530.5020-1-tianjia.zhang@linux.alibaba.com
Fixes: 8777e4314d39 ("scsi: qla2xxx: Migrate NVME N2N handling into state machine")
Cc: Quinn Tran <quinn.tran@cavium.com>
Signed-off-by: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qla2xxx/qla_nvme.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_nvme.c b/drivers/scsi/qla2xxx/qla_nvme.c
index f4815a4084d8c..11656e864fca9 100644
--- a/drivers/scsi/qla2xxx/qla_nvme.c
+++ b/drivers/scsi/qla2xxx/qla_nvme.c
@@ -682,7 +682,7 @@ int qla_nvme_register_hba(struct scsi_qla_host *vha)
 	struct nvme_fc_port_template *tmpl;
 	struct qla_hw_data *ha;
 	struct nvme_fc_port_info pinfo;
-	int ret = EINVAL;
+	int ret = -EINVAL;
 
 	if (!IS_ENABLED(CONFIG_NVME_FC))
 		return ret;
-- 
2.25.1



