Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BE0A3290E8
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 21:21:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242468AbhCAURQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 15:17:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:37640 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242382AbhCAUHJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 15:07:09 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B81FB653A8;
        Mon,  1 Mar 2021 17:59:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614621562;
        bh=Yew9bKmg9JYsblQ5sw1CW89HqSXIK+x2rqcYWQHtVWU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZQTEx5FEppdw+6Zr0Pm7bChEe4jvRFH8SAqrv9CNoAa6kfQEJAAEz4+wGcPq2i4hj
         Tjpwsn/nmlFHighr4BOvkfSBR+RdfGIJku/HViyEVZ3XMIw3nShUDQunTBDpsFzrz5
         aRyoBEUTfDYHAlXI2uXxGah6J7LAtvq+AuVvYnto=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 532/775] octeontx2-af: Fix an off by one in rvu_dbg_qsize_write()
Date:   Mon,  1 Mar 2021 17:11:40 +0100
Message-Id: <20210301161227.781752388@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit 3a2eb515d1367c0f667b76089a6e727279c688b8 ]

This code does not allocate enough memory for the NUL terminator so it
ends up putting it one character beyond the end of the buffer.

Fixes: 8756828a8148 ("octeontx2-af: Add NPA aura and pool contexts to debugfs")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c
index d27543c1a166a..bb3fdaf337519 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c
@@ -385,7 +385,7 @@ static ssize_t rvu_dbg_qsize_write(struct file *filp,
 	u16 pcifunc;
 	int ret, lf;
 
-	cmd_buf = memdup_user(buffer, count);
+	cmd_buf = memdup_user(buffer, count + 1);
 	if (IS_ERR(cmd_buf))
 		return -ENOMEM;
 
-- 
2.27.0



