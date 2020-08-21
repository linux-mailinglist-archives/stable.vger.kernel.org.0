Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 355FE24DD3E
	for <lists+stable@lfdr.de>; Fri, 21 Aug 2020 19:15:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726767AbgHUROX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Aug 2020 13:14:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:50638 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728135AbgHUQQ7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Aug 2020 12:16:59 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8D4F722CB3;
        Fri, 21 Aug 2020 16:16:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598026612;
        bh=fjc4CIq2kDbcBbNQagMzB04CnvPIblrnK38smOaO7i8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WOJtdxHM8xDNb3RC3W9nIXdmn6PE4GCy0Nvkcdtd8iMr0RnJwp2JSg8daONQhmtVb
         8f55t+Id4KXtf1xD7zVBdxRIQDBqylTVV4GQVLXAHmkIKPQcT2IwoN4pMKAvpCdiln
         sgfyh6teBJv+hbJp3keqomYgi589NQcDR6giiznA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jing Xiangfeng <jingxiangfeng@huawei.com>,
        Mike Christie <michael.christie@oracle.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, open-iscsi@googlegroups.com,
        linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.7 53/61] scsi: iscsi: Do not put host in iscsi_set_flashnode_param()
Date:   Fri, 21 Aug 2020 12:15:37 -0400
Message-Id: <20200821161545.347622-53-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200821161545.347622-1-sashal@kernel.org>
References: <20200821161545.347622-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jing Xiangfeng <jingxiangfeng@huawei.com>

[ Upstream commit 68e12e5f61354eb42cfffbc20a693153fc39738e ]

If scsi_host_lookup() fails we will jump to put_host which may cause a
panic. Jump to exit_set_fnode instead.

Link: https://lore.kernel.org/r/20200615081226.183068-1-jingxiangfeng@huawei.com
Reviewed-by: Mike Christie <michael.christie@oracle.com>
Signed-off-by: Jing Xiangfeng <jingxiangfeng@huawei.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/scsi_transport_iscsi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index ea6d498fa9232..1d8359cc00e25 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -3291,7 +3291,7 @@ static int iscsi_set_flashnode_param(struct iscsi_transport *transport,
 		pr_err("%s could not find host no %u\n",
 		       __func__, ev->u.set_flashnode.host_no);
 		err = -ENODEV;
-		goto put_host;
+		goto exit_set_fnode;
 	}
 
 	idx = ev->u.set_flashnode.flashnode_idx;
-- 
2.25.1

