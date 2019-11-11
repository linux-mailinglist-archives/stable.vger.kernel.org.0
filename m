Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F36D9F7DFA
	for <lists+stable@lfdr.de>; Mon, 11 Nov 2019 20:01:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729247AbfKKSxA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 13:53:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:47576 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728500AbfKKSw6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Nov 2019 13:52:58 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DE3E120818;
        Mon, 11 Nov 2019 18:52:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573498377;
        bh=fTZoUzI/i+jvnxmLsu/vAClMnYcE6ZUOXks8Tl+koEU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R0wOlSPymLkqWn8y1iOVFytQPOgOwbeAvnNO4p9ec3VhKl9EPuFVVOzPkaJ1OeuMh
         r1AbaXjcXUmjF+CN0bp7yc9+20tFbxstsTCZ0JqlG5XMv6cz69B80j/QsaDUjhjACX
         U5qnIEaWbGYBZ/wRINk60zFwC5RxWNAZ7CdYxPT4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Krishnamraju Eraparaju <krishna2@chelsio.com>,
        Doug Ledford <dledford@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 101/193] RDMA/siw: free siw_base_qp in kref release routine
Date:   Mon, 11 Nov 2019 19:28:03 +0100
Message-Id: <20191111181508.589926499@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191111181459.850623879@linuxfoundation.org>
References: <20191111181459.850623879@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Krishnamraju Eraparaju <krishna2@chelsio.com>

[ Upstream commit e17fa5c95ef2434a08e0be217969d246d037f0c2 ]

As siw_free_qp() is the last routine to access 'siw_base_qp' structure,
freeing this structure early in siw_destroy_qp() could cause
touch-after-free issue.
Hence, moved kfree(siw_base_qp) from siw_destroy_qp() to siw_free_qp().

Fixes: 303ae1cdfdf7 ("rdma/siw: application interface")
Signed-off-by: Krishnamraju Eraparaju <krishna2@chelsio.com>
Link: https://lore.kernel.org/r/20191007104229.29412-1-krishna2@chelsio.com
Signed-off-by: Doug Ledford <dledford@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/sw/siw/siw_qp.c    | 2 ++
 drivers/infiniband/sw/siw/siw_verbs.c | 2 --
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/sw/siw/siw_qp.c b/drivers/infiniband/sw/siw/siw_qp.c
index 52d402f39df93..b4317480cee74 100644
--- a/drivers/infiniband/sw/siw/siw_qp.c
+++ b/drivers/infiniband/sw/siw/siw_qp.c
@@ -1312,6 +1312,7 @@ int siw_qp_add(struct siw_device *sdev, struct siw_qp *qp)
 void siw_free_qp(struct kref *ref)
 {
 	struct siw_qp *found, *qp = container_of(ref, struct siw_qp, ref);
+	struct siw_base_qp *siw_base_qp = to_siw_base_qp(qp->ib_qp);
 	struct siw_device *sdev = qp->sdev;
 	unsigned long flags;
 
@@ -1334,4 +1335,5 @@ void siw_free_qp(struct kref *ref)
 	atomic_dec(&sdev->num_qp);
 	siw_dbg_qp(qp, "free QP\n");
 	kfree_rcu(qp, rcu);
+	kfree(siw_base_qp);
 }
diff --git a/drivers/infiniband/sw/siw/siw_verbs.c b/drivers/infiniband/sw/siw/siw_verbs.c
index da52c90e06d48..ac08d84d84cbf 100644
--- a/drivers/infiniband/sw/siw/siw_verbs.c
+++ b/drivers/infiniband/sw/siw/siw_verbs.c
@@ -603,7 +603,6 @@ out:
 int siw_destroy_qp(struct ib_qp *base_qp, struct ib_udata *udata)
 {
 	struct siw_qp *qp = to_siw_qp(base_qp);
-	struct siw_base_qp *siw_base_qp = to_siw_base_qp(base_qp);
 	struct siw_ucontext *uctx =
 		rdma_udata_to_drv_context(udata, struct siw_ucontext,
 					  base_ucontext);
@@ -640,7 +639,6 @@ int siw_destroy_qp(struct ib_qp *base_qp, struct ib_udata *udata)
 	qp->scq = qp->rcq = NULL;
 
 	siw_qp_put(qp);
-	kfree(siw_base_qp);
 
 	return 0;
 }
-- 
2.20.1



