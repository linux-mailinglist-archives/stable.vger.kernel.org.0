Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E92A06BB007
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 13:14:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229725AbjCOMOm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 08:14:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231545AbjCOMOm (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 08:14:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EC522D154
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 05:14:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 22D5761D43
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 12:14:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30D2CC4339B;
        Wed, 15 Mar 2023 12:14:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678882480;
        bh=k5V1E41tAhQIfjaN6+/00GIDDZKYhkKuK0Ekla0k6Bs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TRju+XjXmb748oGe4BRa2vsuAFSVJh7QNIdDWXSisNCKtuLHwfkMBFnHdBLwhg7/s
         4ylGYmnAPJhHaNINP+6sb31u9yACEKAACeXByY6Ky5vv09k53B7/PICCnh6FjH8eIW
         ikAsRU1ENq/RhkJ685QeVMZKOXEhs4aFL/R9J9Jg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Tavis Ormandy <taviso@gmail.com>,
        Andrew Cooper <andrew.cooper3@citrix.com>,
        "Borislav Petkov (AMD)" <bp@alien8.de>, stable@kernel.org
Subject: [PATCH 4.14 02/21] x86/CPU/AMD: Disable XSAVES on AMD family 0x17
Date:   Wed, 15 Mar 2023 13:12:25 +0100
Message-Id: <20230315115718.902410428@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115718.796692048@linuxfoundation.org>
References: <20230315115718.796692048@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrew Cooper <andrew.cooper3@citrix.com>

commit b0563468eeac88ebc70559d52a0b66efc37e4e9d upstream.

AMD Erratum 1386 is summarised as:

  XSAVES Instruction May Fail to Save XMM Registers to the Provided
  State Save Area

This piece of accidental chronomancy causes the %xmm registers to
occasionally reset back to an older value.

Ignore the XSAVES feature on all AMD Zen1/2 hardware.  The XSAVEC
instruction (which works fine) is equivalent on affected parts.

  [ bp: Typos, move it into the F17h-specific function. ]

Reported-by: Tavis Ormandy <taviso@gmail.com>
Signed-off-by: Andrew Cooper <andrew.cooper3@citrix.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Cc: <stable@kernel.org>
Link: https://lore.kernel.org/r/20230307174643.1240184-1-andrew.cooper3@citrix.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/cpu/amd.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -197,6 +197,15 @@ static void init_amd_k6(struct cpuinfo_x
 		return;
 	}
 #endif
+	/*
+	 * Work around Erratum 1386.  The XSAVES instruction malfunctions in
+	 * certain circumstances on Zen1/2 uarch, and not all parts have had
+	 * updated microcode at the time of writing (March 2023).
+	 *
+	 * Affected parts all have no supervisor XSAVE states, meaning that
+	 * the XSAVEC instruction (which works fine) is equivalent.
+	 */
+	clear_cpu_cap(c, X86_FEATURE_XSAVES);
 }
 
 static void init_amd_k7(struct cpuinfo_x86 *c)


