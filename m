Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03C4D6AE9D8
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:28:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231655AbjCGR2K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:28:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231577AbjCGR1u (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:27:50 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4356428D39
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:23:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A3F96614DF
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:23:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1C2AC433EF;
        Tue,  7 Mar 2023 17:23:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678209784;
        bh=rysGY3fl1GI2r2EmkrcMHoOZNa9GgV4KxA9Fbnj1t88=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QAVz9kQMherq1tVaua+N2y06bUUJQHr4gLgfCivNySEAEpgEUoFMOAy+4PDV51fYb
         2lNCY+higqs8f7F2jzf7i+NA9/zkhp2TCrOJFmwOEiYQv0ccul8Pz8xH72Zp5wNOP9
         7H/b1frQibd99A+nf0sLPyHkxu95rnqlHf4EFt+Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Josef Oskera <joskera@redhat.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Kees Cook <keescook@chromium.org>,
        Tariq Toukan <tariqt@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0323/1001] net/mlx4_en: Introduce flexible array to silence overflow warning
Date:   Tue,  7 Mar 2023 17:51:35 +0100
Message-Id: <20230307170035.544009903@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kees Cook <keescook@chromium.org>

[ Upstream commit f8f185e39b4de91bc5235e5be0d829bea69d9b06 ]

The call "skb_copy_from_linear_data(skb, inl + 1, spc)" triggers a FORTIFY
memcpy() warning on ppc64 platform:

In function ‘fortify_memcpy_chk’,
    inlined from ‘skb_copy_from_linear_data’ at ./include/linux/skbuff.h:4029:2,
    inlined from ‘build_inline_wqe’ at drivers/net/ethernet/mellanox/mlx4/en_tx.c:722:4,
    inlined from ‘mlx4_en_xmit’ at drivers/net/ethernet/mellanox/mlx4/en_tx.c:1066:3:
./include/linux/fortify-string.h:513:25: error: call to ‘__write_overflow_field’ declared with
attribute warning: detected write beyond size of field (1st parameter); maybe use struct_group()?
[-Werror=attribute-warning]
  513 |                         __write_overflow_field(p_size_field, size);
      |                         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Same behaviour on x86 you can get if you use "__always_inline" instead of
"inline" for skb_copy_from_linear_data() in skbuff.h

The call here copies data into inlined tx destricptor, which has 104
bytes (MAX_INLINE) space for data payload. In this case "spc" is known
in compile-time but the destination is used with hidden knowledge
(real structure of destination is different from that the compiler
can see). That cause the fortify warning because compiler can check
bounds, but the real bounds are different.  "spc" can't be bigger than
64 bytes (MLX4_INLINE_ALIGN), so the data can always fit into inlined
tx descriptor. The fact that "inl" points into inlined tx descriptor is
determined earlier in mlx4_en_xmit().

Avoid confusing the compiler with "inl + 1" constructions to get to past
the inl header by introducing a flexible array "data" to the struct so
that the compiler can see that we are not dealing with an array of inl
structs, but rather, arbitrary data following the structure. There are
no changes to the structure layout reported by pahole, and the resulting
machine code is actually smaller.

Reported-by: Josef Oskera <joskera@redhat.com>
Link: https://lore.kernel.org/lkml/20230217094541.2362873-1-joskera@redhat.com
Fixes: f68f2ff91512 ("fortify: Detect struct member overflows in memcpy() at compile-time")
Cc: Yishai Hadas <yishaih@nvidia.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Link: https://lore.kernel.org/r/20230218183842.never.954-kees@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx4/en_tx.c | 22 +++++++++++-----------
 include/linux/mlx4/qp.h                    |  1 +
 2 files changed, 12 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/en_tx.c b/drivers/net/ethernet/mellanox/mlx4/en_tx.c
index c5758637b7bed..2f79378fbf6ec 100644
--- a/drivers/net/ethernet/mellanox/mlx4/en_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_tx.c
@@ -699,32 +699,32 @@ static void build_inline_wqe(struct mlx4_en_tx_desc *tx_desc,
 			inl->byte_count = cpu_to_be32(1 << 31 | skb->len);
 		} else {
 			inl->byte_count = cpu_to_be32(1 << 31 | MIN_PKT_LEN);
-			memset(((void *)(inl + 1)) + skb->len, 0,
+			memset(inl->data + skb->len, 0,
 			       MIN_PKT_LEN - skb->len);
 		}
-		skb_copy_from_linear_data(skb, inl + 1, hlen);
+		skb_copy_from_linear_data(skb, inl->data, hlen);
 		if (shinfo->nr_frags)
-			memcpy(((void *)(inl + 1)) + hlen, fragptr,
+			memcpy(inl->data + hlen, fragptr,
 			       skb_frag_size(&shinfo->frags[0]));
 
 	} else {
 		inl->byte_count = cpu_to_be32(1 << 31 | spc);
 		if (hlen <= spc) {
-			skb_copy_from_linear_data(skb, inl + 1, hlen);
+			skb_copy_from_linear_data(skb, inl->data, hlen);
 			if (hlen < spc) {
-				memcpy(((void *)(inl + 1)) + hlen,
+				memcpy(inl->data + hlen,
 				       fragptr, spc - hlen);
 				fragptr +=  spc - hlen;
 			}
-			inl = (void *) (inl + 1) + spc;
-			memcpy(((void *)(inl + 1)), fragptr, skb->len - spc);
+			inl = (void *)inl->data + spc;
+			memcpy(inl->data, fragptr, skb->len - spc);
 		} else {
-			skb_copy_from_linear_data(skb, inl + 1, spc);
-			inl = (void *) (inl + 1) + spc;
-			skb_copy_from_linear_data_offset(skb, spc, inl + 1,
+			skb_copy_from_linear_data(skb, inl->data, spc);
+			inl = (void *)inl->data + spc;
+			skb_copy_from_linear_data_offset(skb, spc, inl->data,
 							 hlen - spc);
 			if (shinfo->nr_frags)
-				memcpy(((void *)(inl + 1)) + hlen - spc,
+				memcpy(inl->data + hlen - spc,
 				       fragptr,
 				       skb_frag_size(&shinfo->frags[0]));
 		}
diff --git a/include/linux/mlx4/qp.h b/include/linux/mlx4/qp.h
index 9db93e487496a..b6b626157b03a 100644
--- a/include/linux/mlx4/qp.h
+++ b/include/linux/mlx4/qp.h
@@ -446,6 +446,7 @@ enum {
 
 struct mlx4_wqe_inline_seg {
 	__be32			byte_count;
+	__u8			data[];
 };
 
 enum mlx4_update_qp_attr {
-- 
2.39.2



