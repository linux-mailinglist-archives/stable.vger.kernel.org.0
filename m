Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B30974BDFA8
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 18:50:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347885AbiBUJQu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 04:16:50 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:33874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348417AbiBUJLR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 04:11:17 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09F0824F08;
        Mon, 21 Feb 2022 01:03:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id D2879CE0E7F;
        Mon, 21 Feb 2022 09:03:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC45FC340E9;
        Mon, 21 Feb 2022 09:03:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645434199;
        bh=QVnAG+Gwt43QS9jbOGyZkXWfiZPYDLsCzmY88sQRMZ4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JtCiaXBsiZ+xRIFie4yZYz1qgyONnbBRKPzpTshaF5yDlO9cfll4asweQ5zOkI3Ch
         ORNuxIOCUUQJGBGdK5iq/y06ioinXOLusapMeOOPVQgHaHeVWJMWgN0Av4ohQmrqDO
         wUNcVEuZkSUto8yDRiigHiYrvAnKQmWnOkgcpT30=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nick Desaulniers <ndesaulniers@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Sami Tolvanen <samitolvanen@google.com>,
        Kees Cook <keescook@chromium.org>,
        Stephen Boyd <swboyd@chromium.org>
Subject: [PATCH 5.10 046/121] kbuild: lto: Merge module sections if and only if CONFIG_LTO_CLANG is enabled
Date:   Mon, 21 Feb 2022 09:48:58 +0100
Message-Id: <20220221084922.767725960@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220221084921.147454846@linuxfoundation.org>
References: <20220221084921.147454846@linuxfoundation.org>
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

From: Sean Christopherson <seanjc@google.com>

commit 6a3193cdd5e5b96ac65f04ee42555c216da332af upstream.

Merge module sections only when using Clang LTO. With ld.bfd, merging
sections does not appear to update the symbol tables for the module,
e.g. 'readelf -s' shows the value that a symbol would have had, if
sections were not merged. ld.lld does not show this problem.

The stale symbol table breaks gdb's function disassembler, and presumably
other things, e.g.

  gdb -batch -ex "file arch/x86/kvm/kvm.ko" -ex "disassemble kvm_init"

reads the wrong bytes and dumps garbage.

Fixes: dd2776222abb ("kbuild: lto: merge module sections")
Cc: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Sami Tolvanen <samitolvanen@google.com>
Tested-by: Sami Tolvanen <samitolvanen@google.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
Link: https://lore.kernel.org/r/20210322234438.502582-1-seanjc@google.com
Cc: Stephen Boyd <swboyd@chromium.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 scripts/module.lds.S |    2 ++
 1 file changed, 2 insertions(+)

--- a/scripts/module.lds.S
+++ b/scripts/module.lds.S
@@ -26,6 +26,7 @@ SECTIONS {
 
 	__patchable_function_entries : { *(__patchable_function_entries) }
 
+#ifdef CONFIG_LTO_CLANG
 	/*
 	 * With CONFIG_LTO_CLANG, LLD always enables -fdata-sections and
 	 * -ffunction-sections, which increases the size of the final module.
@@ -47,6 +48,7 @@ SECTIONS {
 	}
 
 	.text : { *(.text .text.[0-9a-zA-Z_]*) }
+#endif
 }
 
 /* bring in arch-specific sections */


