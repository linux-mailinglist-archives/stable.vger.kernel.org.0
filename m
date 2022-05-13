Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99F9052645F
	for <lists+stable@lfdr.de>; Fri, 13 May 2022 16:30:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380817AbiEMO3t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 May 2022 10:29:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380867AbiEMO2X (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 13 May 2022 10:28:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 145EF5EBEB;
        Fri, 13 May 2022 07:27:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 961EF62154;
        Fri, 13 May 2022 14:27:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F965C34117;
        Fri, 13 May 2022 14:27:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652452055;
        bh=l0wXDFVrQkp+DaaqJRFPdaUiGUGaqXl4hB6va4+NAQs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uTSFOvf4OPMwD/MNeMApfgwb4P1pRKDPBoaHtvWRkmUX6mxf4Gzu+8v1nJjXOx2Le
         8MfLtrJ/fabmYNvdZn3TT3WPoIUEN7zKA80OiP0AfJwPpFXr1uTyX7P6lGXyFE2Wj6
         096O/lDWMBOT0IRo10IA4rULOqZJ8UalUXn80l/4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nick Desaulniers <ndesaulniers@google.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 05/10] nfp: bpf: silence bitwise vs. logical OR warning
Date:   Fri, 13 May 2022 16:23:49 +0200
Message-Id: <20220513142228.464257127@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220513142228.303546319@linuxfoundation.org>
References: <20220513142228.303546319@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Nathan Chancellor <nathan@kernel.org>

commit 8a64ef042eab8a6cec04a6c79d44d1af79b628ca upstream.

A new warning in clang points out two places in this driver where
boolean expressions are being used with a bitwise OR instead of a
logical one:

drivers/net/ethernet/netronome/nfp/nfp_asm.c:199:20: error: use of bitwise '|' with boolean operands [-Werror,-Wbitwise-instead-of-logical]
        reg->src_lmextn = swreg_lmextn(lreg) | swreg_lmextn(rreg);
                          ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
                                             ||
drivers/net/ethernet/netronome/nfp/nfp_asm.c:199:20: note: cast one or both operands to int to silence this warning
drivers/net/ethernet/netronome/nfp/nfp_asm.c:280:20: error: use of bitwise '|' with boolean operands [-Werror,-Wbitwise-instead-of-logical]
        reg->src_lmextn = swreg_lmextn(lreg) | swreg_lmextn(rreg);
                          ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
                                             ||
drivers/net/ethernet/netronome/nfp/nfp_asm.c:280:20: note: cast one or both operands to int to silence this warning
2 errors generated.

The motivation for the warning is that logical operations short circuit
while bitwise operations do not. In this case, it does not seem like
short circuiting is harmful so implement the suggested fix of changing
to a logical operation to fix the warning.

Link: https://github.com/ClangBuiltLinux/linux/issues/1479
Reported-by: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Link: https://lore.kernel.org/r/20211018193101.2340261-1-nathan@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/netronome/nfp/nfp_asm.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/net/ethernet/netronome/nfp/nfp_asm.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_asm.c
@@ -196,7 +196,7 @@ int swreg_to_unrestricted(swreg dst, swr
 	}
 
 	reg->dst_lmextn = swreg_lmextn(dst);
-	reg->src_lmextn = swreg_lmextn(lreg) | swreg_lmextn(rreg);
+	reg->src_lmextn = swreg_lmextn(lreg) || swreg_lmextn(rreg);
 
 	return 0;
 }
@@ -277,7 +277,7 @@ int swreg_to_restricted(swreg dst, swreg
 	}
 
 	reg->dst_lmextn = swreg_lmextn(dst);
-	reg->src_lmextn = swreg_lmextn(lreg) | swreg_lmextn(rreg);
+	reg->src_lmextn = swreg_lmextn(lreg) || swreg_lmextn(rreg);
 
 	return 0;
 }


