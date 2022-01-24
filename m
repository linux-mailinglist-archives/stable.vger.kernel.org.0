Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CAED4993A5
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 21:38:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1386062AbiAXUfA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 15:35:00 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:53644 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239764AbiAXU3C (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:29:02 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DDA1B61506;
        Mon, 24 Jan 2022 20:29:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B162EC340E5;
        Mon, 24 Jan 2022 20:29:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643056141;
        bh=xPFcUW/VW0HIXO34nXQrqLM6dA/LfJbR16e5fxSkbvk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WyDQIokNd8821FlonSRRcRKWWpkG8/bQnRgM2BKglitM8oDagkFOl7t3Mm+wpQFFQ
         53rJaWXItve5OUdxqEEXsu8CyN1yqtuWQfN/v1gw65zcBA/q3QNo2LqG8bDQyPVmo3
         rpd5QnlQurrHWX+w/ebzhdeZ5XB/scMfiLdKYUqs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peiwei Hu <jlu.hpw@foxmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 384/846] powerpc/prom_init: Fix improper check of prom_getprop()
Date:   Mon, 24 Jan 2022 19:38:21 +0100
Message-Id: <20220124184114.185577267@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
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
index 18b04b08b9833..f845065c860e3 100644
--- a/arch/powerpc/kernel/prom_init.c
+++ b/arch/powerpc/kernel/prom_init.c
@@ -2991,7 +2991,7 @@ static void __init fixup_device_tree_efika_add_phy(void)
 
 	/* Check if the phy-handle property exists - bail if it does */
 	rv = prom_getprop(node, "phy-handle", prop, sizeof(prop));
-	if (!rv)
+	if (rv <= 0)
 		return;
 
 	/*
-- 
2.34.1



