Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BCE629C472
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 18:56:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1823019AbgJ0R4u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 13:56:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:45534 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2901221AbgJ0OVR (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:21:17 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A75FF206D4;
        Tue, 27 Oct 2020 14:21:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603808477;
        bh=gq2WKumM6XpZ4EehnHCJgZ/jyGHk6RuZeII0HWizwS8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kqSmLoJuQrbh7f7SUeTrHSjUa/4UjDdbT2auI1SU9Ey4wfflWXMue6ms4r0AYCOhU
         XyiKiJoEaPIEnX1R2OGS7LiYmbDnx+JpQ8bCYuraouxn07Ykcy08ryFVcGjqUmhGga
         /hFour6w0493prgj34QEd830I81NS0VexhwcDqhk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Quinn Tran <quinn.tran@cavium.com>,
        Tianjia Zhang <tianjia.zhang@linux.alibaba.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 079/264] scsi: qla2xxx: Fix wrong return value in qla_nvme_register_hba()
Date:   Tue, 27 Oct 2020 14:52:17 +0100
Message-Id: <20201027135434.421446680@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135430.632029009@linuxfoundation.org>
References: <20201027135430.632029009@linuxfoundation.org>
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
index 3e2f8ce1d9a97..7821c1695e824 100644
--- a/drivers/scsi/qla2xxx/qla_nvme.c
+++ b/drivers/scsi/qla2xxx/qla_nvme.c
@@ -676,7 +676,7 @@ int qla_nvme_register_hba(struct scsi_qla_host *vha)
 	struct nvme_fc_port_template *tmpl;
 	struct qla_hw_data *ha;
 	struct nvme_fc_port_info pinfo;
-	int ret = EINVAL;
+	int ret = -EINVAL;
 
 	if (!IS_ENABLED(CONFIG_NVME_FC))
 		return ret;
-- 
2.25.1



