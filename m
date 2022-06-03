Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01EAF53CF71
	for <lists+stable@lfdr.de>; Fri,  3 Jun 2022 19:55:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345248AbiFCRxN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Jun 2022 13:53:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346493AbiFCRvN (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Jun 2022 13:51:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DDDA5401D;
        Fri,  3 Jun 2022 10:48:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BB3EC604EF;
        Fri,  3 Jun 2022 17:48:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBE43C385B8;
        Fri,  3 Jun 2022 17:48:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654278505;
        bh=kN0AN2TNyRTIymjPqzTViSmge+OvDBcFe42A1QKtWv8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=h259kxfL0y/1tng/akEao4zN33LBygStLc/I0vkMq34DkpcJ9PRV2nfyNxBw1tRG5
         cTpwX0Rj9wO6+p/Nb+LWRuC04RjUdF1HN/RZ5gYyQZY+5ipr9eX82Tao9o4nqC6s+2
         HCADGxmm07eFFb+NZPvUnEk4jaVvjsZDd+tkR8x4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Liu Jian <liujian56@huawei.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Song Liu <songliubraving@fb.com>
Subject: [PATCH 5.10 53/53] bpf: Enlarge offset check value to INT_MAX in bpf_skb_{load,store}_bytes
Date:   Fri,  3 Jun 2022 19:43:38 +0200
Message-Id: <20220603173820.259753943@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220603173818.716010877@linuxfoundation.org>
References: <20220603173818.716010877@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Liu Jian <liujian56@huawei.com>

commit 45969b4152c1752089351cd6836a42a566d49bcf upstream.

The data length of skb frags + frag_list may be greater than 0xffff, and
skb_header_pointer can not handle negative offset. So, here INT_MAX is used
to check the validity of offset. Add the same change to the related function
skb_store_bytes.

Fixes: 05c74e5e53f6 ("bpf: add bpf_skb_load_bytes helper")
Signed-off-by: Liu Jian <liujian56@huawei.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Song Liu <songliubraving@fb.com>
Link: https://lore.kernel.org/bpf/20220416105801.88708-2-liujian56@huawei.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/filter.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -1687,7 +1687,7 @@ BPF_CALL_5(bpf_skb_store_bytes, struct s
 
 	if (unlikely(flags & ~(BPF_F_RECOMPUTE_CSUM | BPF_F_INVALIDATE_HASH)))
 		return -EINVAL;
-	if (unlikely(offset > 0xffff))
+	if (unlikely(offset > INT_MAX))
 		return -EFAULT;
 	if (unlikely(bpf_try_make_writable(skb, offset + len)))
 		return -EFAULT;
@@ -1722,7 +1722,7 @@ BPF_CALL_4(bpf_skb_load_bytes, const str
 {
 	void *ptr;
 
-	if (unlikely(offset > 0xffff))
+	if (unlikely(offset > INT_MAX))
 		goto err_clear;
 
 	ptr = skb_header_pointer(skb, offset, len, to);


