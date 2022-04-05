Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7DFB94F2903
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 10:23:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234365AbiDEIZC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:25:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238206AbiDEISo (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:18:44 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE136BA302;
        Tue,  5 Apr 2022 01:08:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4D5A8B81BAF;
        Tue,  5 Apr 2022 08:08:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B8E1C385A1;
        Tue,  5 Apr 2022 08:08:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649146099;
        bh=jf3wxT0LmWyKJPeckFVUUYw7JTNoIn0ajtG1nyGrJAo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0iChdktK4htOD3DysItCdFMRjNX8jGAbYiwNUztOxX4583HCU7QCLidx9DNk0ZJvl
         qfNKBcKSo7Orirl5nG+zdggdmtMo9GGtNC5Kk6iIcJRVZ1evwPEQYGhxUMVeQPE2SP
         tmmExVOj8cTTiZ+10I1G3gVtAqpDUrEqEFLV/tPE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Cheng Li <lic121@chinatelecom.cn>,
        Andrii Nakryiko <andrii@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0643/1126] libbpf: Unmap rings when umem deleted
Date:   Tue,  5 Apr 2022 09:23:10 +0200
Message-Id: <20220405070426.506318858@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
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
index edafe56664f3..32a2f5749c71 100644
--- a/tools/lib/bpf/xsk.c
+++ b/tools/lib/bpf/xsk.c
@@ -1193,12 +1193,23 @@ int xsk_socket__create(struct xsk_socket **xsk_ptr, const char *ifname,
 
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



