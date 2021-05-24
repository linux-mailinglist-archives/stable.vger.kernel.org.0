Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87A0D38ED15
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 17:32:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233467AbhEXPdh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 11:33:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:50520 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232614AbhEXPcl (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 May 2021 11:32:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B6E21613C8;
        Mon, 24 May 2021 15:30:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621870256;
        bh=Tp4gqflkcR4lqwbOXiZhH05st7l+CzZaGalYySy33c4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MbwVW32qPQwCiHiVWGZItig56eUmiB+XyD8QrYwEyY1Xus29W7/G8R+sVWGNbeUpg
         XbuDgwdKyRUkusYv7YEqSQCHlzl/x8Q9qpgZ4sqoWMPypZ5TpISfg0IWOp9FJRMsnT
         MMZarLTLO0MrfFiEg5LG26rcY3D1BA56mMNjZqlQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Zhen Lei <thunder.leizhen@huawei.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 02/31] scsi: qla2xxx: Fix error return code in qla82xx_write_flash_dword()
Date:   Mon, 24 May 2021 17:24:45 +0200
Message-Id: <20210524152322.997166477@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210524152322.919918360@linuxfoundation.org>
References: <20210524152322.919918360@linuxfoundation.org>
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
index 65f8d2d94159..46f7e3988009 100644
--- a/drivers/scsi/qla2xxx/qla_nx.c
+++ b/drivers/scsi/qla2xxx/qla_nx.c
@@ -1103,7 +1103,8 @@ qla82xx_write_flash_dword(struct qla_hw_data *ha, uint32_t flashaddr,
 		return ret;
 	}
 
-	if (qla82xx_flash_set_write_enable(ha))
+	ret = qla82xx_flash_set_write_enable(ha);
+	if (ret < 0)
 		goto done_write;
 
 	qla82xx_wr_32(ha, QLA82XX_ROMUSB_ROM_WDATA, data);
-- 
2.30.2



