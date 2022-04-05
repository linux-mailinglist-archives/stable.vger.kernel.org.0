Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D12B44F3844
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 16:32:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376507AbiDELWP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 07:22:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349450AbiDEJtx (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:49:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B23BB27B20;
        Tue,  5 Apr 2022 02:46:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4C4956164D;
        Tue,  5 Apr 2022 09:46:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E93AC385A3;
        Tue,  5 Apr 2022 09:46:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649151972;
        bh=Erirp5qaLkmT2KhloGasa14482cQS95b1zyeEUKtpyc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mMr+n9w61cnl0LydRa2hhEDZgoMDJxB9UfThttNvQxhU8JqbmlWJqQ4aRlDXMGo83
         mY2OdxT9pA8El8y7ivf/baSZ7d1PyXGQR5pZW2yVoz6obpVcm6Ha8oI8q4mx4qw7CG
         LayLWgfc6lIh0aTB7vqe5UmBL5ilMrHlLDXOi5Go=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Skripkin <paskripkin@gmail.com>,
        Martin Kaiser <martin@kaiser.cx>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 607/913] staging: r8188eu: fix endless loop in recv_func
Date:   Tue,  5 Apr 2022 09:27:49 +0200
Message-Id: <20220405070358.036454946@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070339.801210740@linuxfoundation.org>
References: <20220405070339.801210740@linuxfoundation.org>
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

From: Martin Kaiser <martin@kaiser.cx>

[ Upstream commit 1327fcf175fa63d3b7a058b8148ed7714acdc035 ]

Fix an endless loop in recv_func. If pending_frame is not NULL, we're
stuck in the while loop forever. We have to call rtw_alloc_recvframe
each time we loop.

Fixes: 15865124feed ("staging: r8188eu: introduce new core dir for RTL8188eu driver")
Reported-by: Pavel Skripkin <paskripkin@gmail.com>
Signed-off-by: Martin Kaiser <martin@kaiser.cx>
Link: https://lore.kernel.org/r/20220226181457.1138035-4-martin@kaiser.cx
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/r8188eu/core/rtw_recv.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/staging/r8188eu/core/rtw_recv.c b/drivers/staging/r8188eu/core/rtw_recv.c
index e082edfbaad8..30ca9f1e0363 100644
--- a/drivers/staging/r8188eu/core/rtw_recv.c
+++ b/drivers/staging/r8188eu/core/rtw_recv.c
@@ -1942,8 +1942,7 @@ static int recv_func(struct adapter *padapter, struct recv_frame *rframe)
 		struct recv_frame *pending_frame;
 		int cnt = 0;
 
-		pending_frame = rtw_alloc_recvframe(&padapter->recvpriv.uc_swdec_pending_queue);
-		while (pending_frame) {
+		while ((pending_frame = rtw_alloc_recvframe(&padapter->recvpriv.uc_swdec_pending_queue))) {
 			cnt++;
 			recv_func_posthandle(padapter, pending_frame);
 		}
-- 
2.34.1



