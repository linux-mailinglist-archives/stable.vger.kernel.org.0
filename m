Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D2FF812C45E
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 18:29:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728726AbfL2R3G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 12:29:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:53204 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728723AbfL2R3F (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 12:29:05 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9E7EB207FD;
        Sun, 29 Dec 2019 17:29:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577640545;
        bh=FGZqi5ivswLb220n5ilqCFAaFwASW3EK/q7vSwG7bjQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pkGeM8EWWCusjjVGamKgY4+ZR2pt8r6Ihs3WCj2eUEre7vQbHWgU3IiDiF1pCOMdo
         0K27Vaox//ue+8Cfa5tiafy6fTIY/Mu2dvFPIAAl/nfng1qIdraPCgks+o3BQl7Qr8
         lnO9Tm7wtHbahROxxvb0Ge+E9vevizRbHYBai4j8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Max Gurtovoy <maxg@mellanox.com>,
        Sagi Grimberg <sagi@grimberg.me>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 038/219] IB/iser: bound protection_sg size by data_sg size
Date:   Sun, 29 Dec 2019 18:17:20 +0100
Message-Id: <20191229162514.138568292@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191229162508.458551679@linuxfoundation.org>
References: <20191229162508.458551679@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Max Gurtovoy <maxg@mellanox.com>

[ Upstream commit 7718cf03c3ce4b6ebd90107643ccd01c952a1fce ]

In case we don't set the sg_prot_tablesize, the scsi layer assign the
default size (65535 entries). We should limit this size since we should
take into consideration the underlaying device capability. This cap is
considered when calculating the sg_tablesize. Otherwise, for example,
we can get that /sys/block/sdb/queue/max_segments is 128 and
/sys/block/sdb/queue/max_integrity_segments is 65535.

Link: https://lore.kernel.org/r/1569359027-10987-1-git-send-email-maxg@mellanox.com
Signed-off-by: Max Gurtovoy <maxg@mellanox.com>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/ulp/iser/iscsi_iser.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.c b/drivers/infiniband/ulp/iser/iscsi_iser.c
index 3fecd87c9f2b..b4e0ae024575 100644
--- a/drivers/infiniband/ulp/iser/iscsi_iser.c
+++ b/drivers/infiniband/ulp/iser/iscsi_iser.c
@@ -646,6 +646,7 @@ iscsi_iser_session_create(struct iscsi_endpoint *ep,
 		if (ib_conn->pi_support) {
 			u32 sig_caps = ib_conn->device->ib_device->attrs.sig_prot_cap;
 
+			shost->sg_prot_tablesize = shost->sg_tablesize;
 			scsi_host_set_prot(shost, iser_dif_prot_caps(sig_caps));
 			scsi_host_set_guard(shost, SHOST_DIX_GUARD_IP |
 						   SHOST_DIX_GUARD_CRC);
-- 
2.20.1



