Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03505608657
	for <lists+stable@lfdr.de>; Sat, 22 Oct 2022 09:48:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231598AbiJVHsN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Oct 2022 03:48:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231582AbiJVHrr (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Oct 2022 03:47:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7661048E9F;
        Sat, 22 Oct 2022 00:44:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1AF8D60B1B;
        Sat, 22 Oct 2022 07:38:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8FAFC433D6;
        Sat, 22 Oct 2022 07:38:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666424297;
        bh=tdIxaMXshIpDgKMPQUIn1JKQxwzuc+FAbzhb3VjbmOg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C3KvlSgueoNP/NOWS334O3KEveDhKXz0uf+29Zr/brkNg79WrBzJzUBnW719VP0c1
         qrsGITHA5fWK7J38U54Y5o1rXE2+VuZSItUQG14Sy6HG5Gdaig6gMzcaM71g0ltka/
         E8F3DW3aolSmniKM6NnwBe7sKoSzk2POTyUi3tR4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 5.19 092/717] powerpc/boot: Explicitly disable usage of SPE instructions
Date:   Sat, 22 Oct 2022 09:19:31 +0200
Message-Id: <20221022072431.642839091@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221022072415.034382448@linuxfoundation.org>
References: <20221022072415.034382448@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
 


