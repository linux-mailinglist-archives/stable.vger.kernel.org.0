Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92B86561D61
	for <lists+stable@lfdr.de>; Thu, 30 Jun 2022 16:16:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235700AbiF3OFd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jun 2022 10:05:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236441AbiF3OEm (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Jun 2022 10:04:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D67B403D1;
        Thu, 30 Jun 2022 06:53:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BDD626204B;
        Thu, 30 Jun 2022 13:53:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1674C34115;
        Thu, 30 Jun 2022 13:53:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656597221;
        bh=PmnDGD1wvVsZRF/w/y92NUWwuEhPh2DN7+cm8pXrFxM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kkVO0Xh6C7+eHqYgrqipYyyra2Vk0jd5pI44Dt5o5pntXFKMcFw/i6Uq2kE6pnknY
         ccj6pUKiuwByf5fYXwZRTIeBdkI9ttjsc8JSmU48zOe93wmSyu618EsQGMnhz3tGa6
         1MUV5C+Ubr3/kDdQuBgIZRz81KSfW9MDQ4lxAToE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Jian Cai <caij2003@gmail.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: [PATCH 5.4 08/16] ARM: 8971/1: replace the sole use of a symbol with its definition
Date:   Thu, 30 Jun 2022 15:47:02 +0200
Message-Id: <20220630133231.184537231@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220630133230.936488203@linuxfoundation.org>
References: <20220630133230.936488203@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jian Cai <caij2003@gmail.com>

commit a780e485b5768e78aef087502499714901b68cc4 upstream

ALT_UP_B macro sets symbol up_b_offset via .equ to an expression
involving another symbol. The macro gets expanded twice when
arch/arm/kernel/sleep.S is assembled, creating a scenario where
up_b_offset is set to another expression involving symbols while its
current value is based on symbols. LLVM integrated assembler does not
allow such cases, and based on the documentation of binutils, "Values
that are based on expressions involving other symbols are allowed, but
some targets may restrict this to only being done once per assembly", so
it may be better to avoid such cases as it is not clearly stated which
targets should support or disallow them. The fix in this case is simple,
as up_b_offset has only one use, so we can replace the use with the
definition and get rid of up_b_offset.

 Link:https://github.com/ClangBuiltLinux/linux/issues/920

 Reviewed-by: Stefan Agner <stefan@agner.ch>

Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Jian Cai <caij2003@gmail.com>
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/include/asm/assembler.h |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/arch/arm/include/asm/assembler.h
+++ b/arch/arm/include/asm/assembler.h
@@ -279,10 +279,9 @@
 	.endif							;\
 	.popsection
 #define ALT_UP_B(label)					\
-	.equ	up_b_offset, label - 9998b			;\
 	.pushsection ".alt.smp.init", "a"			;\
 	.long	9998b						;\
-	W(b)	. + up_b_offset					;\
+	W(b)	. + (label - 9998b)					;\
 	.popsection
 #else
 #define ALT_SMP(instr...)


