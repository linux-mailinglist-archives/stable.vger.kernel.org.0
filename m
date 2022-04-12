Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EAA5E4FD514
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 12:10:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354319AbiDLHv5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 03:51:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357123AbiDLHjs (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 03:39:48 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 486D9E080;
        Tue, 12 Apr 2022 00:12:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 03318B81B55;
        Tue, 12 Apr 2022 07:12:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5ABF9C385A1;
        Tue, 12 Apr 2022 07:12:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649747537;
        bh=uJjfmRLmfVzd8ksjcEl8BYhQjcPtbCrQav23XF1v1rA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N7kY6gwzctbXDTMOE5Qhog3vxvYg8lwX/3WNaNaWnVvHrMMFImfyDC11Zi4Rvrxd0
         TNMgQdjLF2yi/cfoLbQ1k1FF01cJ045XI+99+T/x9C8sepQy0ZmPYWbNGa7LLJ0+A4
         4HOhEbA6SFQqMO5xeY5YYyzAD6AiY4oK9CrL9u1c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dust Li <dust.li@linux.alibaba.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 116/343] net/smc: correct settings of RMB window update limit
Date:   Tue, 12 Apr 2022 08:28:54 +0200
Message-Id: <20220412062954.738738746@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062951.095765152@linuxfoundation.org>
References: <20220412062951.095765152@linuxfoundation.org>
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

From: Dust Li <dust.li@linux.alibaba.com>

[ Upstream commit 6bf536eb5c8ca011d1ff57b5c5f7c57ceac06a37 ]

rmbe_update_limit is used to limit announcing receive
window updating too frequently. RFC7609 request a minimal
increase in the window size of 10% of the receive buffer
space. But current implementation used:

  min_t(int, rmbe_size / 10, SOCK_MIN_SNDBUF / 2)

and SOCK_MIN_SNDBUF / 2 == 2304 Bytes, which is almost
always less then 10% of the receive buffer space.

This causes the receiver always sending CDC message to
update its consumer cursor when it consumes more then 2K
of data. And as a result, we may encounter something like
"TCP silly window syndrome" when sending 2.5~8K message.

This patch fixes this using max(rmbe_size / 10, SOCK_MIN_SNDBUF / 2).

With this patch and SMC autocorking enabled, qperf 2K/4K/8K
tcp_bw test shows 45%/75%/40% increase in throughput respectively.

Signed-off-by: Dust Li <dust.li@linux.alibaba.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/smc/smc_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
index be7d704976ff..f40f6ed0fbdb 100644
--- a/net/smc/smc_core.c
+++ b/net/smc/smc_core.c
@@ -1989,7 +1989,7 @@ static struct smc_buf_desc *smc_buf_get_slot(int compressed_bufsize,
  */
 static inline int smc_rmb_wnd_update_limit(int rmbe_size)
 {
-	return min_t(int, rmbe_size / 10, SOCK_MIN_SNDBUF / 2);
+	return max_t(int, rmbe_size / 10, SOCK_MIN_SNDBUF / 2);
 }
 
 /* map an rmb buf to a link */
-- 
2.35.1



