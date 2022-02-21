Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A32644BE910
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 19:06:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346766AbiBUJDA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 04:03:00 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:59924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347249AbiBUJBG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 04:01:06 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 061E91ADBF;
        Mon, 21 Feb 2022 00:56:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DC38F6112B;
        Mon, 21 Feb 2022 08:56:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCD10C340E9;
        Mon, 21 Feb 2022 08:56:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645433766;
        bh=1ebs+CBuFtYrHR0bOOevaCvXQHzUX28Wzi6kVnMTHAw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oTc8sHQt9L664B9DSH1wqCjYj/AhBr5+f507Ehori/qWuJMIJAZjpQAlCmj/J7dlP
         PJ+lFvM0YN2wilAd58GQPf+OLB21RZ1RlqRaw8dceHVV0BU7ZxfL/myVUT6axN+niq
         8Ejhc2enAYFgaZRxZCp+da8WkfF3Aj6pqrsr5pYg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Anders Roxell <anders.roxell@linaro.org>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 4.19 35/58] powerpc/lib/sstep: fix ptesync build error
Date:   Mon, 21 Feb 2022 09:49:28 +0100
Message-Id: <20220221084913.013621444@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220221084911.895146879@linuxfoundation.org>
References: <20220221084911.895146879@linuxfoundation.org>
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

commit fe663df7825811358531dc2e8a52d9eaa5e3515e upstream.

Building tinyconfig with gcc (Debian 11.2.0-16) and assembler (Debian
2.37.90.20220207) the following build error shows up:

  {standard input}: Assembler messages:
  {standard input}:2088: Error: unrecognized opcode: `ptesync'
  make[3]: *** [/builds/linux/scripts/Makefile.build:287: arch/powerpc/lib/sstep.o] Error 1

Add the 'ifdef CONFIG_PPC64' around the 'ptesync' in function
'emulate_update_regs()' to like it is in 'analyse_instr()'. Since it looks like
it got dropped inadvertently by commit 3cdfcbfd32b9 ("powerpc: Change
analyse_instr so it doesn't modify *regs").

A key detail is that analyse_instr() will never recognise lwsync or
ptesync on 32-bit (because of the existing ifdef), and as a result
emulate_update_regs() should never be called with an op specifying
either of those on 32-bit. So removing them from emulate_update_regs()
should be a nop in terms of runtime behaviour.

Fixes: 3cdfcbfd32b9 ("powerpc: Change analyse_instr so it doesn't modify *regs")
Cc: stable@vger.kernel.org # v4.14+
Suggested-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Anders Roxell <anders.roxell@linaro.org>
[mpe: Add last paragraph of change log mentioning analyse_instr() details]
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20220211005113.1361436-1-anders.roxell@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/lib/sstep.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/powerpc/lib/sstep.c
+++ b/arch/powerpc/lib/sstep.c
@@ -2681,12 +2681,14 @@ void emulate_update_regs(struct pt_regs
 		case BARRIER_EIEIO:
 			eieio();
 			break;
+#ifdef CONFIG_PPC64
 		case BARRIER_LWSYNC:
 			asm volatile("lwsync" : : : "memory");
 			break;
 		case BARRIER_PTESYNC:
 			asm volatile("ptesync" : : : "memory");
 			break;
+#endif
 		}
 		break;
 


