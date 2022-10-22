Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62A036086E6
	for <lists+stable@lfdr.de>; Sat, 22 Oct 2022 09:55:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231888AbiJVHzM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Oct 2022 03:55:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231974AbiJVHxM (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Oct 2022 03:53:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65E072CA7DD;
        Sat, 22 Oct 2022 00:46:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E9ED560BB1;
        Sat, 22 Oct 2022 07:45:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 040F3C433D7;
        Sat, 22 Oct 2022 07:45:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666424708;
        bh=X8yel3LUYWigUVRK5S1/ihrs7Lr86aKcl3MMM3hFUdY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ndJTbDHlo8/Ue8QInr1hdk59o6sWDZ80+TV6sTm97eS2WLqQUcea4NR9LTkStGzXK
         hD2VJvqa0cr3xK0a7u1uwPhz0vMf0/O01JLfU7GYWIb6YdTBlEL4Wsa+E97lHZocw+
         cZb0WQxhBlHD8qmYatomoh/Vlzwe0dM33uIoc+k4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ian Rogers <irogers@google.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 229/717] selftests/xsk: Avoid use-after-free on ctx
Date:   Sat, 22 Oct 2022 09:21:48 +0200
Message-Id: <20221022072455.624457009@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221022072415.034382448@linuxfoundation.org>
References: <20221022072415.034382448@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
 tools/lib/bpf/xsk.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/lib/bpf/xsk.c b/tools/lib/bpf/xsk.c
index 67dc010e9fe3..63954a2e213d 100644
--- a/tools/lib/bpf/xsk.c
+++ b/tools/lib/bpf/xsk.c
@@ -1228,15 +1228,15 @@ void xsk_socket__delete(struct xsk_socket *xsk)
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



