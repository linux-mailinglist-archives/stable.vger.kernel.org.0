Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6692C68D82A
	for <lists+stable@lfdr.de>; Tue,  7 Feb 2023 14:07:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232184AbjBGNHQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Feb 2023 08:07:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232216AbjBGNHM (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Feb 2023 08:07:12 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 428EB3A870
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 05:06:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id C0F5CCE1C97
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 13:05:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 891F9C433D2;
        Tue,  7 Feb 2023 13:05:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675775152;
        bh=+lJKLrzqvZjmTpzYuBgyqCdczHpHdPp07w2453Ql8xc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S7uIpo0qPpu+jkOA19muRtDklUjrAgh9g0HGMddAstrjb+oEjZq6YJLihtHTWma9U
         SknNzYQdd9eOcNS/D5gLWSbZra4Hz7Zr+zhZ9el6eqrLXBdkNFGZVGaZupeczzwnQE
         QvnwCJbtlyvCEYAuQdYGxdHvWLHVXGEz4ledQkk0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Andreas Schwab <schwab@suse.de>,
        Palmer Dabbelt <palmer@rivosinc.com>
Subject: [PATCH 6.1 154/208] riscv: disable generation of unwind tables
Date:   Tue,  7 Feb 2023 13:56:48 +0100
Message-Id: <20230207125641.437162749@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230207125634.292109991@linuxfoundation.org>
References: <20230207125634.292109991@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andreas Schwab <schwab@suse.de>

commit 2f394c0e7d1129a35156e492bc8f445fb20f43ac upstream.

GCC 13 will enable -fasynchronous-unwind-tables by default on riscv.  In
the kernel, we don't have any use for unwind tables yet, so disable them.
More importantly, the .eh_frame section brings relocations
(R_RISC_32_PCREL, R_RISCV_SET{6,8,16}, R_RISCV_SUB{6,8,16}) into modules
that we are not prepared to handle.

Signed-off-by: Andreas Schwab <schwab@suse.de>
Link: https://lore.kernel.org/r/mvmzg9xybqu.fsf@suse.de
Cc: stable@vger.kernel.org
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/riscv/Makefile |    3 +++
 1 file changed, 3 insertions(+)

--- a/arch/riscv/Makefile
+++ b/arch/riscv/Makefile
@@ -80,6 +80,9 @@ ifeq ($(CONFIG_PERF_EVENTS),y)
         KBUILD_CFLAGS += -fno-omit-frame-pointer
 endif
 
+# Avoid generating .eh_frame sections.
+KBUILD_CFLAGS += -fno-asynchronous-unwind-tables -fno-unwind-tables
+
 KBUILD_CFLAGS_MODULE += $(call cc-option,-mno-relax)
 KBUILD_AFLAGS_MODULE += $(call as-option,-Wa$(comma)-mno-relax)
 


