Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B29555AEC8E
	for <lists+stable@lfdr.de>; Tue,  6 Sep 2022 16:28:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239581AbiIFOFT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Sep 2022 10:05:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241502AbiIFOEm (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Sep 2022 10:04:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 347367F119;
        Tue,  6 Sep 2022 06:45:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F17AD6154E;
        Tue,  6 Sep 2022 13:44:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FAF6C433D7;
        Tue,  6 Sep 2022 13:44:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662471853;
        bh=2ksWF3+Dh8PKAjG4HgagqD1gFfPasKEasH82ovX11Ls=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xi6tyNkjKNS0U3Yfi5PklvY/e3u/AB2aflU3s3THnrbJTP21vQukB6v2+oriIm/sU
         pUGtnXNJ5qxphJ+0TjtJuKHC1WHoP7Q0sfzEGSSbjPJ45ZRCIa6CjvdHgfoIxgocQ4
         vm5MRbiuvVY4ECt2Kr8AZ7iSx/6RHXQWEUXNM5zQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 5.19 061/155] Revert "powerpc: Remove unused FW_FEATURE_NATIVE references"
Date:   Tue,  6 Sep 2022 15:30:09 +0200
Message-Id: <20220906132832.010980486@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220906132829.417117002@linuxfoundation.org>
References: <20220906132829.417117002@linuxfoundation.org>
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

From: Michael Ellerman <mpe@ellerman.id.au>

commit 310d1344e3c58cc2d625aa4e52cfcb7d8a26fcbf upstream.

This reverts commit 79b74a68486765a4fe685ac4069bc71366c538f5.

It broke booting on IBM Cell machines when the kernel is also built with
CONFIG_PPC_PS3=y.

That's because FW_FEATURE_NATIVE_ALWAYS = 0 does have an important
effect, which is to clear the PS3 ALWAYS features from
FW_FEATURE_ALWAYS.

Note that CONFIG_PPC_NATIVE has since been renamed
CONFIG_PPC_HASH_MMU_NATIVE.

Fixes: 79b74a684867 ("powerpc: Remove unused FW_FEATURE_NATIVE references")
Cc: stable@vger.kernel.org # v5.17+
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20220823115952.1203106-1-mpe@ellerman.id.au
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/include/asm/firmware.h |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/arch/powerpc/include/asm/firmware.h
+++ b/arch/powerpc/include/asm/firmware.h
@@ -82,6 +82,8 @@ enum {
 	FW_FEATURE_POWERNV_ALWAYS = 0,
 	FW_FEATURE_PS3_POSSIBLE = FW_FEATURE_LPAR | FW_FEATURE_PS3_LV1,
 	FW_FEATURE_PS3_ALWAYS = FW_FEATURE_LPAR | FW_FEATURE_PS3_LV1,
+	FW_FEATURE_NATIVE_POSSIBLE = 0,
+	FW_FEATURE_NATIVE_ALWAYS = 0,
 	FW_FEATURE_POSSIBLE =
 #ifdef CONFIG_PPC_PSERIES
 		FW_FEATURE_PSERIES_POSSIBLE |
@@ -92,6 +94,9 @@ enum {
 #ifdef CONFIG_PPC_PS3
 		FW_FEATURE_PS3_POSSIBLE |
 #endif
+#ifdef CONFIG_PPC_HASH_MMU_NATIVE
+		FW_FEATURE_NATIVE_ALWAYS |
+#endif
 		0,
 	FW_FEATURE_ALWAYS =
 #ifdef CONFIG_PPC_PSERIES
@@ -103,6 +108,9 @@ enum {
 #ifdef CONFIG_PPC_PS3
 		FW_FEATURE_PS3_ALWAYS &
 #endif
+#ifdef CONFIG_PPC_HASH_MMU_NATIVE
+		FW_FEATURE_NATIVE_ALWAYS &
+#endif
 		FW_FEATURE_POSSIBLE,
 
 #else /* CONFIG_PPC64 */


