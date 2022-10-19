Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA46E60485D
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 15:56:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232988AbiJSN4K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 09:56:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233741AbiJSNxS (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 09:53:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31164115401;
        Wed, 19 Oct 2022 06:36:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E1153B82385;
        Wed, 19 Oct 2022 08:50:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D594C433D6;
        Wed, 19 Oct 2022 08:50:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666169410;
        bh=fzYPWcBxAX/2ERexkBxL7ZPO3pSxG7BbIQ7qi2LD/8M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qV/rN+La5L8aE4pRe+fEaNeOYKFwEWJBnUbDs2ZxkZTlxdEL7nfUtKVyM02v4WRuy
         D4Nl3f8zv6UlhwxbkkmPqWSlhB/7dlF34UBzujgmalc0XINp6OtrGlaXdXdU817FG3
         h9j36gozf28NMPk0WKgQ2R8a1enjvqzeEAgXLimM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ian Rogers <irogers@google.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 265/862] selftests/xsk: Avoid use-after-free on ctx
Date:   Wed, 19 Oct 2022 10:25:52 +0200
Message-Id: <20221019083301.736032033@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ian Rogers <irogers@google.com>

[ Upstream commit af515a5587b8f45f19e11657746e0c89411b0380 ]

The put lowers the reference count to 0 and frees ctx, reading it
afterwards is invalid. Move the put after the uses and determine the
last use by the reference count being 1.

Fixes: 39e940d4abfa ("selftests/xsk: Destroy BPF resources only when ctx refcount drops to 0")
Signed-off-by: Ian Rogers <irogers@google.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Magnus Karlsson <magnus.karlsson@intel.com>
Link: https://lore.kernel.org/bpf/20220901202645.1463552-1-irogers@google.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/xsk.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/bpf/xsk.c b/tools/testing/selftests/bpf/xsk.c
index f2721a4ae7c5..0b3ff49c740d 100644
--- a/tools/testing/selftests/bpf/xsk.c
+++ b/tools/testing/selftests/bpf/xsk.c
@@ -1237,15 +1237,15 @@ void xsk_socket__delete(struct xsk_socket *xsk)
 	ctx = xsk->ctx;
 	umem = ctx->umem;
 
-	xsk_put_ctx(ctx, true);
-
-	if (!ctx->refcount) {
+	if (ctx->refcount == 1) {
 		xsk_delete_bpf_maps(xsk);
 		close(ctx->prog_fd);
 		if (ctx->has_bpf_link)
 			close(ctx->link_fd);
 	}
 
+	xsk_put_ctx(ctx, true);
+
 	err = xsk_get_mmap_offsets(xsk->fd, &off);
 	if (!err) {
 		if (xsk->rx) {
-- 
2.35.1



