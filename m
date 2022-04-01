Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 039484EE873
	for <lists+stable@lfdr.de>; Fri,  1 Apr 2022 08:39:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245483AbiDAGjs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Apr 2022 02:39:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245482AbiDAGiq (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 Apr 2022 02:38:46 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F6BF191425;
        Thu, 31 Mar 2022 23:36:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9DA46B81AF8;
        Fri,  1 Apr 2022 06:36:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E79E6C2BBE4;
        Fri,  1 Apr 2022 06:36:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1648795009;
        bh=w6xu1LSj+FUONL7lKRipQp69LEUzGRTWkhKltvzlhq8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Vr2b3MFgT2x/ckYMkCPum2N52IzeMzXl/jS1gVE45kNyOCbHqeHDd+4TpvdSkv7Iw
         dJkoUkvhQCWlmQS5a8vDprRDGDG6mwPClFd/1lM5FdxBoNAYZ4JVl11ZGCmUpuq2XG
         2ILulWnWyLfSeo3xbtX+jQvWGDMRSqZSGDlrBRU4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Catalin Marinas <catalin.marinas@arm.com>,
        James Morse <james.morse@arm.com>
Subject: [PATCH 4.14 02/27] arm64: arch_timer: avoid unused function warning
Date:   Fri,  1 Apr 2022 08:36:12 +0200
Message-Id: <20220401063624.302806313@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220401063624.232282121@linuxfoundation.org>
References: <20220401063624.232282121@linuxfoundation.org>
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
@@ -461,6 +461,7 @@ config ARM64_ERRATUM_1024718
 config ARM64_ERRATUM_1188873
 	bool "Cortex-A76: MRC read following MRRC read of specific Generic Timer in AArch32 might give incorrect result"
 	default y
+	select ARM_ARCH_TIMER_OOL_WORKAROUND
 	help
 	  This option adds work arounds for ARM Cortex-A76 erratum 1188873
 


