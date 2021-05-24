Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49A2938EE57
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 17:49:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233298AbhEXPsd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 11:48:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:33952 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234141AbhEXPqa (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 May 2021 11:46:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2FA0A61480;
        Mon, 24 May 2021 15:36:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621870610;
        bh=ygiuHxg9vCCzqyxiwByGyk+UO4v5+YH2UpUoEb3vkBk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FWLRQ0YMYuidNCTHzwtt3so+h9YKnxVrYu7soZBQoY7VBjFJPrG8z1zj0hmQdZZjT
         f3o92pr+BY8GSaX63SVPB0ty3tqo+Ix5V1w7/RUUc3zGtUnoOpJdH1Wtcqt35E1jKz
         Gd6DuJmbKfOLCgdE3PBLuT6Iws+GPPAQ38ju7rho=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Zhen Lei <thunder.leizhen@huawei.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 07/71] scsi: qla2xxx: Fix error return code in qla82xx_write_flash_dword()
Date:   Mon, 24 May 2021 17:25:13 +0200
Message-Id: <20210524152326.699930491@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210524152326.447759938@linuxfoundation.org>
References: <20210524152326.447759938@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhen Lei <thunder.leizhen@huawei.com>

[ Upstream commit 5cb289bf2d7c34ca1abd794ce116c4f19185a1d4 ]

Fix to return a negative error code from the error handling case instead of
0 as done elsewhere in this function.

Link: https://lore.kernel.org/r/20210514090952.6715-1-thunder.leizhen@huawei.com
Fixes: a9083016a531 ("[SCSI] qla2xxx: Add ISP82XX support.")
Reported-by: Hulk Robot <hulkci@huawei.com>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qla2xxx/qla_nx.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_nx.c b/drivers/scsi/qla2xxx/qla_nx.c
index c855d013ba8a..de567a025133 100644
--- a/drivers/scsi/qla2xxx/qla_nx.c
+++ b/drivers/scsi/qla2xxx/qla_nx.c
@@ -1113,7 +1113,8 @@ qla82xx_write_flash_dword(struct qla_hw_data *ha, uint32_t flashaddr,
 		return ret;
 	}
 
-	if (qla82xx_flash_set_write_enable(ha))
+	ret = qla82xx_flash_set_write_enable(ha);
+	if (ret < 0)
 		goto done_write;
 
 	qla82xx_wr_32(ha, QLA82XX_ROMUSB_ROM_WDATA, data);
-- 
2.30.2



