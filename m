Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59DC34D3707
	for <lists+stable@lfdr.de>; Wed,  9 Mar 2022 18:44:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236517AbiCIQfy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Mar 2022 11:35:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235849AbiCIQ2S (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Mar 2022 11:28:18 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3135857B35;
        Wed,  9 Mar 2022 08:22:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CBE5EB82257;
        Wed,  9 Mar 2022 16:22:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BCD5C36AF6;
        Wed,  9 Mar 2022 16:22:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646842968;
        bh=VYVcfnVnx/Tdehb1QMOWLr7+5uCZw+26ot3WJBmmkec=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eiVgbPe4qYDBmPBf3HjVCPpugiTXCm5S8nIInblsB6znVX9NGHdHWmQ4uhC9GDMDO
         ZaOFDN1GMWChJG4d5hvQPHnW+9yPNdPtN9CxVNz8B+Yi8CIqkssxA+EdDwMn+JRoM3
         QGYlF752I6ak1j5wzE23lQCZ91KmKU6W6h36ySoNHLDpr/rGv4Q7MPpA/oEd147DoQ
         MLeh/UPoEYNN+uETwdFp7S42OOTAplscZwXckIRsd0H5DJsKPknQh5aUPtAzvkobtQ
         GuxNAo4OGP7NeDwagMmVDo9UQrPmp808mp8I4EGZUJxYbLtB/d/UMonN759eRiGeWt
         463J08aRez2oA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Julian Braha <julianbraha@gmail.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Sasha Levin <sashal@kernel.org>, jarkko@kernel.org,
        johannes.berg@intel.com, mcroce@microsoft.com, deller@gmx.de,
        James.Bottomley@HansenPartnership.com, arnd@arndb.de
Subject: [PATCH AUTOSEL 5.10 10/20] ARM: 9178/1: fix unmet dependency on BITREVERSE for HAVE_ARCH_BITREVERSE
Date:   Wed,  9 Mar 2022 11:21:48 -0500
Message-Id: <20220309162158.136467-10-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220309162158.136467-1-sashal@kernel.org>
References: <20220309162158.136467-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Julian Braha <julianbraha@gmail.com>

[ Upstream commit 11c57c3ba94da74c3446924260e34e0b1950b5d7 ]

Resending this to properly add it to the patch tracker - thanks for letting
me know, Arnd :)

When ARM is enabled, and BITREVERSE is disabled,
Kbuild gives the following warning:

WARNING: unmet direct dependencies detected for HAVE_ARCH_BITREVERSE
  Depends on [n]: BITREVERSE [=n]
  Selected by [y]:
  - ARM [=y] && (CPU_32v7M [=n] || CPU_32v7 [=y]) && !CPU_32v6 [=n]

This is because ARM selects HAVE_ARCH_BITREVERSE
without selecting BITREVERSE, despite
HAVE_ARCH_BITREVERSE depending on BITREVERSE.

This unmet dependency bug was found by Kismet,
a static analysis tool for Kconfig. Please advise if this
is not the appropriate solution.

Signed-off-by: Julian Braha <julianbraha@gmail.com>
Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/Kconfig | 1 -
 1 file changed, 1 deletion(-)

diff --git a/lib/Kconfig b/lib/Kconfig
index b46a9fd122c8..9216e24e5164 100644
--- a/lib/Kconfig
+++ b/lib/Kconfig
@@ -45,7 +45,6 @@ config BITREVERSE
 config HAVE_ARCH_BITREVERSE
 	bool
 	default n
-	depends on BITREVERSE
 	help
 	  This option enables the use of hardware bit-reversal instructions on
 	  architectures which support such operations.
-- 
2.34.1

