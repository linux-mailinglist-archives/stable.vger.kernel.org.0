Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 96C2F46980
	for <lists+stable@lfdr.de>; Fri, 14 Jun 2019 22:33:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726838AbfFNUab (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Jun 2019 16:30:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:53488 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727702AbfFNUab (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Jun 2019 16:30:31 -0400
Received: from sasha-vm.mshome.net (unknown [131.107.159.134])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5F26F21850;
        Fri, 14 Jun 2019 20:30:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560544230;
        bh=t/QL7rQQS81BCKNxb3aP6y6xDLkPzYik+JuAG6nPLHQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LMZZ9/8gCAx+hXuONTp90pUH88XH9bj6gBWc8fyum0P6xkpD6X/q0ivVoaKKiGTO4
         oyNOlp/y9lB/IKtepRchqQJLFdfz77b5ZmiWOufvLzHRmXfWn0iEll23I5XixRmAx1
         bZ/9IH8P1cbyn4LVwonoshbB3aYUDccNlhCvIt4o=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Gen Zhang <blackgod016574@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, sparclinux@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 14/27] mdesc: fix a missing-check bug in get_vdev_port_node_info()
Date:   Fri, 14 Jun 2019 16:30:03 -0400
Message-Id: <20190614203018.27686-14-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190614203018.27686-1-sashal@kernel.org>
References: <20190614203018.27686-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gen Zhang <blackgod016574@gmail.com>

[ Upstream commit 80caf43549e7e41a695c6d1e11066286538b336f ]

In get_vdev_port_node_info(), 'node_info->vdev_port.name' is allcoated
by kstrdup_const(), and it returns NULL when fails. So
'node_info->vdev_port.name' should be checked.

Signed-off-by: Gen Zhang <blackgod016574@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/sparc/kernel/mdesc.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/sparc/kernel/mdesc.c b/arch/sparc/kernel/mdesc.c
index 1ef6156b1530..8f24f3d60b8c 100644
--- a/arch/sparc/kernel/mdesc.c
+++ b/arch/sparc/kernel/mdesc.c
@@ -355,6 +355,8 @@ static int get_vdev_port_node_info(struct mdesc_handle *md, u64 node,
 
 	node_info->vdev_port.id = *idp;
 	node_info->vdev_port.name = kstrdup_const(name, GFP_KERNEL);
+	if (!node_info->vdev_port.name)
+		return -1;
 	node_info->vdev_port.parent_cfg_hdl = *parent_cfg_hdlp;
 
 	return 0;
-- 
2.20.1

