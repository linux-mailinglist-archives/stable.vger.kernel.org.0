Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A52E84F6A57
	for <lists+stable@lfdr.de>; Wed,  6 Apr 2022 21:48:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232646AbiDFTu0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Apr 2022 15:50:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232417AbiDFTtg (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Apr 2022 15:49:36 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B3D518BCFD;
        Wed,  6 Apr 2022 11:27:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 7D895CE24A6;
        Wed,  6 Apr 2022 18:27:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A197C385A1;
        Wed,  6 Apr 2022 18:27:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649269643;
        bh=Litla4dQ6FJ4XIrqe0GBrFnwKM6GLSoVgCqTTyuj7+g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u4gTRVEmtREQeHX9NOyZ2RT/psDtnsZKTL/7LTxomCqWgMft/1x4jBB7eQjCPtIgD
         rKGXcewE4Z71iK1Y7m3uF9rmYwqMUnMeRh9ziChagWJq6+KhqqE1FLP+jFUY3AROC0
         Kc8uBue+hR0yBjzZ79jFnkibXxpQrKAgFSjC2ERE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Catalin Marinas <catalin.marinas@arm.com>,
        James Morse <james.morse@arm.com>
Subject: [PATCH 4.9 17/43] arm64: arch_timer: avoid unused function warning
Date:   Wed,  6 Apr 2022 20:26:26 +0200
Message-Id: <20220406182437.184811467@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220406182436.675069715@linuxfoundation.org>
References: <20220406182436.675069715@linuxfoundation.org>
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

From: Arnd Bergmann <arnd@arndb.de>

commit 040f340134751d73bd03ee92fabb992946c55b3d upstream.

arm64_1188873_read_cntvct_el0() is protected by the correct
CONFIG_ARM64_ERRATUM_1188873 #ifdef, but the only reference to it is
also inside of an CONFIG_ARM_ARCH_TIMER_OOL_WORKAROUND section,
and causes a warning if that is disabled:

drivers/clocksource/arm_arch_timer.c:323:20: error: 'arm64_1188873_read_cntvct_el0' defined but not used [-Werror=unused-function]

Since the erratum requires that we always apply the workaround
in the timer driver, select that symbol as we do for SoC
specific errata.

Fixes: 95b861a4a6d9 ("arm64: arch_timer: Add workaround for ARM erratum 1188873")
Acked-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: James Morse <james.morse@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -444,6 +444,7 @@ config ARM64_ERRATUM_1024718
 config ARM64_ERRATUM_1188873
 	bool "Cortex-A76: MRC read following MRRC read of specific Generic Timer in AArch32 might give incorrect result"
 	default y
+	select ARM_ARCH_TIMER_OOL_WORKAROUND
 	help
 	  This option adds work arounds for ARM Cortex-A76 erratum 1188873
 


