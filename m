Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2AAD4DC6AC
	for <lists+stable@lfdr.de>; Thu, 17 Mar 2022 13:54:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234231AbiCQMz3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Mar 2022 08:55:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234938AbiCQMyJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Mar 2022 08:54:09 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02817399;
        Thu, 17 Mar 2022 05:52:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B0834B81E01;
        Thu, 17 Mar 2022 12:52:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBE05C340E9;
        Thu, 17 Mar 2022 12:52:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647521570;
        bh=qyUSrm97P+ZfSNFz2/ZXRa42gbGKX1WKDF/8LJIGHEg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fnfoUsIACdV+0LmgLbz1osSFDSaRqvvtMy0vVv0zhpNq7CiLliVPQa/CgYcdO7X30
         GvMwsf4PREUBuPuVG6HD4LzEzR8lsmP8hCZr6YCzTWS8EGeJr0PYaPNzLGJif1Aylt
         dAPdZGQMRy6d+PMT0EO8tfToVbNhI5i7lS6tDcWQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Julian Braha <julianbraha@gmail.com>,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 14/28] ARM: 9178/1: fix unmet dependency on BITREVERSE for HAVE_ARCH_BITREVERSE
Date:   Thu, 17 Mar 2022 13:46:05 +0100
Message-Id: <20220317124527.173456091@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220317124526.768423926@linuxfoundation.org>
References: <20220317124526.768423926@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
index 5e7165e6a346..fa4b10322efc 100644
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



