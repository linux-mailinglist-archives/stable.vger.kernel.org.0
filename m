Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80CEB50159A
	for <lists+stable@lfdr.de>; Thu, 14 Apr 2022 17:42:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245538AbiDNNnf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 09:43:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343549AbiDNN3e (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 09:29:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8AB01F61B;
        Thu, 14 Apr 2022 06:24:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 54B6860C1C;
        Thu, 14 Apr 2022 13:24:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AD7FC385A1;
        Thu, 14 Apr 2022 13:24:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649942674;
        bh=fLFdu69ZdmjCWTnbEimeUOpy+WkYLnMypeNvm/pjQjY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FfaTqw+p5GmcTphSl7Z80kzZjHee87ZywzE8HwtZbWa+Y1ilXbTX0zMW73vpHWNKH
         3FyjVIvpTdWRV9j/4hkji744vlEV9B/8GAyqhQQ66jqcXetIwgzRZtiqAu3XLo4MEv
         x8sMtMqvwNKU1ZxIhVmqXTbgDoX5jEmILWL4domg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Anders Roxell <anders.roxell@linaro.org>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 4.19 220/338] powerpc/lib/sstep: Fix sthcx instruction
Date:   Thu, 14 Apr 2022 15:12:03 +0200
Message-Id: <20220414110845.153897040@linuxfoundation.org>
X-Mailer: git-send-email 2.35.2
In-Reply-To: <20220414110838.883074566@linuxfoundation.org>
References: <20220414110838.883074566@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Anders Roxell <anders.roxell@linaro.org>

commit a633cb1edddaa643fadc70abc88f89a408fa834a upstream.

Looks like there been a copy paste mistake when added the instruction
'stbcx' twice and one was probably meant to be 'sthcx'. Changing to
'sthcx' from 'stbcx'.

Fixes: 350779a29f11 ("powerpc: Handle most loads and stores in instruction emulation code")
Cc: stable@vger.kernel.org # v4.14+
Reported-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Anders Roxell <anders.roxell@linaro.org>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20220224162215.3406642-1-anders.roxell@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/lib/sstep.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/powerpc/lib/sstep.c
+++ b/arch/powerpc/lib/sstep.c
@@ -2806,7 +2806,7 @@ int emulate_loadstore(struct pt_regs *re
 			__put_user_asmx(op->val, ea, err, "stbcx.", cr);
 			break;
 		case 2:
-			__put_user_asmx(op->val, ea, err, "stbcx.", cr);
+			__put_user_asmx(op->val, ea, err, "sthcx.", cr);
 			break;
 #endif
 		case 4:


