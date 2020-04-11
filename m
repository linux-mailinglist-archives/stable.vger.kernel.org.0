Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 381261A556D
	for <lists+stable@lfdr.de>; Sun, 12 Apr 2020 01:11:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729661AbgDKXKk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Apr 2020 19:10:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:49328 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729658AbgDKXKj (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Apr 2020 19:10:39 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EFD39215A4;
        Sat, 11 Apr 2020 23:10:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586646639;
        bh=iir4ia2z/AOluTWFDVeTzVpMBJS5j6/hFvhzHHABHYc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2OAJaEMVZp7qoL2y5QO4NJyb156NxSupbW+FebaenjtEveYmNe0yOwLcYKHk6Enfv
         QHrt0MY1u8c5Dk2V21YSUXEO0Lgb5HPcnWnR/A86L+S6ZFtA3zruOqrNm/9F0KkI89
         Ypyz+4iS8f+hggSIWBDbXAlXMA76YAZWYyybu1e0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kamal Heib <kamalheib1@gmail.com>,
        Gal Pressman <galpress@amazon.com>,
        Bernard Metzler <bmt@zurich.ibm.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>, linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 046/108] RDMA/siw: Fix setting active_mtu attribute
Date:   Sat, 11 Apr 2020 19:08:41 -0400
Message-Id: <20200411230943.24951-46-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200411230943.24951-1-sashal@kernel.org>
References: <20200411230943.24951-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kamal Heib <kamalheib1@gmail.com>

[ Upstream commit beb205dd67aaa4315dedf5c40b47c6e9dee5a469 ]

Make sure to set the active_mtu attribute to avoid report the following
invalid value:

$ ibv_devinfo -d siw0 | grep active_mtu
			active_mtu:		invalid MTU (0)

Fixes: 303ae1cdfdf7 ("rdma/siw: application interface")
Link: https://lore.kernel.org/r/20200205081354.30438-1-kamalheib1@gmail.com
Signed-off-by: Kamal Heib <kamalheib1@gmail.com>
Reviewed-by: Gal Pressman <galpress@amazon.com>
Reviewed-by: Bernard Metzler <bmt@zurich.ibm.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/sw/siw/siw_verbs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/sw/siw/siw_verbs.c b/drivers/infiniband/sw/siw/siw_verbs.c
index 1b1a40db529c6..73442bd57dbe8 100644
--- a/drivers/infiniband/sw/siw/siw_verbs.c
+++ b/drivers/infiniband/sw/siw/siw_verbs.c
@@ -200,12 +200,12 @@ int siw_query_port(struct ib_device *base_dev, u8 port,
 
 	memset(attr, 0, sizeof(*attr));
 
-	attr->active_mtu = attr->max_mtu;
 	attr->active_speed = 2;
 	attr->active_width = 2;
 	attr->gid_tbl_len = 1;
 	attr->max_msg_sz = -1;
 	attr->max_mtu = ib_mtu_int_to_enum(sdev->netdev->mtu);
+	attr->active_mtu = ib_mtu_int_to_enum(sdev->netdev->mtu);
 	attr->phys_state = sdev->state == IB_PORT_ACTIVE ?
 		IB_PORT_PHYS_STATE_LINK_UP : IB_PORT_PHYS_STATE_DISABLED;
 	attr->pkey_tbl_len = 1;
-- 
2.20.1

