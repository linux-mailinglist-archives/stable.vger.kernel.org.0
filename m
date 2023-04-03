Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03D9D6D47DF
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 16:24:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233170AbjDCOYI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 10:24:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233194AbjDCOX4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 10:23:56 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CA073AA2
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 07:23:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EDDB7B81BE8
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 14:23:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D459C433D2;
        Mon,  3 Apr 2023 14:23:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680531831;
        bh=dNCakp8Nrfz218k+nbc02rJFvwGlZJSyLE4Hgo3cNjk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wEaiJ/jo6wiX3uCQEanUmLd3CeJ7apWHHg3/cKCNnFWVLMRG5gdLbuiTGND+oSkKh
         Cu6HnzoKUvzxT1grZEqa2p9TE8lRrSbCWWaKjBmelsPRA47JxRENEHZwKN+HReOO+i
         0Prg3bBtbbtGcZW3zr2jvrpL128uEOWuLEZxGw/8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Kal Conley <kal.conley@dectris.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 024/173] xsk: Add missing overflow check in xdp_umem_reg
Date:   Mon,  3 Apr 2023 16:07:19 +0200
Message-Id: <20230403140415.122187473@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140414.174516815@linuxfoundation.org>
References: <20230403140414.174516815@linuxfoundation.org>
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
index 56a28a686988d..42b19feb2b6e5 100644
--- a/net/xdp/xdp_umem.c
+++ b/net/xdp/xdp_umem.c
@@ -153,10 +153,11 @@ static int xdp_umem_account_pages(struct xdp_umem *umem)
 
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
@@ -191,8 +192,8 @@ static int xdp_umem_reg(struct xdp_umem *umem, struct xdp_umem_reg *mr)
 	if (npgs > U32_MAX)
 		return -EINVAL;
 
-	chunks = (unsigned int)div_u64_rem(size, chunk_size, &chunks_rem);
-	if (chunks == 0)
+	chunks = div_u64_rem(size, chunk_size, &chunks_rem);
+	if (!chunks || chunks > U32_MAX)
 		return -EINVAL;
 
 	if (!unaligned_chunks && chunks_rem)
@@ -205,7 +206,7 @@ static int xdp_umem_reg(struct xdp_umem *umem, struct xdp_umem_reg *mr)
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



