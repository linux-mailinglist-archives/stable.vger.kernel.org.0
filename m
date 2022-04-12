Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16BD14FD70A
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 12:26:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353981AbiDLHiL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 03:38:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353655AbiDLHZv (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 03:25:51 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 646A62654D;
        Tue, 12 Apr 2022 00:02:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 25F92B81B4D;
        Tue, 12 Apr 2022 07:02:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93E72C385A1;
        Tue, 12 Apr 2022 07:02:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649746976;
        bh=rb+DK+rJsHObvbXltqsJ1GN1pXKnkaPQFpQEyWSXq2w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q+AZg2Dqhgsz1YyhoTJuKOmLYXUPsEC8IYsDw9PjBX8tFzyn7WlFRyNldK6Rj/csy
         HOEXA+FV25yQjJSfjOLjyZvx10kOZOI+SXe//cnzRpBSxbDRx6ttq6IowpoBxd14ZK
         Oda67+9obv6TSBjRNaQsnrHj3ksm3s896GAyJYkU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Ziyang Xuan <william.xuanziyang@huawei.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 161/285] net/tls: fix slab-out-of-bounds bug in decrypt_internal
Date:   Tue, 12 Apr 2022 08:30:18 +0200
Message-Id: <20220412062948.317732098@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062943.670770901@linuxfoundation.org>
References: <20220412062943.670770901@linuxfoundation.org>
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

From: Ziyang Xuan <william.xuanziyang@huawei.com>

[ Upstream commit 9381fe8c849cfbe50245ac01fc077554f6eaa0e2 ]

The memory size of tls_ctx->rx.iv for AES128-CCM is 12 setting in
tls_set_sw_offload(). The return value of crypto_aead_ivsize()
for "ccm(aes)" is 16. So memcpy() require 16 bytes from 12 bytes
memory space will trigger slab-out-of-bounds bug as following:

==================================================================
BUG: KASAN: slab-out-of-bounds in decrypt_internal+0x385/0xc40 [tls]
Read of size 16 at addr ffff888114e84e60 by task tls/10911

Call Trace:
 <TASK>
 dump_stack_lvl+0x34/0x44
 print_report.cold+0x5e/0x5db
 ? decrypt_internal+0x385/0xc40 [tls]
 kasan_report+0xab/0x120
 ? decrypt_internal+0x385/0xc40 [tls]
 kasan_check_range+0xf9/0x1e0
 memcpy+0x20/0x60
 decrypt_internal+0x385/0xc40 [tls]
 ? tls_get_rec+0x2e0/0x2e0 [tls]
 ? process_rx_list+0x1a5/0x420 [tls]
 ? tls_setup_from_iter.constprop.0+0x2e0/0x2e0 [tls]
 decrypt_skb_update+0x9d/0x400 [tls]
 tls_sw_recvmsg+0x3c8/0xb50 [tls]

Allocated by task 10911:
 kasan_save_stack+0x1e/0x40
 __kasan_kmalloc+0x81/0xa0
 tls_set_sw_offload+0x2eb/0xa20 [tls]
 tls_setsockopt+0x68c/0x700 [tls]
 __sys_setsockopt+0xfe/0x1b0

Replace the crypto_aead_ivsize() with prot->iv_size + prot->salt_size
when memcpy() iv value in TLS_1_3_VERSION scenario.

Fixes: f295b3ae9f59 ("net/tls: Add support of AES128-CCM based ciphers")
Signed-off-by: Ziyang Xuan <william.xuanziyang@huawei.com>
Reviewed-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/tls/tls_sw.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index dfe623a4e72f..3aecd770ef99 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -1495,7 +1495,7 @@ static int decrypt_internal(struct sock *sk, struct sk_buff *skb,
 	if (prot->version == TLS_1_3_VERSION ||
 	    prot->cipher_type == TLS_CIPHER_CHACHA20_POLY1305)
 		memcpy(iv + iv_offset, tls_ctx->rx.iv,
-		       crypto_aead_ivsize(ctx->aead_recv));
+		       prot->iv_size + prot->salt_size);
 	else
 		memcpy(iv + iv_offset, tls_ctx->rx.iv, prot->salt_size);
 
-- 
2.35.1



