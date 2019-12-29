Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 81FEB12C710
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 18:55:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732049AbfL2Rxa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 12:53:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:40544 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732476AbfL2Rxa (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 12:53:30 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2A347206DB;
        Sun, 29 Dec 2019 17:53:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577642009;
        bh=D/u4B5LWGmIghCZb5lG0OvNphq9rWCBj2Uw1qGjZrmk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jwL6z3CUVmTJCNekmhUAaSqUjKIjNuuZNQuP9uB/GYAdFanbraoJ4XZaVaP++Rs9M
         o1z86l64lU1vK9BSMu3fPe8zvTxwpC9eSchBiAaoie/jAxZB0OZHkCV1twadHIN0gd
         AHLUslBs3AoDNLSTp7CQvjviQ5AG0GDFlgC3dM8o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Kranzdorf <dkkranzd@amazon.com>,
        Firas JahJah <firasj@amazon.com>,
        Gal Pressman <galpress@amazon.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 304/434] RDMA/efa: Clear the admin command buffer prior to its submission
Date:   Sun, 29 Dec 2019 18:25:57 +0100
Message-Id: <20191229172722.145740585@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191229172702.393141737@linuxfoundation.org>
References: <20191229172702.393141737@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gal Pressman <galpress@amazon.com>

[ Upstream commit 64c264872b8879e2ab9017eefe9514d4c045c60e ]

We cannot rely on the entry memcpy as we only copy the actual size of the
command, the rest of the bytes must be memset to zero.

Currently providing non-zero memory will not have any user visible impact.
However, since admin commands are extendable (in a backwards compatible
way) everything beyond the size of the command must be cleared to prevent
issues in the future.

Fixes: 0420e542569b ("RDMA/efa: Implement functions that submit and complete admin commands")
Link: https://lore.kernel.org/r/20191112092608.46964-1-galpress@amazon.com
Reviewed-by: Daniel Kranzdorf <dkkranzd@amazon.com>
Reviewed-by: Firas JahJah <firasj@amazon.com>
Signed-off-by: Gal Pressman <galpress@amazon.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/efa/efa_com.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/efa/efa_com.c b/drivers/infiniband/hw/efa/efa_com.c
index 3c412bc5b94f..0778f4f7dccd 100644
--- a/drivers/infiniband/hw/efa/efa_com.c
+++ b/drivers/infiniband/hw/efa/efa_com.c
@@ -317,6 +317,7 @@ static struct efa_comp_ctx *__efa_com_submit_admin_cmd(struct efa_com_admin_queu
 						       struct efa_admin_acq_entry *comp,
 						       size_t comp_size_in_bytes)
 {
+	struct efa_admin_aq_entry *aqe;
 	struct efa_comp_ctx *comp_ctx;
 	u16 queue_size_mask;
 	u16 cmd_id;
@@ -350,7 +351,9 @@ static struct efa_comp_ctx *__efa_com_submit_admin_cmd(struct efa_com_admin_queu
 
 	reinit_completion(&comp_ctx->wait_event);
 
-	memcpy(&aq->sq.entries[pi], cmd, cmd_size_in_bytes);
+	aqe = &aq->sq.entries[pi];
+	memset(aqe, 0, sizeof(*aqe));
+	memcpy(aqe, cmd, cmd_size_in_bytes);
 
 	aq->sq.pc++;
 	atomic64_inc(&aq->stats.submitted_cmd);
-- 
2.20.1



