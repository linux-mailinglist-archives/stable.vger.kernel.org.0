Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1DB9593B3B
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 22:34:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344094AbiHOTia (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 15:38:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344493AbiHOTgp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 15:36:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F180D3121B;
        Mon, 15 Aug 2022 11:46:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 80C7F611EC;
        Mon, 15 Aug 2022 18:46:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFCB2C433B5;
        Mon, 15 Aug 2022 18:46:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660589171;
        bh=cRlLFjAVgnrgy41c8V3O5sjZBDaCSnMXi0/hnIxRhHE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sG0lRVrTTPjT3TmXGIWDQaTbzay3DUxlUYOwPn/Ex0DH8Mp0DXkbbijk5holPtN8J
         OyYDvxbaDS7lIXss2ONas5PYGtja7edCx0B9gg6rK6tzWA50mHWonoMFWiTxG38MSW
         L1VHrvvgMaZlqH8qLjtCN9LqTzhxAW8poL04bGM0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 636/779] powerpc/32: Do not allow selection of e5500 or e6500 CPUs on PPC32
Date:   Mon, 15 Aug 2022 20:04:40 +0200
Message-Id: <20220815180404.529163114@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180337.130757997@linuxfoundation.org>
References: <20220815180337.130757997@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Christophe Leroy <christophe.leroy@csgroup.eu>

[ Upstream commit 9be013b2a9ecb29b5168e4b9db0e48ed53acf37c ]

Commit 0e00a8c9fd92 ("powerpc: Allow CPU selection also on PPC32")
enlarged the CPU selection logic to PPC32 by removing depend to
PPC64, and failed to restrict that depend to E5500_CPU and E6500_CPU.
Fortunately that got unnoticed because -mcpu=8540 will override the
-mcpu=e500mc64 or -mpcu=e6500 as they are ealier, but that's
fragile and may no be right in the future.

Add back the depend PPC64 on E5500_CPU and E6500_CPU.

Fixes: 0e00a8c9fd92 ("powerpc: Allow CPU selection also on PPC32")
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/8abab4888da69ff78b73a56f64d9678a7bf684e9.1657549153.git.christophe.leroy@csgroup.eu
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/platforms/Kconfig.cputype | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/platforms/Kconfig.cputype b/arch/powerpc/platforms/Kconfig.cputype
index 87a95cbff2f3..81f8c9634832 100644
--- a/arch/powerpc/platforms/Kconfig.cputype
+++ b/arch/powerpc/platforms/Kconfig.cputype
@@ -170,11 +170,11 @@ config POWER9_CPU
 
 config E5500_CPU
 	bool "Freescale e5500"
-	depends on E500
+	depends on PPC64 && E500
 
 config E6500_CPU
 	bool "Freescale e6500"
-	depends on E500
+	depends on PPC64 && E500
 
 config 860_CPU
 	bool "8xx family"
-- 
2.35.1



