Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C2B42E40BF
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:57:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439904AbgL1OQZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:16:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:50956 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2440891AbgL1OQI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:16:08 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 25BAE229C6;
        Mon, 28 Dec 2020 14:15:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609164952;
        bh=vikSt3Bw0mkI1ByoomZ68YX/U833cSLaAk6T2rIPBjw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MO1yxwdLe3ZeTibjhT136uMEaJaCXR1+B2Q1x86PcGzSFCcjvyCIPbz6jEFR9CzLg
         GgoPQneKnQGkAt2FrzBgLdQswQCJJY/UXvOrgrWll5BYto94dOa1JSpWMG8btZ86JN
         aY4Ban8VwNPtMAQXwA4SVlBNxPFZwOzh8AxoDcw0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Mike Christie <michael.christie@oracle.com>,
        Qinglang Miao <miaoqinglang@huawei.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 358/717] scsi: iscsi: Fix inappropriate use of put_device()
Date:   Mon, 28 Dec 2020 13:45:56 +0100
Message-Id: <20201228125038.163858685@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qinglang Miao <miaoqinglang@huawei.com>

[ Upstream commit 6dc1c7ab6f047f45b62986ffebc5324e86ed5f5a ]

kfree(conn) is called inside put_device(&conn->dev) which could lead to
use-after-free. In addition, device_unregister() should be used here rather
than put_deviceO().

Link: https://lore.kernel.org/r/20201120074852.31658-1-miaoqinglang@huawei.com
Fixes: f3c893e3dbb5 ("scsi: iscsi: Fail session and connection on transport registration failure")
Reported-by: Hulk Robot <hulkci@huawei.com>
Reviewed-by: Mike Christie <michael.christie@oracle.com>
Signed-off-by: Qinglang Miao <miaoqinglang@huawei.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/scsi_transport_iscsi.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index 2eb3e4f9375a5..2e68c0a876986 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -2313,7 +2313,9 @@ iscsi_create_conn(struct iscsi_cls_session *session, int dd_size, uint32_t cid)
 	return conn;
 
 release_conn_ref:
-	put_device(&conn->dev);
+	device_unregister(&conn->dev);
+	put_device(&session->dev);
+	return NULL;
 release_parent_ref:
 	put_device(&session->dev);
 free_conn:
-- 
2.27.0



