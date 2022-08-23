Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 692BD59DF01
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 14:34:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359236AbiHWMFQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 08:05:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359331AbiHWMDl (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 08:03:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4431BDCFFA;
        Tue, 23 Aug 2022 02:37:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D840161467;
        Tue, 23 Aug 2022 09:37:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9B71C433D7;
        Tue, 23 Aug 2022 09:37:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661247426;
        bh=SZ+/sgtHqCsEHpNeUbek1EZlYk4KcpR5xLQujRwlQ7g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0B3Dp8DhHRTMG96pa+poYz+aID5Gr6v6dfwV6TL3ERfLr7POyDpDUlJv2ZPuUZRvg
         WJ5De3W2Hn3NzPIvRaK6kRu3Dwtt58S3yWx16LfsM+Hgmknq4lIa8bV76C3Z1PivEu
         Ym2hwU8kzYN1nhx4McQ8DSGYk7YHO6AFTqrc4XpE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hou Tao <houtao1@huawei.com>,
        Yonghong Song <yhs@fb.com>, Martin KaFai Lau <kafai@fb.com>,
        Alexei Starovoitov <ast@kernel.org>
Subject: [PATCH 5.10 031/158] bpf: Check the validity of max_rdwr_access for sock local storage map iterator
Date:   Tue, 23 Aug 2022 10:26:03 +0200
Message-Id: <20220823080047.340687367@linuxfoundation.org>
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

commit 52bd05eb7c88e1ad8541a48873188ccebca9da26 upstream.

The value of sock local storage map is writable in map iterator, so check
max_rdwr_access instead of max_rdonly_access.

Fixes: 5ce6e77c7edf ("bpf: Implement bpf iterator for sock local storage map")
Signed-off-by: Hou Tao <houtao1@huawei.com>
Acked-by: Yonghong Song <yhs@fb.com>
Acked-by: Martin KaFai Lau <kafai@fb.com>
Link: https://lore.kernel.org/r/20220810080538.1845898-6-houtao@huaweicloud.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/bpf_sk_storage.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/core/bpf_sk_storage.c
+++ b/net/core/bpf_sk_storage.c
@@ -823,7 +823,7 @@ static int bpf_iter_attach_map(struct bp
 	if (map->map_type != BPF_MAP_TYPE_SK_STORAGE)
 		goto put_map;
 
-	if (prog->aux->max_rdonly_access > map->value_size) {
+	if (prog->aux->max_rdwr_access > map->value_size) {
 		err = -EACCES;
 		goto put_map;
 	}


