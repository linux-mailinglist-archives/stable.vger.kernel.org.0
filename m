Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2C51498C85
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 20:23:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349999AbiAXTXB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 14:23:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348589AbiAXTTC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 14:19:02 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4312C094273;
        Mon, 24 Jan 2022 11:07:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 65E5FB811FC;
        Mon, 24 Jan 2022 19:07:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B772C340E5;
        Mon, 24 Jan 2022 19:07:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643051245;
        bh=poL+zK5nwsxWR6WXUiJrFUmGFdQojIuXmkSniBCjjfQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AC1ZE13sdbR4jtI3moW6mR4NwRskMG+sLKqo9K1syq4ipbPykyQJsBic1wr6FQUqY
         s45gy05+ndjyMDYApGWVxrdy8qc9i6vOzxHqWKYQ6V/3QM8FldbGC+DvLsWTOyk1Er
         ZS6HpbfliTNq1/mnmDCH/WxeRP1RSTBuvx4eer+Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peiwei Hu <jlu.hpw@foxmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 073/186] powerpc/prom_init: Fix improper check of prom_getprop()
Date:   Mon, 24 Jan 2022 19:42:28 +0100
Message-Id: <20220124183939.472239817@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124183937.101330125@linuxfoundation.org>
References: <20220124183937.101330125@linuxfoundation.org>
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
index f8782c7ef50f1..7f049a60747e9 100644
--- a/arch/powerpc/kernel/prom_init.c
+++ b/arch/powerpc/kernel/prom_init.c
@@ -2774,7 +2774,7 @@ static void __init fixup_device_tree_efika_add_phy(void)
 
 	/* Check if the phy-handle property exists - bail if it does */
 	rv = prom_getprop(node, "phy-handle", prop, sizeof(prop));
-	if (!rv)
+	if (rv <= 0)
 		return;
 
 	/*
-- 
2.34.1



