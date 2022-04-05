Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFED04F33A6
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 15:21:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242938AbiDEJig (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 05:38:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243275AbiDEJIw (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:08:52 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4B9F9F6E0;
        Tue,  5 Apr 2022 01:57:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 030D8CE1C6A;
        Tue,  5 Apr 2022 08:57:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17D58C385A0;
        Tue,  5 Apr 2022 08:57:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649149070;
        bh=9+mIZFk4KMQEa6L1emFd16nfR80Y07GQTihFMe8LjcQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DuRPKiXj9wx+fvta9mi0vMW34T5Utbl//vYxw2TN/lgyTYBHsie5vNpSorMWSmoJI
         YFvXN2YLvermi5+mQN6QQNypsPbLxasvbeDtrvWnSpRyspLgkEk4cnOLWQn4tcymvz
         6DFqIGJrK8lzTuLekPc5b77UDq1C9aR5fJAFvHNs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Cheng Li <lic121@chinatelecom.cn>,
        Andrii Nakryiko <andrii@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0582/1017] libbpf: Unmap rings when umem deleted
Date:   Tue,  5 Apr 2022 09:24:55 +0200
Message-Id: <20220405070411.555633168@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070354.155796697@linuxfoundation.org>
References: <20220405070354.155796697@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: lic121 <lic121@chinatelecom.cn>

[ Upstream commit 9c6e6a80ee741adf6cb3cfd8eef7d1554f91fceb ]

xsk_umem__create() does mmap for fill/comp rings, but xsk_umem__delete()
doesn't do the unmap. This works fine for regular cases, because
xsk_socket__delete() does unmap for the rings. But for the case that
xsk_socket__create_shared() fails, umem rings are not unmapped.

fill_save/comp_save are checked to determine if rings have already be
unmapped by xsk. If fill_save and comp_save are NULL, it means that the
rings have already been used by xsk. Then they are supposed to be
unmapped by xsk_socket__delete(). Otherwise, xsk_umem__delete() does the
unmap.

Fixes: 2f6324a3937f ("libbpf: Support shared umems between queues and devices")
Signed-off-by: Cheng Li <lic121@chinatelecom.cn>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20220301132623.GA19995@vscode.7~
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/xsk.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/tools/lib/bpf/xsk.c b/tools/lib/bpf/xsk.c
index 81f8fbc85e70..c43b4d94346d 100644
--- a/tools/lib/bpf/xsk.c
+++ b/tools/lib/bpf/xsk.c
@@ -1210,12 +1210,23 @@ int xsk_socket__create(struct xsk_socket **xsk_ptr, const char *ifname,
 
 int xsk_umem__delete(struct xsk_umem *umem)
 {
+	struct xdp_mmap_offsets off;
+	int err;
+
 	if (!umem)
 		return 0;
 
 	if (umem->refcount)
 		return -EBUSY;
 
+	err = xsk_get_mmap_offsets(umem->fd, &off);
+	if (!err && umem->fill_save && umem->comp_save) {
+		munmap(umem->fill_save->ring - off.fr.desc,
+		       off.fr.desc + umem->config.fill_size * sizeof(__u64));
+		munmap(umem->comp_save->ring - off.cr.desc,
+		       off.cr.desc + umem->config.comp_size * sizeof(__u64));
+	}
+
 	close(umem->fd);
 	free(umem);
 
-- 
2.34.1



