Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 407F7498C3F
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 20:22:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349818AbiAXTVX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 14:21:23 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:42540 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345649AbiAXTRY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 14:17:24 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0EFD8B8121A;
        Mon, 24 Jan 2022 19:17:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20377C340E5;
        Mon, 24 Jan 2022 19:17:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643051841;
        bh=4iNiahPieKRqDiDjeJ6kqxnvQqLQ/zw+eC7/XomDRSE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=L0307G1ivl/5vV9NQ1dP7Lc6sbYBaCBSlY/5A5q3z6ZwUw+9TG3sfAqCxO20uSt54
         HwlNKouRBafcK6jLmp9W2yhHaK6+/wwzS1ldiW2C9w31z74DRqtgGhpyx4MaccTpny
         +I8MxosB/mNQ/g/uyfNukaZLMaTwbkyYDlkr5irY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peiwei Hu <jlu.hpw@foxmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 103/239] powerpc/prom_init: Fix improper check of prom_getprop()
Date:   Mon, 24 Jan 2022 19:42:21 +0100
Message-Id: <20220124183946.377505729@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124183943.102762895@linuxfoundation.org>
References: <20220124183943.102762895@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peiwei Hu <jlu.hpw@foxmail.com>

[ Upstream commit 869fb7e5aecbc163003f93f36dcc26d0554319f6 ]

prom_getprop() can return PROM_ERROR. Binary operator can not identify
it.

Fixes: 94d2dde738a5 ("[POWERPC] Efika: prune fixups and make them more carefull")
Signed-off-by: Peiwei Hu <jlu.hpw@foxmail.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/tencent_BA28CC6897B7C95A92EB8C580B5D18589105@qq.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kernel/prom_init.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/kernel/prom_init.c b/arch/powerpc/kernel/prom_init.c
index af1e38febe496..29a8087a49010 100644
--- a/arch/powerpc/kernel/prom_init.c
+++ b/arch/powerpc/kernel/prom_init.c
@@ -2805,7 +2805,7 @@ static void __init fixup_device_tree_efika_add_phy(void)
 
 	/* Check if the phy-handle property exists - bail if it does */
 	rv = prom_getprop(node, "phy-handle", prop, sizeof(prop));
-	if (!rv)
+	if (rv <= 0)
 		return;
 
 	/*
-- 
2.34.1



