Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3FB78657DCA
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:47:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233606AbiL1PrD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:47:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234037AbiL1Pqm (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:46:42 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4580F167CA
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:46:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DC653B81729
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:46:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52299C433F2;
        Wed, 28 Dec 2022 15:46:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672242397;
        bh=7V6ft3lVN55IILIFGQj/INz2L50peMHXGVnsJJGkBZ4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IC3Q1ZyoPyFj7Bk0odE/nR22GyLDkKBNB2fK++ovcr32WcFk6s6uTiv3KUrs9085E
         daA0yAH8ie8qr0ph/YQNXAmcVTz0qW/8l4MQXrei9YQJCJUqoA0EmiKe2EJ3uBaBXP
         zJD72jmdIscCi+VxF9WQJoFoYLICRt2WSv505W00=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Hou Tao <houtao1@huawei.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Yonghong Song <yhs@fb.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0365/1146] bpf: Pin the start cgroup in cgroup_iter_seq_init()
Date:   Wed, 28 Dec 2022 15:31:44 +0100
Message-Id: <20221228144340.081108605@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hou Tao <houtao1@huawei.com>

[ Upstream commit 1a5160d4d8fe63ba4964cfff4a85831b6af75f2d ]

bpf_iter_attach_cgroup() has already acquired an extra reference for the
start cgroup, but the reference may be released if the iterator link fd
is closed after the creation of iterator fd, and it may lead to
user-after-free problem when reading the iterator fd.

An alternative fix is pinning iterator link when opening iterator,
but it will make iterator link being still visible after the close of
iterator link fd and the behavior is different with other link types, so
just fixing it by acquiring another reference for the start cgroup.

Fixes: d4ccaf58a847 ("bpf: Introduce cgroup iter")
Signed-off-by: Hou Tao <houtao1@huawei.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Yonghong Song <yhs@fb.com>
Link: https://lore.kernel.org/bpf/20221121073440.1828292-2-houtao@huaweicloud.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/cgroup_iter.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/kernel/bpf/cgroup_iter.c b/kernel/bpf/cgroup_iter.c
index 9fcf09f2ef00..c187a9e62bdb 100644
--- a/kernel/bpf/cgroup_iter.c
+++ b/kernel/bpf/cgroup_iter.c
@@ -164,16 +164,30 @@ static int cgroup_iter_seq_init(void *priv, struct bpf_iter_aux_info *aux)
 	struct cgroup_iter_priv *p = (struct cgroup_iter_priv *)priv;
 	struct cgroup *cgrp = aux->cgroup.start;
 
+	/* bpf_iter_attach_cgroup() has already acquired an extra reference
+	 * for the start cgroup, but the reference may be released after
+	 * cgroup_iter_seq_init(), so acquire another reference for the
+	 * start cgroup.
+	 */
 	p->start_css = &cgrp->self;
+	css_get(p->start_css);
 	p->terminate = false;
 	p->visited_all = false;
 	p->order = aux->cgroup.order;
 	return 0;
 }
 
+static void cgroup_iter_seq_fini(void *priv)
+{
+	struct cgroup_iter_priv *p = (struct cgroup_iter_priv *)priv;
+
+	css_put(p->start_css);
+}
+
 static const struct bpf_iter_seq_info cgroup_iter_seq_info = {
 	.seq_ops		= &cgroup_iter_seq_ops,
 	.init_seq_private	= cgroup_iter_seq_init,
+	.fini_seq_private	= cgroup_iter_seq_fini,
 	.seq_priv_size		= sizeof(struct cgroup_iter_priv),
 };
 
-- 
2.35.1



