Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BCF531A59A3
	for <lists+stable@lfdr.de>; Sun, 12 Apr 2020 01:38:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729280AbgDKXhu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Apr 2020 19:37:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:44728 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728854AbgDKXIK (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Apr 2020 19:08:10 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0211E20787;
        Sat, 11 Apr 2020 23:08:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586646490;
        bh=LeyaTYKxpORf7ZS6ASE8OJ1GWvWNJ3cPcC6qzGVijj0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cnMJJrh76KnongLdvhFutzxGoLFdq0g4SyMiq0NFfQzPDxqQC5QpcwW1zjYQ8G0CH
         4z/S2g+hNMoGFm+m3wyxp2fSSRdf7LSzDG5wIdWSbOgZEUwZAmateVQyWYfO/3vk/y
         yHzLL2VlgDeBQY8mWr6qZ9F4sKYF1VX7x043hgvk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kamal Heib <kamalheib1@gmail.com>,
        Gal Pressman <galpress@amazon.com>,
        Bernard Metzler <bmt@zurich.ibm.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>, linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 5.5 054/121] RDMA/siw: Fix setting active_mtu attribute
Date:   Sat, 11 Apr 2020 19:05:59 -0400
Message-Id: <20200411230706.23855-54-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200411230706.23855-1-sashal@kernel.org>
References: <20200411230706.23855-1-sashal@kernel.org>
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
index 5fd6d6499b3d7..b8e6faecc52d3 100644
--- a/drivers/infiniband/sw/siw/siw_verbs.c
+++ b/drivers/infiniband/sw/siw/siw_verbs.c
@@ -168,12 +168,12 @@ int siw_query_port(struct ib_device *base_dev, u8 port,
 
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

