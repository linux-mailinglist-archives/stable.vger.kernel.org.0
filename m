Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F5646AB079
	for <lists+stable@lfdr.de>; Sun,  5 Mar 2023 14:56:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230126AbjCEN40 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 5 Mar 2023 08:56:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230110AbjCEN4D (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 5 Mar 2023 08:56:03 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8053FCA07;
        Sun,  5 Mar 2023 05:55:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 81A23B80AD4;
        Sun,  5 Mar 2023 13:54:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEB71C433EF;
        Sun,  5 Mar 2023 13:54:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678024471;
        bh=Hzk9IvwA7y6VQfWSvbFOzDfMXY+1sArz+O0UOp50ojY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k2CgCk5pDsqAEOWcteHYKbUHeDV+Q6BCGFmPJjPO9I/5oDX4WuM6mKHXm0NYk/hXM
         WoliUnq9IuQCyhWQ4+eiYjLzGv+0eMLs3uVFupTd/zoud6XqMNNCA/1WgNX39geWNC
         /o9yt/zZet77sujQ1t3xbwlhto9DyML95HEloLNCb357fE1uWjTEnxPE+kBGgbpppD
         qMHUUHcdlkQ83R00ScbhU7UAADAuGtATab2oUTOMmEQWbbVhEJOCCh0kJTrBMO0YDx
         8kHYicWkEnpNQqnDDM5AO/4efh+doqxMhB0azqoURXmbyiRGUKLqxqVG9uC9xvhbBG
         /agLfHtiMHCBA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     xurui <xurui@kylinos.cn>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Sasha Levin <sashal@kernel.org>, linux-mips@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 2/8] MIPS: Fix a compilation issue
Date:   Sun,  5 Mar 2023 08:54:19 -0500
Message-Id: <20230305135425.1793964-2-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230305135425.1793964-1-sashal@kernel.org>
References: <20230305135425.1793964-1-sashal@kernel.org>
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
index 9a6eefd127571..3eb767c8a4eec 100644
--- a/arch/mips/include/asm/mach-rc32434/pci.h
+++ b/arch/mips/include/asm/mach-rc32434/pci.h
@@ -374,7 +374,7 @@ struct pci_msu {
 				 PCI_CFG04_STAT_SSE | \
 				 PCI_CFG04_STAT_PE)
 
-#define KORINA_CNFG1		((KORINA_STAT<<16)|KORINA_CMD)
+#define KORINA_CNFG1		(KORINA_STAT | KORINA_CMD)
 
 #define KORINA_REVID		0
 #define KORINA_CLASS_CODE	0
-- 
2.39.2

