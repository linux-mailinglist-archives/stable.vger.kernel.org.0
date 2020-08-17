Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC3A1246BB2
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 18:01:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387597AbgHQQA7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 12:00:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:47506 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731023AbgHQQAf (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 12:00:35 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D649020729;
        Mon, 17 Aug 2020 16:00:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597680035;
        bh=XGLUHC3M004uJQzADNk1uMu20Yuq/+igbT74y7M+Xf0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hZBfzWeYO9gjrjmtZWeRcP5ACngXaLTg1aaEFYowLIE8JCm/bbFYfbEjawhA8izuN
         OcaqnxW+mzMNmp2hTpp+g61vJIzGhl+zKgK8BYmDETAW71KvstN5668qCVhaCaq3hm
         GJdfbQellgUTsZhhJJc0uoPDZozWLRuKhN/e+2Zw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Liu Yong <pkfxxxing@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 004/270] fs/io_uring.c: Fix uninitialized variable is referenced in io_submit_sqe
Date:   Mon, 17 Aug 2020 17:13:25 +0200
Message-Id: <20200817143756.029696893@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143755.807583758@linuxfoundation.org>
References: <20200817143755.807583758@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Liu Yong <pkfxxxing@gmail.com>

the commit <a4d61e66ee4a> ("<io_uring: prevent re-read of sqe->opcode>")
caused another vulnerability. After io_get_req(), the sqe_submit struct
in req is not initialized, but the following code defaults that
req->submit.opcode is available.

Signed-off-by: Liu Yong <pkfxxxing@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/io_uring.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index be3d595a607f4..c1aaee061dae5 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2559,6 +2559,7 @@ static void io_submit_sqe(struct io_ring_ctx *ctx, struct sqe_submit *s,
 		goto err;
 	}
 
+	memcpy(&req->submit, s, sizeof(*s));
 	ret = io_req_set_file(ctx, s, state, req);
 	if (unlikely(ret)) {
 err_req:
-- 
2.25.1



