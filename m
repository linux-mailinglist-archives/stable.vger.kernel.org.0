Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44F3053190D
	for <lists+stable@lfdr.de>; Mon, 23 May 2022 22:54:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241401AbiEWRdS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 May 2022 13:33:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241094AbiEWR0R (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 May 2022 13:26:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FFF362122;
        Mon, 23 May 2022 10:21:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BE425B81219;
        Mon, 23 May 2022 17:21:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20811C385A9;
        Mon, 23 May 2022 17:21:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653326481;
        bh=mqkDz9dWwDNFalE5Rbuyg+FfWCGLAoMOK3GmkLsN3a8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ab7a5lbBOIzz/IxF7Py7xzHienSE3CdEYITPTIlcFavRdyLd5wEJTLaaMxBLYayxB
         n0XC4PKQgiwCYgt/Q2gMG2i5DUrdvKOMKSlTt6HDmXQLC/KH0VTG+54ZQ+Wc/7A/dF
         n25CbPSo/zBAG/KafyUbj7vr0RUtYJGsCwMNlXtg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 094/132] ARM: 9197/1: spectre-bhb: fix loop8 sequence for Thumb2
Date:   Mon, 23 May 2022 19:05:03 +0200
Message-Id: <20220523165838.921730840@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220523165823.492309987@linuxfoundation.org>
References: <20220523165823.492309987@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ard Biesheuvel <ardb@kernel.org>

[ Upstream commit 3cfb3019979666bdf33a1010147363cf05e0f17b ]

In Thumb2, 'b . + 4' produces a branch instruction that uses a narrow
encoding, and so it does not jump to the following instruction as
expected. So use W(b) instead.

Fixes: 6c7cb60bff7a ("ARM: fix Thumb2 regression with Spectre BHB")
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/kernel/entry-armv.S | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/kernel/entry-armv.S b/arch/arm/kernel/entry-armv.S
index 46b697dfa4cf..68261a83b7ad 100644
--- a/arch/arm/kernel/entry-armv.S
+++ b/arch/arm/kernel/entry-armv.S
@@ -1038,7 +1038,7 @@ vector_bhb_loop8_\name:
 
 	@ bhb workaround
 	mov	r0, #8
-3:	b	. + 4
+3:	W(b)	. + 4
 	subs	r0, r0, #1
 	bne	3b
 	dsb
-- 
2.35.1



