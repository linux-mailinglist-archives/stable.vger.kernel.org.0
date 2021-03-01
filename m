Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08180328F74
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 20:54:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236504AbhCATv5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 14:51:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:53652 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241800AbhCATmx (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:42:53 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B04E265059;
        Mon,  1 Mar 2021 17:23:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614619402;
        bh=EO+8u2DxYYrNicYfK2R+0Q76c4AZJtVdWi3S8dv55iE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RHSZOMveUo5LPXCkMXR6a8sjXULca0G+Fypb0pMwiAqbIY+iPpSXOhJ/6BNTGwsyR
         C7GducSIDEqgsB2fpQtqaun07hC1pRqxfZT5xyy4IO6zQSa9MemrQY/uBZeolBlMqn
         4M4z164MkfVcWGFZEK9ANWsENdWCyFuwq0BmvqaA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 442/663] octeontx2-af: Fix an off by one in rvu_dbg_qsize_write()
Date:   Mon,  1 Mar 2021 17:11:30 +0100
Message-Id: <20210301161203.768226053@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161141.760350206@linuxfoundation.org>
References: <20210301161141.760350206@linuxfoundation.org>
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
index 77adad4adb1bc..809f50ab0432e 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c
@@ -332,7 +332,7 @@ static ssize_t rvu_dbg_qsize_write(struct file *filp,
 	u16 pcifunc;
 	int ret, lf;
 
-	cmd_buf = memdup_user(buffer, count);
+	cmd_buf = memdup_user(buffer, count + 1);
 	if (IS_ERR(cmd_buf))
 		return -ENOMEM;
 
-- 
2.27.0



