Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1DFBC621B18
	for <lists+stable@lfdr.de>; Tue,  8 Nov 2022 18:49:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234623AbiKHRtx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 12:49:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234686AbiKHRtm (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 12:49:42 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C18F212ABE;
        Tue,  8 Nov 2022 09:49:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7AD55B81BE1;
        Tue,  8 Nov 2022 17:49:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AF38C433D7;
        Tue,  8 Nov 2022 17:49:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667929778;
        bh=LMhru1+YgBAfi13lBX6Nu1827mByiikg16DD/vba9ec=;
        h=From:To:Cc:Subject:Date:From;
        b=kohT8c/A1pFM9cKfrnQiKB/0EL7Yd81dJj1XkPIDip0mbUj/1VHCst+eGjYmjl6/f
         MScOjDjtsMDMMQrNqzzefQiqSHHxnq4X+q0e1o7I588SbzLVUjLQrS07gufK0i71tL
         6HyxWnImwR8m4ejUyyO7D60iwdSZ5V/jHCCVquOYyy+LvqGk6nUY43GsVIC/StXJg+
         REW9Dlyhe1QSmlFjq3/zFupSN14aqHZ42bZupr2k4jYoxnSu/5ingp8akG+o/uqGc2
         GvAdzuy/TY0ng+3WEVwzUf2frjNpuPHQO8e/zPoBbqV3xNpeBPE/JbHInqSo/rEQGP
         ohwTxi1rSyzag==
From:   Nathan Chancellor <nathan@kernel.org>
To:     Arnd Bergmann <arnd@arndb.de>, Kees Cook <keescook@chromium.org>
Cc:     linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nathan Chancellor <nathan@kernel.org>, stable@vger.kernel.org,
        Ard Biesheuvel <ardb@kernel.org>,
        Zhao Wenhui <zhaowenhui8@huawei.com>,
        xiafukun <xiafukun@huawei.com>
Subject: [PATCH] vmlinux.lds.h: Fix placement of '.data..decrypted' section
Date:   Tue,  8 Nov 2022 10:49:34 -0700
Message-Id: <20221108174934.3384275-1-nathan@kernel.org>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Commit d4c639990036 ("vmlinux.lds.h: Avoid orphan section with !SMP")
fixed an orphan section warning by adding the '.data..decrypted' section
to the linker script under the PERCPU_DECRYPTED_SECTION define but that
placement introduced a panic with !SMP, as the percpu sections are not
instantiated with that configuration so attempting to access variables
defined with DEFINE_PER_CPU_DECRYPTED() will result in a page fault.

Move the '.data..decrypted' section to the DATA_MAIN define so that the
variables in it are properly instantiated at boot time with
CONFIG_SMP=n.

Cc: stable@vger.kernel.org
Fixes: d4c639990036 ("vmlinux.lds.h: Avoid orphan section with !SMP")
Link: https://lore.kernel.org/cbbd3548-880c-d2ca-1b67-5bb93b291d5f@huawei.com/
Debugged-by: Ard Biesheuvel <ardb@kernel.org>
Reported-by: Zhao Wenhui <zhaowenhui8@huawei.com>
Tested-by: xiafukun <xiafukun@huawei.com>
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
 include/asm-generic/vmlinux.lds.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index d06ada2341cb..3dc5824141cd 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -347,6 +347,7 @@
 #define DATA_DATA							\
 	*(.xiptext)							\
 	*(DATA_MAIN)							\
+	*(.data..decrypted)						\
 	*(.ref.data)							\
 	*(.data..shared_aligned) /* percpu related */			\
 	MEM_KEEP(init.data*)						\
@@ -995,7 +996,6 @@
 #ifdef CONFIG_AMD_MEM_ENCRYPT
 #define PERCPU_DECRYPTED_SECTION					\
 	. = ALIGN(PAGE_SIZE);						\
-	*(.data..decrypted)						\
 	*(.data..percpu..decrypted)					\
 	. = ALIGN(PAGE_SIZE);
 #else

base-commit: f0c4d9fc9cc9462659728d168387191387e903cc
-- 
2.38.1

