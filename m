Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 765D35410A8
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 21:29:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352559AbiFGT2r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 15:28:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356885AbiFGT2T (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 15:28:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8FA61A197E;
        Tue,  7 Jun 2022 11:11:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AA302B81F38;
        Tue,  7 Jun 2022 18:11:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21F7CC385A2;
        Tue,  7 Jun 2022 18:11:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654625485;
        bh=5ie3URM6EtSxp++nGH7x9ksdFBVoOhc8kt870ZQ+6KQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VVIUNVqVgjl8ZSpRUey2pkElQI0vdS01ir5o5y6b8T3+/tlKgkuQvKNFUPVYSaFWD
         mB+PTaPRNAHy60/LGlC6HPSV5lOYi4QJDmLWP0tWXMvONx67dBBssoFkQNZ5mD/Abt
         ZmgsJQUHXc7WuTPCNRtF3SL7FOw9RDjkzNQtlcow=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alexandre Ghiti <alexandre.ghiti@canonical.com>,
        Palmer Dabbelt <palmer@rivosinc.com>
Subject: [PATCH 5.17 006/772] riscv: Initialize thread pointer before calling C functions
Date:   Tue,  7 Jun 2022 18:53:18 +0200
Message-Id: <20220607164949.183951732@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164948.980838585@linuxfoundation.org>
References: <20220607164948.980838585@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexandre Ghiti <alexandre.ghiti@canonical.com>

commit 35d33c76d68dfacc330a8eb477b51cc647c5a847 upstream.

Because of the stack canary feature that reads from the current task
structure the stack canary value, the thread pointer register "tp" must
be set before calling any C function from head.S: by chance, setup_vm
and all the functions that it calls does not seem to be part of the
functions where the canary check is done, but in the following commits,
some functions will.

Fixes: f2c9699f65557a31 ("riscv: Add STACKPROTECTOR supported")
Signed-off-by: Alexandre Ghiti <alexandre.ghiti@canonical.com>
Cc: stable@vger.kernel.org
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/riscv/kernel/head.S |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/riscv/kernel/head.S
+++ b/arch/riscv/kernel/head.S
@@ -316,6 +316,7 @@ clear_bss_done:
 	REG_S a0, (a2)
 
 	/* Initialize page tables and relocate to virtual addresses */
+	la tp, init_task
 	la sp, init_thread_union + THREAD_SIZE
 	XIP_FIXUP_OFFSET sp
 #ifdef CONFIG_BUILTIN_DTB


