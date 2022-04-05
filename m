Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3AAE4F3A08
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 16:58:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379050AbiDELkJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 07:40:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354247AbiDEKMi (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 06:12:38 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD0875D5E5;
        Tue,  5 Apr 2022 02:59:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 1C4A0CE1C9D;
        Tue,  5 Apr 2022 09:59:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F541C385A3;
        Tue,  5 Apr 2022 09:59:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649152764;
        bh=+meF9PkKtpTanUbYRtKk8E3df2KpV2NIkMy3Tats4EA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GZnkvJe5at6W2eecfZfGUhu7xeiky2bwaVMsQctIeLzOEpb/LLI74QbJPtUYRJuVV
         kxnxMDrk6i2YZGqWJfx5Khh7aivLtgFwNnXLHFxFhMN7iU40xU4nPE3vCK/n4g1S3e
         +D5qGcYOazFPMrPYD2Hdk2mIPXbfP+o8PeUvHC94=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Will Deacon <will@kernel.org>
Subject: [PATCH 5.15 867/913] arm64: mm: Drop const from conditional arm64_dma_phys_limit definition
Date:   Tue,  5 Apr 2022 09:32:09 +0200
Message-Id: <20220405070405.812254309@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070339.801210740@linuxfoundation.org>
References: <20220405070339.801210740@linuxfoundation.org>
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

From: Will Deacon <will@kernel.org>

commit 770093459b9b333380aa71f2c31c60b14895c1df upstream.

Commit 031495635b46 ("arm64: Do not defer reserve_crashkernel() for
platforms with no DMA memory zones") introduced different definitions
for 'arm64_dma_phys_limit' depending on CONFIG_ZONE_DMA{,32} based on
a late suggestion from Pasha. Sadly, this results in a build error when
passing W=1:

  | arch/arm64/mm/init.c:90:19: error: conflicting type qualifiers for 'arm64_dma_phys_limit'

Drop the 'const' for now and use '__ro_after_init' consistently.

Link: https://lore.kernel.org/r/202203090241.aj7paWeX-lkp@intel.com
Link: https://lore.kernel.org/r/CA+CK2bDbbx=8R=UthkMesWOST8eJMtOGJdfMRTFSwVmo0Vn0EA@mail.gmail.com
Fixes: 031495635b46 ("arm64: Do not defer reserve_crashkernel() for platforms with no DMA memory zones")
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/mm/init.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm64/mm/init.c
+++ b/arch/arm64/mm/init.c
@@ -87,7 +87,7 @@ EXPORT_SYMBOL(memstart_addr);
 #if IS_ENABLED(CONFIG_ZONE_DMA) || IS_ENABLED(CONFIG_ZONE_DMA32)
 phys_addr_t __ro_after_init arm64_dma_phys_limit;
 #else
-const phys_addr_t arm64_dma_phys_limit = PHYS_MASK + 1;
+phys_addr_t __ro_after_init arm64_dma_phys_limit = PHYS_MASK + 1;
 #endif
 
 #ifdef CONFIG_KEXEC_CORE


