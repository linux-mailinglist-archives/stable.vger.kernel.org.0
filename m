Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CCC654FD6BA
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 12:25:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235711AbiDLHVm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 03:21:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351875AbiDLHNC (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 03:13:02 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE4FC26F1;
        Mon, 11 Apr 2022 23:53:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9C341B81B44;
        Tue, 12 Apr 2022 06:53:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CAF6C385A1;
        Tue, 12 Apr 2022 06:53:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649746436;
        bh=ggHIMVDOir28eivHT7Q6oJ4r5wNBVY9vag4cZI+7UJs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iUpN3sV6UOmbj1REG36CLiNt4nuW44NF10apnq06QEgHcmmWdxvB+MryNv9yX2Fxu
         uKf0LPgc9MnEFRBYtyR0v+gMcH1bgbarLkGp+vEVPFusvTooz8DY4J7TlBzbggOm/0
         S6SEiNzlAmralp5otL/QRvoJ2NYpMTlVohnOLCb4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 5.15 273/277] powerpc/64: Fix build failure with allyesconfig in book3s_64_entry.S
Date:   Tue, 12 Apr 2022 08:31:16 +0200
Message-Id: <20220412062949.941414766@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062942.022903016@linuxfoundation.org>
References: <20220412062942.022903016@linuxfoundation.org>
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

From: Christophe Leroy <christophe.leroy@csgroup.eu>

commit af41d2866f7d75bbb38d487f6ec7770425d70e45 upstream.

Using conditional branches between two files is hasardous,
they may get linked too far from each other.

  arch/powerpc/kvm/book3s_64_entry.o:(.text+0x3ec): relocation truncated
  to fit: R_PPC64_REL14 (stub) against symbol `system_reset_common'
  defined in .text section in arch/powerpc/kernel/head_64.o

Reorganise the code to use non conditional branches.

Fixes: 89d35b239101 ("KVM: PPC: Book3S HV P9: Implement the rest of the P9 path in C")
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
[mpe: Avoid odd-looking bne ., use named local labels]
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/89cf27bf43ee07a0b2879b9e8e2f5cd6386a3645.1648366338.git.christophe.leroy@csgroup.eu
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/kvm/book3s_64_entry.S |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/arch/powerpc/kvm/book3s_64_entry.S
+++ b/arch/powerpc/kvm/book3s_64_entry.S
@@ -407,10 +407,16 @@ END_FTR_SECTION_IFSET(CPU_FTR_DAWR1)
 	 */
 	ld	r10,HSTATE_SCRATCH0(r13)
 	cmpwi	r10,BOOK3S_INTERRUPT_MACHINE_CHECK
-	beq	machine_check_common
+	beq	.Lcall_machine_check_common
 
 	cmpwi	r10,BOOK3S_INTERRUPT_SYSTEM_RESET
-	beq	system_reset_common
+	beq	.Lcall_system_reset_common
 
 	b	.
+
+.Lcall_machine_check_common:
+	b	machine_check_common
+
+.Lcall_system_reset_common:
+	b	system_reset_common
 #endif


