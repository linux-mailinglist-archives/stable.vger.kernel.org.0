Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4FA3660B8ED
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 22:00:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233710AbiJXT7x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 15:59:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234216AbiJXT72 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 15:59:28 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BFF73DBE3;
        Mon, 24 Oct 2022 11:22:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8D1CEB818D6;
        Mon, 24 Oct 2022 12:37:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2BFCC433D6;
        Mon, 24 Oct 2022 12:37:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666615036;
        bh=tdIxaMXshIpDgKMPQUIn1JKQxwzuc+FAbzhb3VjbmOg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OVrI5GV0aGIJNEUwDpu2oJNgjJMwylIdjpEkgKyVB/EPDfOrIy7dfacPZDThlyrJI
         5cr80jklFV8CKpSqAcTHk3hfOmxJh/tFNL2spSNmSi004KF/89emxu0iwvRomscBy+
         umlbr0GCVnb7YibLznIvPaEpTy1UCKwT5MS+t9UQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 5.15 068/530] powerpc/boot: Explicitly disable usage of SPE instructions
Date:   Mon, 24 Oct 2022 13:26:52 +0200
Message-Id: <20221024113048.105505528@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113044.976326639@linuxfoundation.org>
References: <20221024113044.976326639@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pali Rohár <pali@kernel.org>

commit 110a58b9f91c66f743c01a2c217243d94c899c23 upstream.

uImage boot wrapper should not use SPE instructions, like kernel itself.
Boot wrapper has already disabled Altivec and VSX instructions but not SPE.
Options -mno-spe and -mspe=no already set when compilation of kernel, but
not when compiling uImage wrapper yet. Fix it.

Cc: stable@vger.kernel.org
Signed-off-by: Pali Rohár <pali@kernel.org>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20220827134454.17365-1-pali@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/boot/Makefile |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/powerpc/boot/Makefile
+++ b/arch/powerpc/boot/Makefile
@@ -34,6 +34,7 @@ endif
 
 BOOTCFLAGS    := -Wall -Wundef -Wstrict-prototypes -Wno-trigraphs \
 		 -fno-strict-aliasing -O2 -msoft-float -mno-altivec -mno-vsx \
+		 $(call cc-option,-mno-spe) $(call cc-option,-mspe=no) \
 		 -pipe -fomit-frame-pointer -fno-builtin -fPIC -nostdinc \
 		 $(LINUXINCLUDE)
 


