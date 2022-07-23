Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F58957EE65
	for <lists+stable@lfdr.de>; Sat, 23 Jul 2022 12:10:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239173AbiGWKKY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 23 Jul 2022 06:10:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239612AbiGWKJq (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 23 Jul 2022 06:09:46 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10DC9CE53B;
        Sat, 23 Jul 2022 03:03:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 04951CE0B68;
        Sat, 23 Jul 2022 10:03:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 073ABC341C7;
        Sat, 23 Jul 2022 10:02:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658570579;
        bh=BrG/XoHrnxpbzose77TytGGeC3aIeV236WuPjsEdWSU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s3WdleQGB9eMgk2iOVc3uRkFR8zKmzqGnabGBT7HcgFycB39JCry16z3UcVP1vHb4
         NvJ1MQ50pyz5LWdZMyS2yiBw7FbBxMbVTwcjnS+eG/Th3mWFCQRtKvhaHeCrJQEFF6
         hzfjTvoHIgLtj1SERE3z2ZOLzaZccaIKoVszt5Fc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vasily Gorbik <gor@linux.ibm.com>,
        Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 5.10 146/148] objtool: Fix elf_create_undef_symbol() endianness
Date:   Sat, 23 Jul 2022 11:55:58 +0200
Message-Id: <20220723095305.214720457@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220723095224.302504400@linuxfoundation.org>
References: <20220723095224.302504400@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vasily Gorbik <gor@linux.ibm.com>

commit 46c7405df7de8deb97229eacebcee96d61415f3f upstream.

Currently x86 cross-compilation fails on big endian system with:

  x86_64-cross-ld: init/main.o: invalid string offset 488112128 >= 6229 for section `.strtab'

Mark new ELF data in elf_create_undef_symbol() as symbol, so that libelf
does endianness handling correctly.

Fixes: 2f2f7e47f052 ("objtool: Add elf_create_undef_symbol()")
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: https://lore.kernel.org/r/patch-1.thread-6c9df9.git-d39264656387.your-ad-here.call-01620841104-ext-2554@work.hours
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/objtool/elf.c |    1 +
 1 file changed, 1 insertion(+)

--- a/tools/objtool/elf.c
+++ b/tools/objtool/elf.c
@@ -961,6 +961,7 @@ static int elf_add_string(struct elf *el
 	data->d_buf = str;
 	data->d_size = strlen(str) + 1;
 	data->d_align = 1;
+	data->d_type = ELF_T_SYM;
 
 	len = strtab->len;
 	strtab->len += data->d_size;


