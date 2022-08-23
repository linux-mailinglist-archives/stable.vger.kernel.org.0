Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6668B59D753
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 11:59:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344264AbiHWJpI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 05:45:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238995AbiHWJnM (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 05:43:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 796C29A98D;
        Tue, 23 Aug 2022 01:42:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5DB6F61544;
        Tue, 23 Aug 2022 08:42:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FB2DC433B5;
        Tue, 23 Aug 2022 08:42:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661244164;
        bh=jB3YNJsFdpWo6NSXnr57ykLaI5aOJvdDCj4JEpWaiYM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G3z/JtOEaQ+ic2kImswrVPV1dJBl2+M8GU0AlLn6plH4vda35QJn9Jj7jVF9FfKKP
         GrYi+c6eDPTiQSuyFIyT+NOed1ACNWA52g1fSiD0JHW7b6tU+AIMBQdXo6uXghjkvU
         XBgz7XQz39k0qTVtCgKxNAQ4y7X1OTV2LPkx+5/0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hou Tao <houtao1@huawei.com>,
        Yonghong Song <yhs@fb.com>, Martin KaFai Lau <kafai@fb.com>,
        Alexei Starovoitov <ast@kernel.org>
Subject: [PATCH 5.15 046/244] bpf: Acquire map uref in .init_seq_private for sock local storage map iterator
Date:   Tue, 23 Aug 2022 10:23:25 +0200
Message-Id: <20220823080100.596719094@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080059.091088642@linuxfoundation.org>
References: <20220823080059.091088642@linuxfoundation.org>
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

From: Hou Tao <houtao1@huawei.com>

commit 3c5f6e698b5c538bbb23cd453b22e1e4922cffd8 upstream.

bpf_iter_attach_map() acquires a map uref, and the uref may be released
before or in the middle of iterating map elements. For example, the uref
could be released in bpf_iter_detach_map() as part of
bpf_link_release(), or could be released in bpf_map_put_with_uref() as
part of bpf_map_release().

So acquiring an extra map uref in bpf_iter_init_sk_storage_map() and
releasing it in bpf_iter_fini_sk_storage_map().

Fixes: 5ce6e77c7edf ("bpf: Implement bpf iterator for sock local storage map")
Signed-off-by: Hou Tao <houtao1@huawei.com>
Acked-by: Yonghong Song <yhs@fb.com>
Acked-by: Martin KaFai Lau <kafai@fb.com>
Link: https://lore.kernel.org/r/20220810080538.1845898-4-houtao@huaweicloud.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/bpf_sk_storage.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- a/net/core/bpf_sk_storage.c
+++ b/net/core/bpf_sk_storage.c
@@ -865,10 +865,18 @@ static int bpf_iter_init_sk_storage_map(
 {
 	struct bpf_iter_seq_sk_storage_map_info *seq_info = priv_data;
 
+	bpf_map_inc_with_uref(aux->map);
 	seq_info->map = aux->map;
 	return 0;
 }
 
+static void bpf_iter_fini_sk_storage_map(void *priv_data)
+{
+	struct bpf_iter_seq_sk_storage_map_info *seq_info = priv_data;
+
+	bpf_map_put_with_uref(seq_info->map);
+}
+
 static int bpf_iter_attach_map(struct bpf_prog *prog,
 			       union bpf_iter_link_info *linfo,
 			       struct bpf_iter_aux_info *aux)
@@ -914,7 +922,7 @@ static const struct seq_operations bpf_s
 static const struct bpf_iter_seq_info iter_seq_info = {
 	.seq_ops		= &bpf_sk_storage_map_seq_ops,
 	.init_seq_private	= bpf_iter_init_sk_storage_map,
-	.fini_seq_private	= NULL,
+	.fini_seq_private	= bpf_iter_fini_sk_storage_map,
 	.seq_priv_size		= sizeof(struct bpf_iter_seq_sk_storage_map_info),
 };
 


