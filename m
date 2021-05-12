Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E59DE37CEA5
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 19:22:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345082AbhELRGC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 13:06:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:46968 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236860AbhELQsX (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:48:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 00C4261E83;
        Wed, 12 May 2021 16:15:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620836150;
        bh=SNDeB7Z6P2MY6QJujyykjpUFebnKf0w2LNOHf3T2JXw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aRCYMYN8TeasuQy8kyqikV5pEIweNsjcHKgYHfgl2uZRY5SGNCKaGEknhia7RETob
         QwTChvnpDHpp5a9nvF3FkdtQW5GdNrVMGUKzaEs8zCV6Y/pggac/2mBrxapzBWTGXS
         59hdtfnqNYwaz8GQfM0E+i4hdwtGEHSIj+54lzH8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Potnuri Bharat Teja <bharat@chelsio.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 603/677] RDMA/cxgb4: add missing qpid increment
Date:   Wed, 12 May 2021 16:50:49 +0200
Message-Id: <20210512144857.397661979@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144837.204217980@linuxfoundation.org>
References: <20210512144837.204217980@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Potnuri Bharat Teja <bharat@chelsio.com>

[ Upstream commit 3a6684385928d00b29acac7658a5ae1f2a44494c ]

missing qpid increment leads to skipping few qpids while allocating QP.
This eventually leads to adapter running out of qpids after establishing
fewer connections than it actually supports.
Current patch increments the qpid correctly.

Fixes: cfdda9d76436 ("RDMA/cxgb4: Add driver for Chelsio T4 RNIC")
Link: https://lore.kernel.org/r/20210415151422.9139-1-bharat@chelsio.com
Signed-off-by: Potnuri Bharat Teja <bharat@chelsio.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/cxgb4/resource.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/cxgb4/resource.c b/drivers/infiniband/hw/cxgb4/resource.c
index 5c95c789f302..e800e8e8bed5 100644
--- a/drivers/infiniband/hw/cxgb4/resource.c
+++ b/drivers/infiniband/hw/cxgb4/resource.c
@@ -216,7 +216,7 @@ u32 c4iw_get_qpid(struct c4iw_rdev *rdev, struct c4iw_dev_ucontext *uctx)
 			goto out;
 		entry->qid = qid;
 		list_add_tail(&entry->entry, &uctx->cqids);
-		for (i = qid; i & rdev->qpmask; i++) {
+		for (i = qid + 1; i & rdev->qpmask; i++) {
 			entry = kmalloc(sizeof(*entry), GFP_KERNEL);
 			if (!entry)
 				goto out;
-- 
2.30.2



