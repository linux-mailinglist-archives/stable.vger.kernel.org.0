Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7DEA206680
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 23:52:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388045AbgFWVnP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 17:43:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:41960 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387627AbgFWUD4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:03:56 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C60DC2137B;
        Tue, 23 Jun 2020 20:03:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592942635;
        bh=vKNoM1ApIz1lnjdBHNegq3LBINjhr/lVwMFcuHsoekE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1TEHhYfvYrPQthqmkM5Bj94vu0ksWhT3WFTSCAvazcb/GZb+y36T++aX/6KGyRw7f
         MANF3/vRV8THKuVfX4AZ7C9AY56Yl9qnRaNpODngKg3VjMmKTs2v7l//p7TRw8jIt0
         mNGQ6VjhCyb00oCXVdRG3pAYw23kCt53LCGz2agI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Mike Christie <mchristi@redhat.com>,
        Sudhakar Panneerselvam <sudhakar.panneerselvam@oracle.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 076/477] scsi: vhost: Notify TCM about the maximum sg entries supported per command
Date:   Tue, 23 Jun 2020 21:51:13 +0200
Message-Id: <20200623195411.214148222@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195407.572062007@linuxfoundation.org>
References: <20200623195407.572062007@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sudhakar Panneerselvam <sudhakar.panneerselvam@oracle.com>

[ Upstream commit 5ae6a6a915033bfee79e76e0c374d4f927909edc ]

vhost-scsi pre-allocates the maximum sg entries per command and if a
command requires more than VHOST_SCSI_PREALLOC_SGLS entries, then that
command is failed by it. This patch lets vhost communicate the max sg limit
when it registers vhost_scsi_ops with TCM. With this change, TCM would
report the max sg entries through "Block Limits" VPD page which will be
typically queried by the SCSI initiator during device discovery. By knowing
this limit, the initiator could ensure the maximum transfer length is less
than or equal to what is reported by vhost-scsi.

Link: https://lore.kernel.org/r/1590166317-953-1-git-send-email-sudhakar.panneerselvam@oracle.com
Cc: Michael S. Tsirkin <mst@redhat.com>
Cc: Jason Wang <jasowang@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Stefan Hajnoczi <stefanha@redhat.com>
Reviewed-by: Mike Christie <mchristi@redhat.com>
Signed-off-by: Sudhakar Panneerselvam <sudhakar.panneerselvam@oracle.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vhost/scsi.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
index c39952243fd32..8b104f76f3245 100644
--- a/drivers/vhost/scsi.c
+++ b/drivers/vhost/scsi.c
@@ -2280,6 +2280,7 @@ static struct configfs_attribute *vhost_scsi_wwn_attrs[] = {
 static const struct target_core_fabric_ops vhost_scsi_ops = {
 	.module				= THIS_MODULE,
 	.fabric_name			= "vhost",
+	.max_data_sg_nents		= VHOST_SCSI_PREALLOC_SGLS,
 	.tpg_get_wwn			= vhost_scsi_get_fabric_wwn,
 	.tpg_get_tag			= vhost_scsi_get_tpgt,
 	.tpg_check_demo_mode		= vhost_scsi_check_true,
-- 
2.25.1



