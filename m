Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DAF71541317
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 21:56:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357846AbiFGTzy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 15:55:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358661AbiFGTwt (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 15:52:49 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E15D50466;
        Tue,  7 Jun 2022 11:21:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 474C1CE244E;
        Tue,  7 Jun 2022 18:21:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3632FC385A2;
        Tue,  7 Jun 2022 18:21:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654626115;
        bh=o1okmvwlLbbSfG3kdZ8LEKllXVWDEzZvHhSawU1CUr4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uJEmZy+mhQWnDOtnMuSZGXSToKJBQpu7TFLGPXVvLCgC90H2UycMd+E0sx7BDMO5p
         3afQNMta9ap3/jhEeKbeJnC5A1PLOqL55ynUDEplNbukMv9npyz/JJoOTMbdyl6ABs
         8VjFpSKpSSiWTWp4yZ1yX/sU2HLdnI7y89HxP5qw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexander Larsson <alexl@redhat.com>,
        Javier Martinez Canillas <javierm@redhat.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 264/772] efi: Allow to enable EFI runtime services by default on RT
Date:   Tue,  7 Jun 2022 18:57:36 +0200
Message-Id: <20220607164956.803676418@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164948.980838585@linuxfoundation.org>
References: <20220607164948.980838585@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Javier Martinez Canillas <javierm@redhat.com>

[ Upstream commit a031651ff2144a3d81d4916856c093bc1ea0a413 ]

Commit d9f283ae71af ("efi: Disable runtime services on RT") disabled EFI
runtime services by default when the CONFIG_PREEMPT_RT option is enabled.

The rationale for that commit is that some EFI calls could take too much
time, leading to large latencies which is an issue for Real-Time kernels.

But a side effect of that change was that now is not possible anymore to
enable the EFI runtime services by default when CONFIG_PREEMPT_RT is set,
without passing an efi=runtime command line parameter to the kernel.

Instead, let's add a new EFI_DISABLE_RUNTIME boolean Kconfig option, that
would be set to n by default but to y if CONFIG_PREEMPT_RT is enabled.

That way, the current behaviour is preserved but gives users a mechanism
to enable the EFI runtimes services in their kernels if that is required.
For example, if the firmware could guarantee bounded time for EFI calls.

Also, having a separate boolean config could allow users to disable the
EFI runtime services by default even when CONFIG_PREEMPT_RT is not set.

Reported-by: Alexander Larsson <alexl@redhat.com>
Fixes: d9f283ae71af ("efi: Disable runtime services on RT")
Signed-off-by: Javier Martinez Canillas <javierm@redhat.com>
Link: https://lore.kernel.org/r/20220331151654.184433-1-javierm@redhat.com
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/efi/Kconfig | 15 +++++++++++++++
 drivers/firmware/efi/efi.c   |  2 +-
 2 files changed, 16 insertions(+), 1 deletion(-)

diff --git a/drivers/firmware/efi/Kconfig b/drivers/firmware/efi/Kconfig
index 2c3dac5ecb36..243882f5e5f9 100644
--- a/drivers/firmware/efi/Kconfig
+++ b/drivers/firmware/efi/Kconfig
@@ -284,3 +284,18 @@ config EFI_CUSTOM_SSDT_OVERLAYS
 
 	  See Documentation/admin-guide/acpi/ssdt-overlays.rst for more
 	  information.
+
+config EFI_DISABLE_RUNTIME
+	bool "Disable EFI runtime services support by default"
+	default y if PREEMPT_RT
+	help
+	  Allow to disable the EFI runtime services support by default. This can
+	  already be achieved by using the efi=noruntime option, but it could be
+	  useful to have this default without any kernel command line parameter.
+
+	  The EFI runtime services are disabled by default when PREEMPT_RT is
+	  enabled, because measurements have shown that some EFI functions calls
+	  might take too much time to complete, causing large latencies which is
+	  an issue for Real-Time kernels.
+
+	  This default can be overridden by using the efi=runtime option.
diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
index 5502e176d51b..ff57db8f8d05 100644
--- a/drivers/firmware/efi/efi.c
+++ b/drivers/firmware/efi/efi.c
@@ -66,7 +66,7 @@ struct mm_struct efi_mm = {
 
 struct workqueue_struct *efi_rts_wq;
 
-static bool disable_runtime = IS_ENABLED(CONFIG_PREEMPT_RT);
+static bool disable_runtime = IS_ENABLED(CONFIG_EFI_DISABLE_RUNTIME);
 static int __init setup_noefi(char *arg)
 {
 	disable_runtime = true;
-- 
2.35.1



