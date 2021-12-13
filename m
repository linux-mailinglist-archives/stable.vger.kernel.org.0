Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A64047256C
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 10:43:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234768AbhLMJnn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 04:43:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234714AbhLMJkx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 04:40:53 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92868C08E750;
        Mon, 13 Dec 2021 01:39:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 16EB6CE0E8B;
        Mon, 13 Dec 2021 09:39:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8D39C341C8;
        Mon, 13 Dec 2021 09:39:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639388349;
        bh=Cjl9558Twm2F1zWNTCl+x3fwFWrRuwgvzOzv3Ei1jic=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=e17nh0f8NoSe0ezITKlUwTF+1olBgkYA8X8GHIGLy3vgaGff2WSQa5ICLaP9f/83t
         JlTCq4ZeHyAtzbfz61UeHYdqwi5gRDBsVxZiyR8Mv8Z3KcRCLClF935uDSuND/BRdh
         Yu0cbkLJofwbMGCP7oFGIPStrdTyYwXuSoW/+H3o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jianglei Nie <niejianglei2021@163.com>,
        Simon Horman <simon.horman@corigine.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 4.19 19/74] nfp: Fix memory leak in nfp_cpp_area_cache_add()
Date:   Mon, 13 Dec 2021 10:29:50 +0100
Message-Id: <20211213092931.435730117@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211213092930.763200615@linuxfoundation.org>
References: <20211213092930.763200615@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jianglei Nie <niejianglei2021@163.com>

commit c56c96303e9289cc34716b1179597b6f470833de upstream.

In line 800 (#1), nfp_cpp_area_alloc() allocates and initializes a
CPP area structure. But in line 807 (#2), when the cache is allocated
failed, this CPP area structure is not freed, which will result in
memory leak.

We can fix it by freeing the CPP area when the cache is allocated
failed (#2).

792 int nfp_cpp_area_cache_add(struct nfp_cpp *cpp, size_t size)
793 {
794 	struct nfp_cpp_area_cache *cache;
795 	struct nfp_cpp_area *area;

800	area = nfp_cpp_area_alloc(cpp, NFP_CPP_ID(7, NFP_CPP_ACTION_RW, 0),
801 				  0, size);
	// #1: allocates and initializes

802 	if (!area)
803 		return -ENOMEM;

805 	cache = kzalloc(sizeof(*cache), GFP_KERNEL);
806 	if (!cache)
807 		return -ENOMEM; // #2: missing free

817	return 0;
818 }

Fixes: 4cb584e0ee7d ("nfp: add CPP access core")
Signed-off-by: Jianglei Nie <niejianglei2021@163.com>
Acked-by: Simon Horman <simon.horman@corigine.com>
Link: https://lore.kernel.org/r/20211209061511.122535-1-niejianglei2021@163.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/netronome/nfp/nfpcore/nfp_cppcore.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_cppcore.c
+++ b/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_cppcore.c
@@ -803,8 +803,10 @@ int nfp_cpp_area_cache_add(struct nfp_cp
 		return -ENOMEM;
 
 	cache = kzalloc(sizeof(*cache), GFP_KERNEL);
-	if (!cache)
+	if (!cache) {
+		nfp_cpp_area_free(area);
 		return -ENOMEM;
+	}
 
 	cache->id = 0;
 	cache->addr = 0;


