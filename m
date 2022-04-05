Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0EA8E4F2EF9
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 14:05:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235655AbiDEI1E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:27:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239421AbiDEIUE (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:20:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFEDC8E1AF;
        Tue,  5 Apr 2022 01:12:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4A86860B0B;
        Tue,  5 Apr 2022 08:12:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D3ADC385A0;
        Tue,  5 Apr 2022 08:12:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649146374;
        bh=Uei5z8hVMTTP/ef+TzfjM7pNOY5Pj1gxvZnvJmGs/1Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=q4mc1mCh9xWOtv523XqvA1KkDf8qBHjcmiLhhTDhck7Us/Wty9kNcBmems3+0EO/3
         GbmuFVpvGKRt8WXvgbK+cL0BvI0s60VuwaKfzS10hLbaYNzk82XuhflCjpomevHlsv
         vqTEwMUWwuGPmz1wAeuANCvrw8leGopIqxHYqagQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Skripkin <paskripkin@gmail.com>,
        Martin Kaiser <martin@kaiser.cx>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0741/1126] staging: r8188eu: fix endless loop in recv_func
Date:   Tue,  5 Apr 2022 09:24:48 +0200
Message-Id: <20220405070429.336813771@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
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



