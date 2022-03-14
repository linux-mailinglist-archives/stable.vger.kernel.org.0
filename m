Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E841F4D8427
	for <lists+stable@lfdr.de>; Mon, 14 Mar 2022 13:22:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241540AbiCNMXF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Mar 2022 08:23:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243918AbiCNMVX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Mar 2022 08:21:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B27E11A23;
        Mon, 14 Mar 2022 05:18:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E73F960B04;
        Mon, 14 Mar 2022 12:18:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6030C340E9;
        Mon, 14 Mar 2022 12:18:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647260286;
        bh=DLjvPiW/foqqGXUYRry8oY7tm2GUXhAvY4eAkNeAkV8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b1j9yFI6cU+voZf5gsdF4lHqXNtsbtDid9pXi0aOYJA8QnLZGpRBcaliBFmehN4PA
         hr9bDO+Sl4Xpkw9VLRjy+DRdJRqyELCSCpSJ9DwopdUSIUVKn9iDp2c9cW8gi8ajUm
         SzQ1tx64O8cA0YlOUNnyW1rgNrjrbxE1fRch7FVY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nathan Chancellor <nathan@kernel.org>,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.16 104/121] ARM: fix Thumb2 regression with Spectre BHB
Date:   Mon, 14 Mar 2022 12:54:47 +0100
Message-Id: <20220314112747.015756286@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220314112744.120491875@linuxfoundation.org>
References: <20220314112744.120491875@linuxfoundation.org>
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

From: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

commit 6c7cb60bff7aec24b834343ff433125f469886a3 upstream.

When building for Thumb2, the vectors make use of a local label. Sadly,
the Spectre BHB code also uses a local label with the same number which
results in the Thumb2 reference pointing at the wrong place. Fix this
by changing the number used for the Spectre BHB local label.

Fixes: b9baf5c8c5c3 ("ARM: Spectre-BHB workaround")
Tested-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/kernel/entry-armv.S |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/arm/kernel/entry-armv.S
+++ b/arch/arm/kernel/entry-armv.S
@@ -1040,9 +1040,9 @@ vector_bhb_loop8_\name:
 
 	@ bhb workaround
 	mov	r0, #8
-1:	b	. + 4
+3:	b	. + 4
 	subs	r0, r0, #1
-	bne	1b
+	bne	3b
 	dsb
 	isb
 	b	2b


