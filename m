Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 690006AB0BE
	for <lists+stable@lfdr.de>; Sun,  5 Mar 2023 15:01:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230378AbjCEOBz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 5 Mar 2023 09:01:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230255AbjCEOBl (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 5 Mar 2023 09:01:41 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A70BE1CAF4;
        Sun,  5 Mar 2023 06:00:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A94CAB80AD7;
        Sun,  5 Mar 2023 13:54:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6920C433EF;
        Sun,  5 Mar 2023 13:54:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678024494;
        bh=OzBV5aBqKSqmojYY0HRKAqEqSDU504pp8GTe0Af+pj0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dbLJjScFTfVcp851+YT0tH831AgaItXGfeG0jaLifxEGD7XVzszIZsu52pnFAClZA
         a0RnSts8+8ROz843hUm4xkiRiYd+jqFaq31H/1esUjsPu4UBPSIxAhX/CVUtFTq4Sg
         WrbblhINduDNey7tE48K56u6czlJYCCykJjzhW13X2y8jnyZK0xHHm/OLh1BY3DYZI
         2fhpfWcFrhYvpGBGnLbxYG9/qkzoi+dv+mD54E39/dz8OXvV8axwd04ScprNHJshD/
         9uPn9QgKTAMlfwxtO+MctSTlCxKTzn5M8zRdGPI5zqH6egnEPbB1vw1w2C1gKSEpaJ
         kj9owFsm3MSJA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     xurui <xurui@kylinos.cn>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Sasha Levin <sashal@kernel.org>, linux-mips@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 2/7] MIPS: Fix a compilation issue
Date:   Sun,  5 Mar 2023 08:54:43 -0500
Message-Id: <20230305135449.1794083-2-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230305135449.1794083-1-sashal@kernel.org>
References: <20230305135449.1794083-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: xurui <xurui@kylinos.cn>

[ Upstream commit 109d587a4b4d7ccca2200ab1f808f43ae23e2585 ]

arch/mips/include/asm/mach-rc32434/pci.h:377:
cc1: error: result of ‘-117440512 << 16’ requires 44 bits to represent, but ‘int’ only has 32 bits [-Werror=shift-overflow=]

All bits in KORINA_STAT are already at the correct position, so there is
no addtional shift needed.

Signed-off-by: xurui <xurui@kylinos.cn>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/include/asm/mach-rc32434/pci.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/mips/include/asm/mach-rc32434/pci.h b/arch/mips/include/asm/mach-rc32434/pci.h
index 6f40d1515580b..1ff8a987025c8 100644
--- a/arch/mips/include/asm/mach-rc32434/pci.h
+++ b/arch/mips/include/asm/mach-rc32434/pci.h
@@ -377,7 +377,7 @@ struct pci_msu {
 				 PCI_CFG04_STAT_SSE | \
 				 PCI_CFG04_STAT_PE)
 
-#define KORINA_CNFG1		((KORINA_STAT<<16)|KORINA_CMD)
+#define KORINA_CNFG1		(KORINA_STAT | KORINA_CMD)
 
 #define KORINA_REVID		0
 #define KORINA_CLASS_CODE	0
-- 
2.39.2

