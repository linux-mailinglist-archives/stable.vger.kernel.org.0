Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3351D4F3330
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 15:14:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242176AbiDEIhG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:37:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238917AbiDEITa (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:19:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 021BE75215;
        Tue,  5 Apr 2022 01:09:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4DD68608C0;
        Tue,  5 Apr 2022 08:09:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A775C385A0;
        Tue,  5 Apr 2022 08:09:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649146182;
        bh=Vge0+JI6dnmSDzj8z8QK4MArKmPEiy+UaJEPPJBued8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xhxXitVc3fj3BFoF0HMuruMBC2xemtRhUsUSm3nVB16CsnvQNaaILn6AuaB3zDgpR
         LZUzOjAxPAPZrzLjcUku5KzWbGU3ERyoKZPKjhO+6W7DzFm3z9EDg+Dq3fyPLg84xw
         49Hbu1hCDmMrSFpcs8Qtg1euQaoGQIOGfJf8xRW0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nicholas Piggin <npiggin@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0670/1126] powerpc/time: Fix KVM host re-arming a timer beyond decrementer range
Date:   Tue,  5 Apr 2022 09:23:37 +0200
Message-Id: <20220405070427.293514868@linuxfoundation.org>
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

From: Nicholas Piggin <npiggin@gmail.com>

[ Upstream commit cf74ff52e352112be78c4c4c3637a37ec36a6608 ]

If the next host timer is beyond decrementer range, timer_rearm_host_dec
will leave decrementer not programmed. This will not cause a problem for
the host it will just set the decrementer correctly when the decrementer
interrupt hits, it seems safer not to leave the next host decrementer
interrupt timing able to be influenced by a guest.

This code is only used in the P9 KVM paths so it's unlikely to be hit
practically unless large decrementer is force disabled in the host.

Fixes: 25aa145856cd ("powerpc/time: add API for KVM to re-arm the host timer/decrementer")
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20220124143930.3923442-2-npiggin@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kernel/time.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/kernel/time.c b/arch/powerpc/kernel/time.c
index cd0b8b71ecdd..384f58a3f373 100644
--- a/arch/powerpc/kernel/time.c
+++ b/arch/powerpc/kernel/time.c
@@ -582,8 +582,9 @@ void timer_rearm_host_dec(u64 now)
 		local_paca->irq_happened |= PACA_IRQ_DEC;
 	} else {
 		now = *next_tb - now;
-		if (now <= decrementer_max)
-			set_dec_or_work(now);
+		if (now > decrementer_max)
+			now = decrementer_max;
+		set_dec_or_work(now);
 	}
 }
 EXPORT_SYMBOL_GPL(timer_rearm_host_dec);
-- 
2.34.1



