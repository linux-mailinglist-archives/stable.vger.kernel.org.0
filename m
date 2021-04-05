Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E70B353CC1
	for <lists+stable@lfdr.de>; Mon,  5 Apr 2021 10:58:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232562AbhDEI4l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Apr 2021 04:56:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:35016 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232807AbhDEI4e (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Apr 2021 04:56:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 60C1861245;
        Mon,  5 Apr 2021 08:56:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617612988;
        bh=SgKPuZd8oNEf6L+eoHlKEq1ZfoBGPgyZhkN5ZIJjqeA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sbAqBKz8bDHIVu8ihP8f6wpU3qqWQcHRLIozj/B/JnLfSuQ/EdAdmkmUeercKojXQ
         gQrEwf8d8hLP40sUFQZSL/vKKLRvdBRy8V4RO2QO0me89C5VWXyYjwCI1rgCs7RFTU
         0pUxtAKsYZTfSushFhcQG+KAv7gxFcPHzF6Gr7sg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Kai=20M=C3=A4kisara?= <kai.makisara@kolumbus.fi>,
        Lv Yunlong <lyl2019@mail.ustc.edu.cn>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 10/35] scsi: st: Fix a use after free in st_open()
Date:   Mon,  5 Apr 2021 10:53:45 +0200
Message-Id: <20210405085019.197761501@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210405085018.871387942@linuxfoundation.org>
References: <20210405085018.871387942@linuxfoundation.org>
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
index 618422ea3a41..0d58227431e4 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -1267,8 +1267,8 @@ static int st_open(struct inode *inode, struct file *filp)
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



