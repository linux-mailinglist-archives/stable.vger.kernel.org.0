Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61F466CC4B0
	for <lists+stable@lfdr.de>; Tue, 28 Mar 2023 17:07:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233889AbjC1PH1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Mar 2023 11:07:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233888AbjC1PH0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Mar 2023 11:07:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCE60EC46
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 08:06:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EE2F761866
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 15:06:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CBA4C433D2;
        Tue, 28 Mar 2023 15:06:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680015977;
        bh=sGnIvYdELQv5V2VLnwd8QUZMto+EbJO+GNc7pHQqWVw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UN6vp3HhwgGbkMJbrtED2DGZfV4pVfXtU4UNNVr7qTnu04h1oBecI5Sg+owlaXIYx
         PyXx7IcqoYxJuMBGh1vxY7muJYCvx+NwnJga6k+IkjcWfv6th1tg+msU29JEG9XQX9
         7jcuo/2y4gqjZnAjLp+2JJpPOWiVNu/zoJxhAZCo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Kal Conley <kal.conley@dectris.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 020/146] xsk: Add missing overflow check in xdp_umem_reg
Date:   Tue, 28 Mar 2023 16:41:49 +0200
Message-Id: <20230328142603.565651287@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230328142602.660084725@linuxfoundation.org>
References: <20230328142602.660084725@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kal Conley <kal.conley@dectris.com>

[ Upstream commit c7df4813b149362248d6ef7be41a311e27bf75fe ]

The number of chunks can overflow u32. Make sure to return -EINVAL on
overflow. Also remove a redundant u32 cast assigning umem->npgs.

Fixes: bbff2f321a86 ("xsk: new descriptor addressing scheme")
Signed-off-by: Kal Conley <kal.conley@dectris.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Magnus Karlsson <magnus.karlsson@intel.com>
Link: https://lore.kernel.org/bpf/20230308174013.1114745-1-kal.conley@dectris.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/xdp/xdp_umem.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/net/xdp/xdp_umem.c b/net/xdp/xdp_umem.c
index f01ef6bda3909..65f918d29531d 100644
--- a/net/xdp/xdp_umem.c
+++ b/net/xdp/xdp_umem.c
@@ -152,10 +152,11 @@ static int xdp_umem_account_pages(struct xdp_umem *umem)
 
 static int xdp_umem_reg(struct xdp_umem *umem, struct xdp_umem_reg *mr)
 {
-	u32 npgs_rem, chunk_size = mr->chunk_size, headroom = mr->headroom;
 	bool unaligned_chunks = mr->flags & XDP_UMEM_UNALIGNED_CHUNK_FLAG;
-	u64 npgs, addr = mr->addr, size = mr->len;
-	unsigned int chunks, chunks_rem;
+	u32 chunk_size = mr->chunk_size, headroom = mr->headroom;
+	u64 addr = mr->addr, size = mr->len;
+	u32 chunks_rem, npgs_rem;
+	u64 chunks, npgs;
 	int err;
 
 	if (chunk_size < XDP_UMEM_MIN_CHUNK_SIZE || chunk_size > PAGE_SIZE) {
@@ -190,8 +191,8 @@ static int xdp_umem_reg(struct xdp_umem *umem, struct xdp_umem_reg *mr)
 	if (npgs > U32_MAX)
 		return -EINVAL;
 
-	chunks = (unsigned int)div_u64_rem(size, chunk_size, &chunks_rem);
-	if (chunks == 0)
+	chunks = div_u64_rem(size, chunk_size, &chunks_rem);
+	if (!chunks || chunks > U32_MAX)
 		return -EINVAL;
 
 	if (!unaligned_chunks && chunks_rem)
@@ -204,7 +205,7 @@ static int xdp_umem_reg(struct xdp_umem *umem, struct xdp_umem_reg *mr)
 	umem->headroom = headroom;
 	umem->chunk_size = chunk_size;
 	umem->chunks = chunks;
-	umem->npgs = (u32)npgs;
+	umem->npgs = npgs;
 	umem->pgs = NULL;
 	umem->user = NULL;
 	umem->flags = mr->flags;
-- 
2.39.2



