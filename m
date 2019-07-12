Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5818E66E7B
	for <lists+stable@lfdr.de>; Fri, 12 Jul 2019 14:39:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727485AbfGLM1I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Jul 2019 08:27:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:38974 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728542AbfGLM1D (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 12 Jul 2019 08:27:03 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C87C821670;
        Fri, 12 Jul 2019 12:27:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562934422;
        bh=brf5VmPedC1NgBTv6Aa4yQ1ph1WGBNQpZpbYVc0EDH0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JyT7TYvAfNiqu72CzqS3vNp1WfcURAUpptLHwXLU1wTXJMkBjqrJNVIimdBMWhvHt
         ZfL3mPtBDqCjX1FHtNcIhxmw3+KBs5CiyBCm4mdD98z3SswAHpXYE/X3tOyxZQelNo
         bgNpQ4yLnM1IYOhDNjO8Ji4KAzCb/yeO//yIxk40=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ilya Maximets <i.maximets@samsung.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 050/138] xdp: check device pointer before clearing
Date:   Fri, 12 Jul 2019 14:18:34 +0200
Message-Id: <20190712121630.584296399@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190712121628.731888964@linuxfoundation.org>
References: <20190712121628.731888964@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 01d76b5317003e019ace561a9b775f51aafdfdc4 ]

We should not call 'ndo_bpf()' or 'dev_put()' with NULL argument.

Fixes: c9b47cc1fabc ("xsk: fix bug when trying to use both copy and zero-copy on one queue id")
Signed-off-by: Ilya Maximets <i.maximets@samsung.com>
Acked-by: Jonathan Lemon <jonathan.lemon@gmail.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/xdp/xdp_umem.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/net/xdp/xdp_umem.c b/net/xdp/xdp_umem.c
index 989e52386c35..2f7e2c33a812 100644
--- a/net/xdp/xdp_umem.c
+++ b/net/xdp/xdp_umem.c
@@ -143,6 +143,9 @@ static void xdp_umem_clear_dev(struct xdp_umem *umem)
 	struct netdev_bpf bpf;
 	int err;
 
+	if (!umem->dev)
+		return;
+
 	if (umem->zc) {
 		bpf.command = XDP_SETUP_XSK_UMEM;
 		bpf.xsk.umem = NULL;
@@ -156,11 +159,9 @@ static void xdp_umem_clear_dev(struct xdp_umem *umem)
 			WARN(1, "failed to disable umem!\n");
 	}
 
-	if (umem->dev) {
-		rtnl_lock();
-		xdp_clear_umem_at_qid(umem->dev, umem->queue_id);
-		rtnl_unlock();
-	}
+	rtnl_lock();
+	xdp_clear_umem_at_qid(umem->dev, umem->queue_id);
+	rtnl_unlock();
 
 	if (umem->zc) {
 		dev_put(umem->dev);
-- 
2.20.1



