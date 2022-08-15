Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1611C594C17
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 03:32:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346523AbiHPAcP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 20:32:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353034AbiHPAbH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 20:31:07 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 466A71859A1;
        Mon, 15 Aug 2022 13:36:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 86AC1B8113E;
        Mon, 15 Aug 2022 20:36:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6312C433D6;
        Mon, 15 Aug 2022 20:35:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660595759;
        bh=95XFJWskYR5c35UCiLc3szUERpmzKhUaat+774PWgg4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C3Bq+vJDNoAD7lz/ZfNCev3eHHKtStrlgZM8+Mdf5KOXyg28b8zujrs8qTJxElQqa
         0AkT7bz1Tlx8EEhRPsDh2rFTQN76S9rkMIMrao5YfGRlWR5VwrpNi9rxtdV5mb42jB
         rrDx4u/J3jYRTHgOeSa1SiFwLQ3GbaJfhcHnCJSg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jianglei Nie <niejianglei2021@163.com>,
        Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
        Leon Romanovsky <leon@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0833/1157] RDMA/hfi1: fix potential memory leak in setup_base_ctxt()
Date:   Mon, 15 Aug 2022 20:03:09 +0200
Message-Id: <20220815180512.801120794@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
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

From: Jianglei Nie <niejianglei2021@163.com>

[ Upstream commit aa2a1df3a2c85f855af7d54466ac10bd48645d63 ]

setup_base_ctxt() allocates a memory chunk for uctxt->groups with
hfi1_alloc_ctxt_rcv_groups(). When init_user_ctxt() fails, uctxt->groups
is not released, which will lead to a memory leak.

We should release the uctxt->groups with hfi1_free_ctxt_rcv_groups()
when init_user_ctxt() fails.

Fixes: e87473bc1b6c ("IB/hfi1: Only set fd pointer when base context is completely initialized")
Link: https://lore.kernel.org/r/20220711070718.2318320-1-niejianglei2021@163.com
Signed-off-by: Jianglei Nie <niejianglei2021@163.com>
Acked-by: Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hfi1/file_ops.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/hfi1/file_ops.c b/drivers/infiniband/hw/hfi1/file_ops.c
index 2e4cf2b11653..629beff053ad 100644
--- a/drivers/infiniband/hw/hfi1/file_ops.c
+++ b/drivers/infiniband/hw/hfi1/file_ops.c
@@ -1179,8 +1179,10 @@ static int setup_base_ctxt(struct hfi1_filedata *fd,
 		goto done;
 
 	ret = init_user_ctxt(fd, uctxt);
-	if (ret)
+	if (ret) {
+		hfi1_free_ctxt_rcv_groups(uctxt);
 		goto done;
+	}
 
 	user_init(uctxt);
 
-- 
2.35.1



