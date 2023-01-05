Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8F2165EC23
	for <lists+stable@lfdr.de>; Thu,  5 Jan 2023 14:07:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234079AbjAENGw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Jan 2023 08:06:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234097AbjAENGT (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Jan 2023 08:06:19 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AD9D5AC42
        for <stable@vger.kernel.org>; Thu,  5 Jan 2023 05:06:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A7C7AB81AD2
        for <stable@vger.kernel.org>; Thu,  5 Jan 2023 13:06:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5C03C433D2;
        Thu,  5 Jan 2023 13:06:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672923969;
        bh=TbCpINvWp0CKrrPTkJS/DMyD036gVi7Qg6haYZw8mkM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mlE1WxfbXfKEy9K6URbhNM8U1x34JtDYLxhNzhM4rTQave+WxDbOraf6p+6ncUZbx
         58/OLv8tu4q+LohdaHa3PE66VMcHakj/nxjt3BhR9Ns2fvj3A102c4FIAjPVnz5F5J
         Dcw6Nzng3v33g4f5Dg/bZbYJq8604SqrZj6yXcqI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 162/251] powerpc/52xx: Fix a resource leak in an error handling path
Date:   Thu,  5 Jan 2023 13:54:59 +0100
Message-Id: <20230105125342.254997799@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230105125334.727282894@linuxfoundation.org>
References: <20230105125334.727282894@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit 5836947613ef33d311b4eff6a32d019580a214f5 ]

The error handling path of mpc52xx_lpbfifo_probe() has a request_irq()
that is not balanced by a corresponding free_irq().

Add the missing call, as already done in the remove function.

Fixes: 3c9059d79f5e ("powerpc/5200: add LocalPlus bus FIFO device driver")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/dec1496d46ccd5311d0f6e9f9ca4238be11bf6a6.1643440531.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/platforms/52xx/mpc52xx_lpbfifo.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/powerpc/platforms/52xx/mpc52xx_lpbfifo.c b/arch/powerpc/platforms/52xx/mpc52xx_lpbfifo.c
index 7bb42a0100de..caaaaf2bea52 100644
--- a/arch/powerpc/platforms/52xx/mpc52xx_lpbfifo.c
+++ b/arch/powerpc/platforms/52xx/mpc52xx_lpbfifo.c
@@ -531,6 +531,7 @@ static int mpc52xx_lpbfifo_probe(struct platform_device *op)
  err_bcom_rx_irq:
 	bcom_gen_bd_rx_release(lpbfifo.bcom_rx_task);
  err_bcom_rx:
+	free_irq(lpbfifo.irq, &lpbfifo);
  err_irq:
 	iounmap(lpbfifo.regs);
 	lpbfifo.regs = NULL;
-- 
2.35.1



