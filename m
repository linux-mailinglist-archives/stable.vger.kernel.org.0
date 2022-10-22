Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 402346086F7
	for <lists+stable@lfdr.de>; Sat, 22 Oct 2022 09:55:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231774AbiJVHzd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Oct 2022 03:55:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232109AbiJVHyE (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Oct 2022 03:54:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69176645CE;
        Sat, 22 Oct 2022 00:47:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 583B060ADC;
        Sat, 22 Oct 2022 07:47:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A79BC433D7;
        Sat, 22 Oct 2022 07:47:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666424824;
        bh=VEZNnwj0nUV+r46mdb30yQGhzT2eyjw9eB3hHB+x73Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jXF6PIpizCTdD+bMU0JkC/oqMlOn963O0Xw87fvXxpa6J8fuaLONGCOwBy/ToKgq+
         fv5USg0MHPs+U2/JZ+zOQZaB5wLtiq+a5rDiZjTPowgMGOQIQLyu3DC8AJBTA31d2H
         b+U1uhayMxAB9Ved1o9CUiLTE7+ZiYGD/uoVRqnU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jianglei Nie <niejianglei2021@163.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 289/717] bnx2x: fix potential memory leak in bnx2x_tpa_stop()
Date:   Sat, 22 Oct 2022 09:22:48 +0200
Message-Id: <20221022072504.604401072@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221022072415.034382448@linuxfoundation.org>
References: <20221022072415.034382448@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
index 5729a5ab059d..4cbd3ba5acb9 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
@@ -789,6 +789,7 @@ static void bnx2x_tpa_stop(struct bnx2x *bp, struct bnx2x_fastpath *fp,
 			BNX2X_ERR("skb_put is about to fail...  pad %d  len %d  rx_buf_size %d\n",
 				  pad, len, fp->rx_buf_size);
 			bnx2x_panic();
+			bnx2x_frag_free(fp, new_data);
 			return;
 		}
 #endif
-- 
2.35.1



