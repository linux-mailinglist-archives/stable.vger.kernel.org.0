Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFF5825995A
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 18:39:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730458AbgIAQig (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 12:38:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:57108 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730410AbgIAP2r (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Sep 2020 11:28:47 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B1DF02078B;
        Tue,  1 Sep 2020 15:28:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598974127;
        bh=EypvJmI80cOBcFHKPawHti9nNSIPxfesQkbtnpmuuts=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X2M84IN/+f47DtPEScsB3qNiocGtmaW6FqfBgfHuzbDMYC3bAA80WfcBpqzLQIEsM
         jh3xPB2nYLJjmoWefGMPkEcSchxpBYj1AmMlnxFv/rMo45Xc1QMDK8YpK+l1wr/5q4
         K74S70tutCTl1pu3n4Uzow8LJKNNGpvTLfx+AKDY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mike Christie <michael.christie@oracle.com>,
        Jing Xiangfeng <jingxiangfeng@huawei.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 054/214] scsi: iscsi: Do not put host in iscsi_set_flashnode_param()
Date:   Tue,  1 Sep 2020 17:08:54 +0200
Message-Id: <20200901150955.569709263@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200901150952.963606936@linuxfoundation.org>
References: <20200901150952.963606936@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index a5c78b38d3022..dbad926e8f87f 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -3174,7 +3174,7 @@ static int iscsi_set_flashnode_param(struct iscsi_transport *transport,
 		pr_err("%s could not find host no %u\n",
 		       __func__, ev->u.set_flashnode.host_no);
 		err = -ENODEV;
-		goto put_host;
+		goto exit_set_fnode;
 	}
 
 	idx = ev->u.set_flashnode.flashnode_idx;
-- 
2.25.1



