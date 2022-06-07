Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D98B554109D
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 21:28:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352005AbiFGT2b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 15:28:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356896AbiFGT2V (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 15:28:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB4D21A29C5;
        Tue,  7 Jun 2022 11:11:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5714E61903;
        Tue,  7 Jun 2022 18:11:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 664E4C385A5;
        Tue,  7 Jun 2022 18:11:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654625490;
        bh=FQJSpetsLBnsxM9PqVdsBxFKyjDXSecnsj2VtGM4CvU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SmtLQQNHq3r5QeijAM1ksEvPnozDO+AbpoUKG+4WTbHoCL4vp+RRm7Rc7DIpXtH9F
         AtIghvch6m9LBfuVztcdKVm33yFQ+s5oIXPOog0yxXYuJAc0X5jFvCRXVbTmScn2zQ
         DZ/4N5Sv/kVXfgpWelz1LYl4N6ZoaQnR0ygjzt9o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tobias Klauser <tklauser@distanz.ch>,
        Palmer Dabbelt <palmer@rivosinc.com>
Subject: [PATCH 5.17 008/772] riscv: Wire up memfd_secret in UAPI header
Date:   Tue,  7 Jun 2022 18:53:20 +0200
Message-Id: <20220607164949.243983717@linuxfoundation.org>
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

From: Tobias Klauser <tklauser@distanz.ch>

commit 02d88b40cb2e9614e0117c3385afdce878f0d377 upstream.

Move the __ARCH_WANT_MEMFD_SECRET define added in commit 7bb7f2ac24a0
("arch, mm: wire up memfd_secret system call where relevant") to
<uapi/asm/unistd.h> so __NR_memfd_secret is defined when including
<unistd.h> in userspace.

This allows the memfd_secret selftest to pass on riscv.

Signed-off-by: Tobias Klauser <tklauser@distanz.ch>
Link: https://lore.kernel.org/r/20220505081815.22808-1-tklauser@distanz.ch
Fixes: 7bb7f2ac24a0 ("arch, mm: wire up memfd_secret system call where relevant")
Cc: stable@vger.kernel.org
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/riscv/include/asm/unistd.h      |    1 -
 arch/riscv/include/uapi/asm/unistd.h |    1 +
 2 files changed, 1 insertion(+), 1 deletion(-)

--- a/arch/riscv/include/asm/unistd.h
+++ b/arch/riscv/include/asm/unistd.h
@@ -9,7 +9,6 @@
  */
 
 #define __ARCH_WANT_SYS_CLONE
-#define __ARCH_WANT_MEMFD_SECRET
 
 #include <uapi/asm/unistd.h>
 
--- a/arch/riscv/include/uapi/asm/unistd.h
+++ b/arch/riscv/include/uapi/asm/unistd.h
@@ -21,6 +21,7 @@
 #endif /* __LP64__ */
 
 #define __ARCH_WANT_SYS_CLONE3
+#define __ARCH_WANT_MEMFD_SECRET
 
 #include <asm-generic/unistd.h>
 


