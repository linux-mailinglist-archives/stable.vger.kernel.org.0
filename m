Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 656DC4F3430
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 15:25:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350386AbiDEJ5x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 05:57:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344004AbiDEJQo (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:16:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65679101FE;
        Tue,  5 Apr 2022 02:02:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 01BD061564;
        Tue,  5 Apr 2022 09:02:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17C37C385A1;
        Tue,  5 Apr 2022 09:02:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649149368;
        bh=Uei5z8hVMTTP/ef+TzfjM7pNOY5Pj1gxvZnvJmGs/1Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sIkKJzXwVB/kaHmKzUi8HxpwsS+7ZOKh+RLIaBTshTtOJIopYs/6xbz2ufZyH3YTC
         Dxugq6iyXnxY6ELCpJAHepKRJ6FyUwAah99ewwgLidXK3dQqWQ9Lde1ElrXV9yNH1+
         NObaWFNIhsTUEc9wlUKvusTUE/AzODtqNOsCLDRU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Skripkin <paskripkin@gmail.com>,
        Martin Kaiser <martin@kaiser.cx>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0672/1017] staging: r8188eu: fix endless loop in recv_func
Date:   Tue,  5 Apr 2022 09:26:25 +0200
Message-Id: <20220405070414.227866929@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070354.155796697@linuxfoundation.org>
References: <20220405070354.155796697@linuxfoundation.org>
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
index 51a13262a226..d120d61454a3 100644
--- a/drivers/staging/r8188eu/core/rtw_recv.c
+++ b/drivers/staging/r8188eu/core/rtw_recv.c
@@ -1853,8 +1853,7 @@ static int recv_func(struct adapter *padapter, struct recv_frame *rframe)
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



