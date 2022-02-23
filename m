Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD2684C14E3
	for <lists+stable@lfdr.de>; Wed, 23 Feb 2022 14:59:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241276AbiBWN7S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Feb 2022 08:59:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241271AbiBWN7P (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Feb 2022 08:59:15 -0500
Received: from mail-lj1-x22f.google.com (mail-lj1-x22f.google.com [IPv6:2a00:1450:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E871B0A50
        for <stable@vger.kernel.org>; Wed, 23 Feb 2022 05:58:47 -0800 (PST)
Received: by mail-lj1-x22f.google.com with SMTP id e8so16863944ljj.2
        for <stable@vger.kernel.org>; Wed, 23 Feb 2022 05:58:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=aHyzMFtQe0EUOGyo5aNMOVUBLvuCyxjF47uhkzb6m4c=;
        b=kErSueoTeHbWeWky89XlisWfN7RXR5Bflcws8Duv1Byb1Kjh6SF4QfOqyyH08ANsvr
         YCBvyKZjsm46rLQCoeD5JVy+tQiKQRI+WhZ4MZP6JubaTFlr24WPJHfFvjKfMFiv7n64
         /J+uOha29mNmckK7Skdqrj9iZ9ShzeHKZ+TEdPTJykePyCGNzgsCqXHq36TLn6MlMCmz
         pEogmT6UzYgfoCF1MgWeFvfNElXy0hAnBm+zOZ+C4sZ79i1L6ukdUe5xmf2b+0/OCBnr
         XXur+Bz41evUrrlQ8GLP01gv320vzdqUu3DMs6qv+PHpFSasxuk1NYXaot5vBdBdtShd
         1jdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=aHyzMFtQe0EUOGyo5aNMOVUBLvuCyxjF47uhkzb6m4c=;
        b=7cmHmkyTvlJnHQGWXRakpCH/ySS5u9fBzw6PSH75N3JB21Um3LkD4t6tnKbkS9s8E+
         CqBFzgw2sRIMJH413Z42WdMqXHBjrDoFylyiPV16dNchdmyPbrCSjPIc2MmB0zdBy/3q
         ZNVBp2llQdvsUC1JlUerTsfCBnitvwFGO+5NtvwSuHPtN0JDCL95ZRqYTW/POzlu6hZS
         4o6UkuYblT+FHCP0gKLqccxBIb8uUpYKwVfr3gLpHdRl1UV+lw4pxLruqYMGmcMfJjq+
         hsuSYW9JfXfkEeb3Mj9+70Qb/xhksMgSQxC3pUKmVlyWyIe2J4W9b7XEY+lzEiYsZw9n
         NIcg==
X-Gm-Message-State: AOAM532e246f9tA7PBnKNPM8jaOT6RkmiMPyEFrD5aXXTJlUh7Y1QjZW
        eRMB5RCNSRlBXkqQd+bdc+dwFA==
X-Google-Smtp-Source: ABdhPJy+EUB1iUZR6g+rNGOcfuP/RW3CsnyJ4DsE44Il+ubBCSVjVoKE42htrM/ebNo+fSdbSc3ufQ==
X-Received: by 2002:a05:651c:307:b0:244:dc4c:c2f2 with SMTP id a7-20020a05651c030700b00244dc4cc2f2mr20026151ljp.531.1645624725984;
        Wed, 23 Feb 2022 05:58:45 -0800 (PST)
Received: from localhost (c-9b28e555.07-21-73746f28.bbcust.telenor.se. [85.229.40.155])
        by smtp.gmail.com with ESMTPSA id v29sm2099448ljv.72.2022.02.23.05.58.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Feb 2022 05:58:45 -0800 (PST)
From:   Anders Roxell <anders.roxell@linaro.org>
To:     mpe@ellerman.id.au
Cc:     linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Anders Roxell <anders.roxell@linaro.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 3/3] powerpc: lib: sstep: fix build errors
Date:   Wed, 23 Feb 2022 14:58:20 +0100
Message-Id: <20220223135820.2252470-3-anders.roxell@linaro.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220223135820.2252470-1-anders.roxell@linaro.org>
References: <20220223135820.2252470-1-anders.roxell@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Building tinyconfig with gcc (Debian 11.2.0-16) and assembler (Debian
2.37.90.20220207) the following build error shows up:

{standard input}: Assembler messages:
{standard input}:10576: Error: unrecognized opcode: `stbcx.'
{standard input}:10680: Error: unrecognized opcode: `lharx'
{standard input}:10694: Error: unrecognized opcode: `lbarx'

Rework to add assembler directives [1] around the instruction.  The
problem with this might be that we can trick a power6 into
single-stepping through an stbcx. for instance, and it will execute that
in kernel mode.

[1] https://sourceware.org/binutils/docs/as/PowerPC_002dPseudo.html#PowerPC_002dPseudo

Cc: <stable@vger.kernel.org>
Co-developed-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Anders Roxell <anders.roxell@linaro.org>
---
 arch/powerpc/lib/sstep.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/powerpc/lib/sstep.c b/arch/powerpc/lib/sstep.c
index d2d29243fa6d..b9f43bbdd55a 100644
--- a/arch/powerpc/lib/sstep.c
+++ b/arch/powerpc/lib/sstep.c
@@ -1097,7 +1097,10 @@ NOKPROBE_SYMBOL(emulate_dcbz);
 
 #define __put_user_asmx(x, addr, err, op, cr)		\
 	__asm__ __volatile__(				\
+		".machine \"push\"\n"			\
+		".machine \"power8\"\n"			\
 		"1:	" op " %2,0,%3\n"		\
+		".machine \"pop\"\n"			\
 		"	mfcr	%1\n"			\
 		"2:\n"					\
 		".section .fixup,\"ax\"\n"		\
@@ -1110,7 +1113,10 @@ NOKPROBE_SYMBOL(emulate_dcbz);
 
 #define __get_user_asmx(x, addr, err, op)		\
 	__asm__ __volatile__(				\
+		".machine \"push\"\n"			\
+		".machine \"power8\"\n"			\
 		"1:	"op" %1,0,%2\n"			\
+		".machine \"pop\"\n"			\
 		"2:\n"					\
 		".section .fixup,\"ax\"\n"		\
 		"3:	li	%0,%3\n"		\
-- 
2.34.1

