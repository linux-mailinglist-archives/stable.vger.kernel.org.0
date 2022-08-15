Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E86E359494A
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 02:11:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354158AbiHOXnl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 19:43:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354341AbiHOXlz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 19:41:55 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 134032CC81;
        Mon, 15 Aug 2022 13:13:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C9997B80EA8;
        Mon, 15 Aug 2022 20:12:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EA18C433D6;
        Mon, 15 Aug 2022 20:12:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660594378;
        bh=YcUUB4RedbZ+lubJgf+hTcDCMOcGMS1Aj3kO+WeMkUI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qC8NMKNDCdfDzOX7eT97IqQs7gckwxOHXo/H+m1puFaRKUOyuiEIKX5Z4OBdY/tVj
         KDMQ3spl2+f8qhdQ1i9520rRUPfdL9gT8SdSG4RGq3sgb2FrCsO00qUa1rBzBn1Oom
         BSf0ryBpJAIwdxzaHTXcolSw6Znf2wRk/sk6oJF0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0427/1157] selftests/xsk: Destroy BPF resources only when ctx refcount drops to 0
Date:   Mon, 15 Aug 2022 19:56:23 +0200
Message-Id: <20220815180456.742270917@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>

[ Upstream commit 39e940d4abfabb08b6937a315546b24d10be67e3 ]

Currently, xsk_socket__delete frees BPF resources regardless of ctx
refcount. Xdpxceiver has a test to verify whether underlying BPF
resources would not be wiped out after closing XSK socket that was
bound to interface with other active sockets. From library's xsk part
perspective it also means that the internal xsk context is shared and
its refcount is bumped accordingly.

After a switch to loading XDP prog based on previously opened XSK
socket, mentioned xdpxceiver test fails with:

  not ok 16 [xdpxceiver.c:swap_xsk_resources:1334]: ERROR: 9/"Bad file descriptor

which means that in swap_xsk_resources(), xsk_socket__delete() released
xskmap which in turn caused a failure of xsk_socket__update_xskmap().

To fix this, when deleting socket, decrement ctx refcount before
releasing BPF resources and do so only when refcount dropped to 0 which
means there are no more active sockets for this ctx so BPF resources can
be freed safely.

Fixes: 2f6324a3937f ("libbpf: Support shared umems between queues and devices")
Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Magnus Karlsson <magnus.karlsson@intel.com>
Link: https://lore.kernel.org/bpf/20220629143458.934337-5-maciej.fijalkowski@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/xsk.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/tools/lib/bpf/xsk.c b/tools/lib/bpf/xsk.c
index af136f73b09d..67dc010e9fe3 100644
--- a/tools/lib/bpf/xsk.c
+++ b/tools/lib/bpf/xsk.c
@@ -1147,8 +1147,6 @@ int xsk_socket__create_shared(struct xsk_socket **xsk_ptr,
 		goto out_mmap_tx;
 	}
 
-	ctx->prog_fd = -1;
-
 	if (!(xsk->config.libbpf_flags & XSK_LIBBPF_FLAGS__INHIBIT_PROG_LOAD)) {
 		err = __xsk_setup_xdp_prog(xsk, NULL);
 		if (err)
@@ -1229,7 +1227,10 @@ void xsk_socket__delete(struct xsk_socket *xsk)
 
 	ctx = xsk->ctx;
 	umem = ctx->umem;
-	if (ctx->prog_fd != -1) {
+
+	xsk_put_ctx(ctx, true);
+
+	if (!ctx->refcount) {
 		xsk_delete_bpf_maps(xsk);
 		close(ctx->prog_fd);
 		if (ctx->has_bpf_link)
@@ -1248,8 +1249,6 @@ void xsk_socket__delete(struct xsk_socket *xsk)
 		}
 	}
 
-	xsk_put_ctx(ctx, true);
-
 	umem->refcount--;
 	/* Do not close an fd that also has an associated umem connected
 	 * to it.
-- 
2.35.1



