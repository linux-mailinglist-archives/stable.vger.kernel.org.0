Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72CF8537D40
	for <lists+stable@lfdr.de>; Mon, 30 May 2022 15:42:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237580AbiE3NiY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 May 2022 09:38:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235035AbiE3NhL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 May 2022 09:37:11 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99ABB82174;
        Mon, 30 May 2022 06:31:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4D7B5B80DB0;
        Mon, 30 May 2022 13:30:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C95C5C3411C;
        Mon, 30 May 2022 13:30:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653917457;
        bh=zyZ5vI2l/3gg/uoWaooDfVMf9ohSXQs2r2KPinSGMqM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pXTdU9+ktqSxK0KctUCk88cqIlUYLserGCp5/J7olRk609ZrncyhGVkgo22j6ML2G
         94fDl6NQnixFVsdQ6j6yweoV5roPQiVzWatwqoafz5iCRUx90hXluA8YsyISPs5A7x
         EctjWGnviKTSDWbZJlIjKAZg5TAA4m3vVJaEtkh1TkdHZ9bq/3HpMG1o7upZ6O7XYU
         Z11bBYMa1fQrWeiIdE3cJvSgphL4B0fVIfx6g6ZsceNzkcgvctiUX+l8FZMMky+zUF
         gd14Xnh54bSixt2fsGmm4kR/oHLVSIK6n3s1XE1LvwKvfhJEmGV/X0ukucjsnalLyU
         DZXY6EvRsw+iw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Borislav Petkov <bp@suse.de>, Randy Dunlap <rdunlap@infradead.org>,
        Sasha Levin <sashal@kernel.org>, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org
Subject: [PATCH AUTOSEL 5.18 145/159] x86/microcode: Add explicit CPU vendor dependency
Date:   Mon, 30 May 2022 09:24:10 -0400
Message-Id: <20220530132425.1929512-145-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220530132425.1929512-1-sashal@kernel.org>
References: <20220530132425.1929512-1-sashal@kernel.org>
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
index 4bed3abf444d..b2c65f573353 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1313,7 +1313,7 @@ config MICROCODE
 
 config MICROCODE_INTEL
 	bool "Intel microcode loading support"
-	depends on MICROCODE
+	depends on CPU_SUP_INTEL && MICROCODE
 	default MICROCODE
 	help
 	  This options enables microcode patch loading support for Intel
@@ -1325,7 +1325,7 @@ config MICROCODE_INTEL
 
 config MICROCODE_AMD
 	bool "AMD microcode loading support"
-	depends on MICROCODE
+	depends on CPU_SUP_AMD && MICROCODE
 	help
 	  If you select this option, microcode patch loading support for AMD
 	  processors will be enabled.
-- 
2.35.1

