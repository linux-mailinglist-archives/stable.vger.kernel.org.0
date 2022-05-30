Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A26A537F16
	for <lists+stable@lfdr.de>; Mon, 30 May 2022 16:18:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239603AbiE3N5P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 May 2022 09:57:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238833AbiE3Nxr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 May 2022 09:53:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A710939D1;
        Mon, 30 May 2022 06:37:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C516B60FA2;
        Mon, 30 May 2022 13:37:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1603AC36AEA;
        Mon, 30 May 2022 13:37:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653917869;
        bh=yshcQHCPfHZtHbEvkMQsCzGrimfL7sMR4F4SAhXpLKo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=p8c/g5FdphfmUKEt0PlaGkhTP98Hqj07CdCzQN1o3eNleTyYRINbCxKmfPPkVFdB2
         gZqi9dUuNiCXBUlwfpSemtSq+Svx2ecYMNBhbCdETDpbCfCRDxze9mAzs3BDbwv1uZ
         jwDnKJUFH5o7XYOXXxIeShCKnQhfeNxutArQJ9nfCWfHTF4iaIMZxsQGRcITDuleY2
         9uC2b32oVHg0B9YMkR6MvK2nptMoqeB6C/aKdJm2lYhLaxDpyfxM0Zbp7noGyEz0kg
         ZigG6F3cTLRDNPu1QUehu60FHn5lIjhArb26QIRhFsSF2EURp0udLft+u/DYF+ZUe1
         LnYz4tF34Ngdg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Borislav Petkov <bp@suse.de>, Randy Dunlap <rdunlap@infradead.org>,
        Sasha Levin <sashal@kernel.org>, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org
Subject: [PATCH AUTOSEL 5.17 123/135] x86/microcode: Add explicit CPU vendor dependency
Date:   Mon, 30 May 2022 09:31:21 -0400
Message-Id: <20220530133133.1931716-123-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220530133133.1931716-1-sashal@kernel.org>
References: <20220530133133.1931716-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

[ Upstream commit 9c55d99e099bd7aa6b91fce8718505c35d5dfc65 ]

Add an explicit dependency to the respective CPU vendor so that the
respective microcode support for it gets built only when that support is
enabled.

Reported-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Borislav Petkov <bp@suse.de>
Link: https://lore.kernel.org/r/8ead0da9-9545-b10d-e3db-7df1a1f219e4@infradead.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/Kconfig | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index d0ecc4005df3..380c16ff5078 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1332,7 +1332,7 @@ config MICROCODE
 
 config MICROCODE_INTEL
 	bool "Intel microcode loading support"
-	depends on MICROCODE
+	depends on CPU_SUP_INTEL && MICROCODE
 	default MICROCODE
 	help
 	  This options enables microcode patch loading support for Intel
@@ -1344,7 +1344,7 @@ config MICROCODE_INTEL
 
 config MICROCODE_AMD
 	bool "AMD microcode loading support"
-	depends on MICROCODE
+	depends on CPU_SUP_AMD && MICROCODE
 	help
 	  If you select this option, microcode patch loading support for AMD
 	  processors will be enabled.
-- 
2.35.1

