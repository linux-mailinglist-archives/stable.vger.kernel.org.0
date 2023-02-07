Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47AD868D754
	for <lists+stable@lfdr.de>; Tue,  7 Feb 2023 13:58:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230132AbjBGM6q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Feb 2023 07:58:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231877AbjBGM6p (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Feb 2023 07:58:45 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1ABA2BF37
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 04:58:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3C83E613F8
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 12:58:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48DD5C433D2;
        Tue,  7 Feb 2023 12:58:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675774723;
        bh=piqaHnSJYxh7AugGP78M9ygy2os1wHaUgrHIZzCTeI0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bL3IqJVJxsvzsHvXi4acZ2jp51p/KTvxpLfM/K5/LZK7cPmBB2JsHT1M5IhYCS0qC
         8PQwYBABX7Se1Umug4DJnzQhXnzQYqs+NPjAkTKnuS92ptctrNl2vgVNFdZ0ByTzwX
         YzM/7wlB21R0fhjKbbu4OTmukN00IiqelanbtHAo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Hou Tao <houtao1@huawei.com>,
        Yonghong Song <yhs@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 013/208] bpf: Fix off-by-one error in bpf_mem_cache_idx()
Date:   Tue,  7 Feb 2023 13:54:27 +0100
Message-Id: <20230207125634.936032768@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230207125634.292109991@linuxfoundation.org>
References: <20230207125634.292109991@linuxfoundation.org>
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

[ Upstream commit 36024d023d139a0c8b552dc3b7f4dc7b4c139e8f ]

According to the definition of sizes[NUM_CACHES], when the size passed
to bpf_mem_cache_size() is 256, it should return 6 instead 7.

Fixes: 7c8199e24fa0 ("bpf: Introduce any context BPF specific memory allocator.")
Signed-off-by: Hou Tao <houtao1@huawei.com>
Acked-by: Yonghong Song <yhs@fb.com>
Link: https://lore.kernel.org/r/20230118084630.3750680-1-houtao@huaweicloud.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/memalloc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/bpf/memalloc.c b/kernel/bpf/memalloc.c
index 4901fa1048cd..6187c28d266f 100644
--- a/kernel/bpf/memalloc.c
+++ b/kernel/bpf/memalloc.c
@@ -71,7 +71,7 @@ static int bpf_mem_cache_idx(size_t size)
 	if (size <= 192)
 		return size_index[(size - 1) / 8] - 1;
 
-	return fls(size - 1) - 1;
+	return fls(size - 1) - 2;
 }
 
 #define NUM_CACHES 11
-- 
2.39.0



