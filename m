Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF7BC4D833E
	for <lists+stable@lfdr.de>; Mon, 14 Mar 2022 13:13:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241194AbiCNMNC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Mar 2022 08:13:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242877AbiCNMLL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Mar 2022 08:11:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AC62338AE;
        Mon, 14 Mar 2022 05:10:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AEA416135D;
        Mon, 14 Mar 2022 12:09:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4460C340EC;
        Mon, 14 Mar 2022 12:09:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647259798;
        bh=gCLJMVhTROye/SBdLcctGIL2mAAUBv6dbc1bY/smkoQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IPLpO6By0FrSujOoEGW12YZTqASc9qVQQHl57DxUA8X7lkoWyqmUia+NCl2cXxDNz
         qHSVkD2tsa+/+qo3dCJJMySkt6YcXY0Nau4VJRknBagcNN54sDFvpndoZAoZYjIuu2
         +XcTa8ImwWsb+94elhHrJi6/GBhgCU+HKBY31hTI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nathan Chancellor <nathan@kernel.org>,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.15 092/110] ARM: fix Thumb2 regression with Spectre BHB
Date:   Mon, 14 Mar 2022 12:54:34 +0100
Message-Id: <20220314112745.597288876@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220314112743.029192918@linuxfoundation.org>
References: <20220314112743.029192918@linuxfoundation.org>
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
@@ -1038,9 +1038,9 @@ vector_bhb_loop8_\name:
 
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


