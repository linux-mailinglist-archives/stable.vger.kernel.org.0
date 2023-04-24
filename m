Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBAD86ECF09
	for <lists+stable@lfdr.de>; Mon, 24 Apr 2023 15:37:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232635AbjDXNht (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Apr 2023 09:37:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232665AbjDXNhg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Apr 2023 09:37:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77C319EF9
        for <stable@vger.kernel.org>; Mon, 24 Apr 2023 06:36:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 47A50623E3
        for <stable@vger.kernel.org>; Mon, 24 Apr 2023 13:36:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56A35C433D2;
        Mon, 24 Apr 2023 13:36:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1682343415;
        bh=/DqfXu+qW5izewF+kSfBLxoYDo52LAZ+ZZmDVF5XaoY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Pnzkzz8fWi2SSNMUsq4HzuGNLJaeVHJiHH2kt+zzOgBqFvU4KHhI3FzuKAGpvEI5u
         0pmx8aphQo3sTpbyJXjPklDSMxnWTplD88QXNZytPTyUIEEMK59EJt9wjBlLSC4I2g
         XbVSFnpkoJNMoCTMSrXiTirX/SxBlt6Vq4NrfgLc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Pingfan Liu <kernelfans@gmail.com>,
        Ingo Molnar <mingo@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Steve Wahl <steve.wahl@hpe.com>,
        Dave Young <dyoung@redhat.com>, Alyssa Ross <hi@alyssa.is>
Subject: [PATCH 4.14 17/28] x86/purgatory: Dont generate debug info for purgatory.ro
Date:   Mon, 24 Apr 2023 15:18:38 +0200
Message-Id: <20230424131121.889146262@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230424131121.331252806@linuxfoundation.org>
References: <20230424131121.331252806@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pingfan Liu <kernelfans@gmail.com>

commit 52416ffcf823ee11aa19792715664ab94757f111 upstream.

Purgatory.ro is a standalone binary that is not linked against the rest of
the kernel.  Its image is copied into an array that is linked to the
kernel, and from there kexec relocates it wherever it desires.

Unlike the debug info for vmlinux, which can be used for analyzing crash
such info is useless in purgatory.ro. And discarding them can save about
200K space.

 Original:
   259080  kexec-purgatory.o
 Stripped debug info:
    29152  kexec-purgatory.o

Signed-off-by: Pingfan Liu <kernelfans@gmail.com>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Reviewed-by: Steve Wahl <steve.wahl@hpe.com>
Acked-by: Dave Young <dyoung@redhat.com>
Link: https://lore.kernel.org/r/1596433788-3784-1-git-send-email-kernelfans@gmail.com
Signed-off-by: Alyssa Ross <hi@alyssa.is>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/purgatory/Makefile |    3 +++
 1 file changed, 3 insertions(+)

--- a/arch/x86/purgatory/Makefile
+++ b/arch/x86/purgatory/Makefile
@@ -20,6 +20,9 @@ KBUILD_CFLAGS := -fno-strict-aliasing -W
 KBUILD_CFLAGS += -m$(BITS)
 KBUILD_CFLAGS += $(call cc-option,-fno-PIE)
 
+AFLAGS_REMOVE_setup-x86_$(BITS).o	+= -Wa,-gdwarf-2
+AFLAGS_REMOVE_entry64.o			+= -Wa,-gdwarf-2
+
 $(obj)/purgatory.ro: $(PURGATORY_OBJS) FORCE
 		$(call if_changed,ld)
 


