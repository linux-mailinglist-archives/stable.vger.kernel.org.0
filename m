Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46ECA60ABAA
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 15:55:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233328AbiJXNzJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 09:55:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236769AbiJXNyE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 09:54:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 803B4BCBA2;
        Mon, 24 Oct 2022 05:43:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C6F9661252;
        Mon, 24 Oct 2022 12:43:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE16BC433C1;
        Mon, 24 Oct 2022 12:43:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666615395;
        bh=FDJj57zct8g34Bx1kgQb5O2g5HvH0eUpe2PeLXP760g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fCF/EhKv1tA56lw9pQCnIEbqTCLWvL7DOD3DZ6lZlI/8KlPEmtHu2ZSTOytJkcpX/
         3ddcd1IjS9TCmHIleLBD+IoAeOkI8sabjWYzLq7Mn14uZulruZwkE0URhYEF919HyV
         jWi74y8T4s0rv9hVzZrS5Ywrhy7bm+MPbOxTttVc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jianglei Nie <niejianglei2021@163.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 203/530] bnx2x: fix potential memory leak in bnx2x_tpa_stop()
Date:   Mon, 24 Oct 2022 13:29:07 +0200
Message-Id: <20221024113054.252297412@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113044.976326639@linuxfoundation.org>
References: <20221024113044.976326639@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jianglei Nie <niejianglei2021@163.com>

[ Upstream commit b43f9acbb8942b05252be83ac25a81cec70cc192 ]

bnx2x_tpa_stop() allocates a memory chunk from new_data with
bnx2x_frag_alloc(). The new_data should be freed when gets some error.
But when "pad + len > fp->rx_buf_size" is true, bnx2x_tpa_stop() returns
without releasing the new_data, which will lead to a memory leak.

We should free the new_data with bnx2x_frag_free() when "pad + len >
fp->rx_buf_size" is true.

Fixes: 07b0f00964def8af9321cfd6c4a7e84f6362f728 ("bnx2x: fix possible panic under memory stress")
Signed-off-by: Jianglei Nie <niejianglei2021@163.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
index 198e041d8410..4f669e7c7558 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
@@ -788,6 +788,7 @@ static void bnx2x_tpa_stop(struct bnx2x *bp, struct bnx2x_fastpath *fp,
 			BNX2X_ERR("skb_put is about to fail...  pad %d  len %d  rx_buf_size %d\n",
 				  pad, len, fp->rx_buf_size);
 			bnx2x_panic();
+			bnx2x_frag_free(fp, new_data);
 			return;
 		}
 #endif
-- 
2.35.1



