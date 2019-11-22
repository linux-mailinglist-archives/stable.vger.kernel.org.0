Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A7051060D7
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 06:53:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728494AbfKVFwT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 00:52:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:57890 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728476AbfKVFwQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 00:52:16 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 20C06207FA;
        Fri, 22 Nov 2019 05:52:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574401935;
        bh=xsYVwr7Zh3Sl5HxMv2r9Twf7jo7heLrCDCLKr2yFn9o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n0bbD+1Ah+xdN/HGbs77sx2+4B9RetWPdHYZUl0nFz7+G5O4TDz4M4R+9M3VVIISW
         Z89sznquYe17Dx5a3Dj9pT0u4ryIX/VdX8vU0Y4JNQZBw3USSatOKiyzQ0HpfCFsiz
         5GvUq02yxXIxwL0ioLV3pGV0QNw+CZQHj3w6gBY0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Aditya Pakki <pakki001@umn.edu>,
        Michal Kalderon <michal.kalderon@marvell.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>, linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 161/219] infiniband/qedr: Potential null ptr dereference of qp
Date:   Fri, 22 Nov 2019 00:48:13 -0500
Message-Id: <20191122054911.1750-154-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191122054911.1750-1-sashal@kernel.org>
References: <20191122054911.1750-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aditya Pakki <pakki001@umn.edu>

[ Upstream commit 9c6260de505b63638dd86fcc33849b17f6146d94 ]

idr_find() may fail and return a NULL pointer. The fix checks the return
value of the function and returns an error in case of NULL.

Signed-off-by: Aditya Pakki <pakki001@umn.edu>
Acked-by: Michal Kalderon <michal.kalderon@marvell.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/qedr/qedr_iw_cm.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/infiniband/hw/qedr/qedr_iw_cm.c b/drivers/infiniband/hw/qedr/qedr_iw_cm.c
index 505fa36487629..93b16237b7677 100644
--- a/drivers/infiniband/hw/qedr/qedr_iw_cm.c
+++ b/drivers/infiniband/hw/qedr/qedr_iw_cm.c
@@ -492,6 +492,8 @@ int qedr_iw_connect(struct iw_cm_id *cm_id, struct iw_cm_conn_param *conn_param)
 	int i;
 
 	qp = idr_find(&dev->qpidr.idr, conn_param->qpn);
+	if (unlikely(!qp))
+		return -EINVAL;
 
 	laddr = (struct sockaddr_in *)&cm_id->m_local_addr;
 	raddr = (struct sockaddr_in *)&cm_id->m_remote_addr;
-- 
2.20.1

