Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0585540936
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 20:07:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349062AbiFGSGt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 14:06:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349606AbiFGSDl (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 14:03:41 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0466950028;
        Tue,  7 Jun 2022 10:47:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 36AD4B8233D;
        Tue,  7 Jun 2022 17:47:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D263C385A5;
        Tue,  7 Jun 2022 17:47:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654624027;
        bh=Do59Zxbar/R53/RRVCDrJBRmogE79B0Y/2QF3y0rC8U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yDjx+zHsAtiyJdpmXMQe4e8AxI+yXpICds6vVbTWxQlfMunjwYrtarHRmjRBsbxZv
         4Ux5vR69l3L08mDrOjSS3GtsOQCSheZF3f9WFIQ7PDTCqBWLYMGO0VmEDsTw9a1N0G
         //hmqRnNXPDdimbfNMw1+OjsromIzax11tEObJBQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>,
        Borislav Petkov <bp@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 137/667] x86/microcode: Add explicit CPU vendor dependency
Date:   Tue,  7 Jun 2022 18:56:42 +0200
Message-Id: <20220607164938.930244713@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164934.766888869@linuxfoundation.org>
References: <20220607164934.766888869@linuxfoundation.org>
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
index d02b04d30096..1d0f16b53393 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1323,7 +1323,7 @@ config MICROCODE
 
 config MICROCODE_INTEL
 	bool "Intel microcode loading support"
-	depends on MICROCODE
+	depends on CPU_SUP_INTEL && MICROCODE
 	default MICROCODE
 	help
 	  This options enables microcode patch loading support for Intel
@@ -1335,7 +1335,7 @@ config MICROCODE_INTEL
 
 config MICROCODE_AMD
 	bool "AMD microcode loading support"
-	depends on MICROCODE
+	depends on CPU_SUP_AMD && MICROCODE
 	help
 	  If you select this option, microcode patch loading support for AMD
 	  processors will be enabled.
-- 
2.35.1



