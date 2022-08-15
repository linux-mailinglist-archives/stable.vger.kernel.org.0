Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41AA2594433
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 00:58:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351633AbiHOWwM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 18:52:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352247AbiHOWvO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 18:51:14 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F217613793D;
        Mon, 15 Aug 2022 12:54:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DFAB9B81142;
        Mon, 15 Aug 2022 19:54:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38BAEC433D6;
        Mon, 15 Aug 2022 19:54:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660593246;
        bh=Tc4WXDymJ2CTXI4iMTKoY3fQcpSHQK9LM9L2XSipGUk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VfY1fKP7yAkF0Lvc0oAvSDDajKaY30341en6KGTpd9CVO0HIhFjFhkLrzYhWjbG1c
         wyNRD7kFYiSgDujc7NQ4Crt91npSOPc62+XaYOmPgO4ZZzag+M2OLaiqLna7cNTDb0
         YuuKbN6NTvToKkNiEG1vAZGA2Ji/vOMznMR58eig=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0917/1095] powerpc/32: Do not allow selection of e5500 or e6500 CPUs on PPC32
Date:   Mon, 15 Aug 2022 20:05:16 +0200
Message-Id: <20220815180507.213650069@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
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
index e2e1fec91c6e..660309559bd8 100644
--- a/arch/powerpc/platforms/Kconfig.cputype
+++ b/arch/powerpc/platforms/Kconfig.cputype
@@ -173,11 +173,11 @@ config POWER9_CPU
 
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



