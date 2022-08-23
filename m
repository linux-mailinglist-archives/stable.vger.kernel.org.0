Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0D6959D401
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 10:23:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242774AbiHWISs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 04:18:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243044AbiHWIQb (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 04:16:31 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B667E26E2;
        Tue, 23 Aug 2022 01:10:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 79071B81C22;
        Tue, 23 Aug 2022 08:10:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD585C433C1;
        Tue, 23 Aug 2022 08:10:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661242253;
        bh=wE1MWHXt1CfxolFIPiBMUvia5BDn8Ipk8H0X6Ivmhrs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Soc+v4OGNdRFSB8O3hmRvr/kY9bIjtVyKvAyUzpFA9M0vUSBTteR0dQyALasRlxRp
         NQBegfRMkjrYKat7NKSuXkj2H3X+VhZ0GaopSFKWlM8FJXWxuBBkmPwFY4auYNUCN1
         /gPqZ2eONifcghmrEwcIdpYAnoo6NkQ6k3qyhlqc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hou Tao <houtao1@huawei.com>,
        Yonghong Song <yhs@fb.com>, Martin KaFai Lau <kafai@fb.com>,
        Alexei Starovoitov <ast@kernel.org>
Subject: [PATCH 5.19 066/365] bpf: Acquire map uref in .init_seq_private for sock local storage map iterator
Date:   Tue, 23 Aug 2022 09:59:27 +0200
Message-Id: <20220823080120.970254399@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080118.128342613@linuxfoundation.org>
References: <20220823080118.128342613@linuxfoundation.org>
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
@@ -875,10 +875,18 @@ static int bpf_iter_init_sk_storage_map(
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
@@ -924,7 +932,7 @@ static const struct seq_operations bpf_s
 static const struct bpf_iter_seq_info iter_seq_info = {
 	.seq_ops		= &bpf_sk_storage_map_seq_ops,
 	.init_seq_private	= bpf_iter_init_sk_storage_map,
-	.fini_seq_private	= NULL,
+	.fini_seq_private	= bpf_iter_fini_sk_storage_map,
 	.seq_priv_size		= sizeof(struct bpf_iter_seq_sk_storage_map_info),
 };
 


