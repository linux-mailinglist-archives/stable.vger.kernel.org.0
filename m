Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0013B353D11
	for <lists+stable@lfdr.de>; Mon,  5 Apr 2021 10:59:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233544AbhDEI6O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Apr 2021 04:58:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:38206 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233550AbhDEI6J (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Apr 2021 04:58:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DA37D6124C;
        Mon,  5 Apr 2021 08:58:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617613083;
        bh=nXoYognAgYL6klut8TMdNteBomnnKW3sKoRjwvaPPMY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RZD4Ucuo3hXa0hnFGyzSCBuyVM9HzKbb+3Kq7R5cUGCrTIDNhK5T/ZH5fSPKqJcq0
         3rz8Fjn8qfDBfudG+dwETen37PlxLfu25TWA2Q1gl71sfNf2FxSTHjqbykqLAAmukv
         IH0m+yv4nXcABeSefc/E1AHOb+HK7KvbbkGv14W8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Kai=20M=C3=A4kisara?= <kai.makisara@kolumbus.fi>,
        Lv Yunlong <lyl2019@mail.ustc.edu.cn>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 13/52] scsi: st: Fix a use after free in st_open()
Date:   Mon,  5 Apr 2021 10:53:39 +0200
Message-Id: <20210405085022.433672918@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210405085021.996963957@linuxfoundation.org>
References: <20210405085021.996963957@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lv Yunlong <lyl2019@mail.ustc.edu.cn>

[ Upstream commit c8c165dea4c8f5ad67b1240861e4f6c5395fa4ac ]

In st_open(), if STp->in_use is true, STp will be freed by
scsi_tape_put(). However, STp is still used by DEBC_printk() after. It is
better to DEBC_printk() before scsi_tape_put().

Link: https://lore.kernel.org/r/20210311064636.10522-1-lyl2019@mail.ustc.edu.cn
Acked-by: Kai Mäkisara <kai.makisara@kolumbus.fi>
Signed-off-by: Lv Yunlong <lyl2019@mail.ustc.edu.cn>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/st.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
index 94e402ed30f6..6497a6f12a6f 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -1268,8 +1268,8 @@ static int st_open(struct inode *inode, struct file *filp)
 	spin_lock(&st_use_lock);
 	if (STp->in_use) {
 		spin_unlock(&st_use_lock);
-		scsi_tape_put(STp);
 		DEBC_printk(STp, "Device already in use.\n");
+		scsi_tape_put(STp);
 		return (-EBUSY);
 	}
 
-- 
2.30.1



