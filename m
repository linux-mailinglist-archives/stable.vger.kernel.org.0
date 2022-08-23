Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B640C59DED8
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 14:33:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352154AbiHWMD5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 08:03:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358941AbiHWMDI (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 08:03:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18BD8DC5E9;
        Tue, 23 Aug 2022 02:37:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B8A08613CA;
        Tue, 23 Aug 2022 09:37:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD2A2C433C1;
        Tue, 23 Aug 2022 09:36:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661247420;
        bh=bzyo+BAZUaNzG/Esy2DXbEuHJ1wI5aKBPt+mEZCgAv8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LI2qC+j0iYrHWOSSJjntxnQB9ZhQ3bVHrDfNnFqyHpBeXmKv3j8lEc+IxOFCaF9k+
         LpxJA69+WaUN7rgYW2TSRvZGC4DGIixpfVbThWd+VWMO7MnSZ5QOLLFxEr5tI/WxCw
         GIA/qtUVvgI+J5B875/8+0sAegpAoZ17T6P1MVuM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hou Tao <houtao1@huawei.com>,
        Yonghong Song <yhs@fb.com>, Alexei Starovoitov <ast@kernel.org>
Subject: [PATCH 5.10 030/158] bpf: Acquire map uref in .init_seq_private for sock{map,hash} iterator
Date:   Tue, 23 Aug 2022 10:26:02 +0200
Message-Id: <20220823080047.305143400@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080046.056825146@linuxfoundation.org>
References: <20220823080046.056825146@linuxfoundation.org>
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

commit f0d2b2716d71778d0b0c8eaa433c073287d69d93 upstream.

sock_map_iter_attach_target() acquires a map uref, and the uref may be
released before or in the middle of iterating map elements. For example,
the uref could be released in sock_map_iter_detach_target() as part of
bpf_link_release(), or could be released in bpf_map_put_with_uref() as
part of bpf_map_release().

Fixing it by acquiring an extra map uref in .init_seq_private and
releasing it in .fini_seq_private.

Fixes: 0365351524d7 ("net: Allow iterating sockmap and sockhash")
Signed-off-by: Hou Tao <houtao1@huawei.com>
Acked-by: Yonghong Song <yhs@fb.com>
Link: https://lore.kernel.org/r/20220810080538.1845898-5-houtao@huaweicloud.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/sock_map.c |   20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

--- a/net/core/sock_map.c
+++ b/net/core/sock_map.c
@@ -815,13 +815,22 @@ static int sock_map_init_seq_private(voi
 {
 	struct sock_map_seq_info *info = priv_data;
 
+	bpf_map_inc_with_uref(aux->map);
 	info->map = aux->map;
 	return 0;
 }
 
+static void sock_map_fini_seq_private(void *priv_data)
+{
+	struct sock_map_seq_info *info = priv_data;
+
+	bpf_map_put_with_uref(info->map);
+}
+
 static const struct bpf_iter_seq_info sock_map_iter_seq_info = {
 	.seq_ops		= &sock_map_seq_ops,
 	.init_seq_private	= sock_map_init_seq_private,
+	.fini_seq_private	= sock_map_fini_seq_private,
 	.seq_priv_size		= sizeof(struct sock_map_seq_info),
 };
 
@@ -1422,18 +1431,27 @@ static const struct seq_operations sock_
 };
 
 static int sock_hash_init_seq_private(void *priv_data,
-				     struct bpf_iter_aux_info *aux)
+				      struct bpf_iter_aux_info *aux)
 {
 	struct sock_hash_seq_info *info = priv_data;
 
+	bpf_map_inc_with_uref(aux->map);
 	info->map = aux->map;
 	info->htab = container_of(aux->map, struct bpf_shtab, map);
 	return 0;
 }
 
+static void sock_hash_fini_seq_private(void *priv_data)
+{
+	struct sock_hash_seq_info *info = priv_data;
+
+	bpf_map_put_with_uref(info->map);
+}
+
 static const struct bpf_iter_seq_info sock_hash_iter_seq_info = {
 	.seq_ops		= &sock_hash_seq_ops,
 	.init_seq_private	= sock_hash_init_seq_private,
+	.fini_seq_private	= sock_hash_fini_seq_private,
 	.seq_priv_size		= sizeof(struct sock_hash_seq_info),
 };
 


