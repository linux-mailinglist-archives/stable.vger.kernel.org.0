Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18EDF1C445C
	for <lists+stable@lfdr.de>; Mon,  4 May 2020 20:06:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731983AbgEDSGm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 May 2020 14:06:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:37064 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731997AbgEDSGh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 May 2020 14:06:37 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5133C2073E;
        Mon,  4 May 2020 18:06:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588615596;
        bh=23r7fieUlnC6uLKY3WsafJurncmV9INLMJ5LgJujMXY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FZjJchZBrMmA1oe1Ys2wx+Y2xDmIfDY3WmchCfEOMuhm5tG/3IGurmoRH62FMtM/i
         xCeZcnU3c4Ks08PGDQ9Hhf39BdVyTpZPk5yRY/UK3vTM3g7QTWWv2xDG5ZowiTW4qp
         tkLXzVasGuOgU4bGYN9Md7qGdEvGt7XoeAOXMbN8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xiyu Yang <xiyuyang19@fudan.edu.cn>,
        Jason Gunthorpe <jgg@mellanox.com>
Subject: [PATCH 5.6 46/73] RDMA/siw: Fix potential siw_mem refcnt leak in siw_fastreg_mr()
Date:   Mon,  4 May 2020 19:57:49 +0200
Message-Id: <20200504165508.850028018@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200504165501.781878940@linuxfoundation.org>
References: <20200504165501.781878940@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jason Gunthorpe <jgg@mellanox.com>

commit 6e051971b0e2eeb0ce7ec65d3cc8180450512d36 upstream.

siw_fastreg_mr() invokes siw_mem_id2obj(), which returns a local reference
of the siw_mem object to "mem" with increased refcnt.  When
siw_fastreg_mr() returns, "mem" becomes invalid, so the refcount should be
decreased to keep refcount balanced.

The issue happens in one error path of siw_fastreg_mr(). When "base_mr"
equals to NULL but "mem" is not NULL, the function forgets to decrease the
refcnt increased by siw_mem_id2obj() and causes a refcnt leak.

Reorganize the flow so that the goto unwind can be used as expected.

Fixes: b9be6f18cf9e ("rdma/siw: transmit path")
Link: https://lore.kernel.org/r/1586939949-69856-1-git-send-email-xiyuyang19@fudan.edu.cn
Reported-by: Xiyu Yang <xiyuyang19@fudan.edu.cn>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/infiniband/sw/siw/siw_qp_tx.c |   15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

--- a/drivers/infiniband/sw/siw/siw_qp_tx.c
+++ b/drivers/infiniband/sw/siw/siw_qp_tx.c
@@ -920,20 +920,27 @@ static int siw_fastreg_mr(struct ib_pd *
 {
 	struct ib_mr *base_mr = (struct ib_mr *)(uintptr_t)sqe->base_mr;
 	struct siw_device *sdev = to_siw_dev(pd->device);
-	struct siw_mem *mem = siw_mem_id2obj(sdev, sqe->rkey  >> 8);
+	struct siw_mem *mem;
 	int rv = 0;
 
 	siw_dbg_pd(pd, "STag 0x%08x\n", sqe->rkey);
 
-	if (unlikely(!mem || !base_mr)) {
+	if (unlikely(!base_mr)) {
 		pr_warn("siw: fastreg: STag 0x%08x unknown\n", sqe->rkey);
 		return -EINVAL;
 	}
+
 	if (unlikely(base_mr->rkey >> 8 != sqe->rkey  >> 8)) {
 		pr_warn("siw: fastreg: STag 0x%08x: bad MR\n", sqe->rkey);
-		rv = -EINVAL;
-		goto out;
+		return -EINVAL;
+	}
+
+	mem = siw_mem_id2obj(sdev, sqe->rkey  >> 8);
+	if (unlikely(!mem)) {
+		pr_warn("siw: fastreg: STag 0x%08x unknown\n", sqe->rkey);
+		return -EINVAL;
 	}
+
 	if (unlikely(mem->pd != pd)) {
 		pr_warn("siw: fastreg: PD mismatch\n");
 		rv = -EINVAL;


