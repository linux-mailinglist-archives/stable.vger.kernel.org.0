Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 228614F37B4
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 16:22:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359469AbiDELTT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 07:19:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349184AbiDEJtZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:49:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3C31205D8;
        Tue,  5 Apr 2022 02:42:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 61090615E5;
        Tue,  5 Apr 2022 09:42:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 682FDC385A3;
        Tue,  5 Apr 2022 09:42:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649151744;
        bh=WrBVVqM10/J6lxBsgTkDsZRT45DDOW82ezoBdJUPxIM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O0I/PHvAC7/4dIWHQCHsWx3Dz8KiYKuHxsQTrAK6OtZkvfkDlDZYJC9JblBlzgQLt
         NF1ICxm6uivZ5Uub9nTgsE5QhjWn4POOyFvqD2CaoLaGdr9Mzt+0tg+Ziw8Nr1e1XY
         3biVHR+aR1JFLdEzyTosZ3oIRJsBx1yFNmvlsXpA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Cheng Li <lic121@chinatelecom.cn>,
        Andrii Nakryiko <andrii@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 525/913] libbpf: Unmap rings when umem deleted
Date:   Tue,  5 Apr 2022 09:26:27 +0200
Message-Id: <20220405070355.588417863@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070339.801210740@linuxfoundation.org>
References: <20220405070339.801210740@linuxfoundation.org>
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
index e9b619aa0cdf..a27b3141463a 100644
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



