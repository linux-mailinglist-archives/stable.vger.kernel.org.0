Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B648153CEB6
	for <lists+stable@lfdr.de>; Fri,  3 Jun 2022 19:46:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245101AbiFCRpy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Jun 2022 13:45:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345382AbiFCRpI (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Jun 2022 13:45:08 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B7E25620A;
        Fri,  3 Jun 2022 10:43:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5FC02B82433;
        Fri,  3 Jun 2022 17:43:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99A7BC385A9;
        Fri,  3 Jun 2022 17:43:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654278185;
        bh=dGYmpab8lZhl/x+ohPdCjH5/Ov/gj3SWugFpxDrtFZs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WXsXa0K4anJtisSvaak7jt/K3IXByIuDNZ5KKBPB6Sd0U3DBeVnzI2Wu0IaEbfSNQ
         a4wo7/pA5kXpdriBnI78LVOWMVvS8j5L1V3hwf8p8ai0MIrJ/tnJF9t1pTexyhFcMa
         qRus3cFGMQUSCOuZPz854wApQyrjq7Nr7xeU81pw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Liu Jian <liujian56@huawei.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Song Liu <songliubraving@fb.com>
Subject: [PATCH 4.19 30/30] bpf: Enlarge offset check value to INT_MAX in bpf_skb_{load,store}_bytes
Date:   Fri,  3 Jun 2022 19:39:58 +0200
Message-Id: <20220603173815.976549226@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220603173815.088143764@linuxfoundation.org>
References: <20220603173815.088143764@linuxfoundation.org>
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
@@ -1666,7 +1666,7 @@ BPF_CALL_5(bpf_skb_store_bytes, struct s
 
 	if (unlikely(flags & ~(BPF_F_RECOMPUTE_CSUM | BPF_F_INVALIDATE_HASH)))
 		return -EINVAL;
-	if (unlikely(offset > 0xffff))
+	if (unlikely(offset > INT_MAX))
 		return -EFAULT;
 	if (unlikely(bpf_try_make_writable(skb, offset + len)))
 		return -EFAULT;
@@ -1701,7 +1701,7 @@ BPF_CALL_4(bpf_skb_load_bytes, const str
 {
 	void *ptr;
 
-	if (unlikely(offset > 0xffff))
+	if (unlikely(offset > INT_MAX))
 		goto err_clear;
 
 	ptr = skb_header_pointer(skb, offset, len, to);


