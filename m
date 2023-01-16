Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C295666C5A0
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 17:08:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232549AbjAPQIK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 11:08:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232203AbjAPQH0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 11:07:26 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AC38265AC
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:05:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AEDD661037
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:05:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C41A6C433EF;
        Mon, 16 Jan 2023 16:05:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673885134;
        bh=q7TidXVstAgk4U9ExAfdhOOwGbV9ytvncriebcudRTE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MrFDMvrwkIEHU7JQwk4km6ocuNQJLZwwub0/wfPVk351rqRu6GNAFgb+j2O6vUO1w
         TDb90CIjKAK3a8G7BlsuVikDEDLCZtYCXE3tXImxVuz8i1sr2yLWUh+bK1UlaEwOwL
         kE50pj0IsXGWEvdnDQp9Yxo+DJNbriOjDMFNevBg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Willy Tarreau <w@1wt.eu>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 63/86] tools/nolibc/arch: mark the _start symbol as weak
Date:   Mon, 16 Jan 2023 16:51:37 +0100
Message-Id: <20230116154749.675630224@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154747.036911298@linuxfoundation.org>
References: <20230116154747.036911298@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Willy Tarreau <w@1wt.eu>

[ Upstream commit dffeb81af5fe5eedccf5ea4a8a120d8c3accd26e ]

By doing so we can link together multiple C files that have been compiled
with nolibc and which each have a _start symbol.

Signed-off-by: Willy Tarreau <w@1wt.eu>
Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
Stable-dep-of: 184177c3d6e0 ("tools/nolibc: restore mips branch ordering in the _start block")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/include/nolibc/arch-aarch64.h | 1 +
 tools/include/nolibc/arch-arm.h     | 1 +
 tools/include/nolibc/arch-i386.h    | 1 +
 tools/include/nolibc/arch-mips.h    | 1 +
 tools/include/nolibc/arch-riscv.h   | 1 +
 tools/include/nolibc/arch-x86_64.h  | 1 +
 6 files changed, 6 insertions(+)

diff --git a/tools/include/nolibc/arch-aarch64.h b/tools/include/nolibc/arch-aarch64.h
index 443de5fb7f54..87d9e434820c 100644
--- a/tools/include/nolibc/arch-aarch64.h
+++ b/tools/include/nolibc/arch-aarch64.h
@@ -183,6 +183,7 @@ struct sys_stat_struct {
 
 /* startup code */
 asm(".section .text\n"
+    ".weak _start\n"
     ".global _start\n"
     "_start:\n"
     "ldr x0, [sp]\n"              // argc (x0) was in the stack
diff --git a/tools/include/nolibc/arch-arm.h b/tools/include/nolibc/arch-arm.h
index 66f687ad987f..001a3c8c9ad5 100644
--- a/tools/include/nolibc/arch-arm.h
+++ b/tools/include/nolibc/arch-arm.h
@@ -176,6 +176,7 @@ struct sys_stat_struct {
 
 /* startup code */
 asm(".section .text\n"
+    ".weak _start\n"
     ".global _start\n"
     "_start:\n"
 #if defined(__THUMBEB__) || defined(__THUMBEL__)
diff --git a/tools/include/nolibc/arch-i386.h b/tools/include/nolibc/arch-i386.h
index 32f42e2cee26..d7e4d53325a3 100644
--- a/tools/include/nolibc/arch-i386.h
+++ b/tools/include/nolibc/arch-i386.h
@@ -175,6 +175,7 @@ struct sys_stat_struct {
  *
  */
 asm(".section .text\n"
+    ".weak _start\n"
     ".global _start\n"
     "_start:\n"
     "pop %eax\n"                // argc   (first arg, %eax)
diff --git a/tools/include/nolibc/arch-mips.h b/tools/include/nolibc/arch-mips.h
index e330201dde6a..c9a6aac87c6d 100644
--- a/tools/include/nolibc/arch-mips.h
+++ b/tools/include/nolibc/arch-mips.h
@@ -190,6 +190,7 @@ struct sys_stat_struct {
 
 /* startup code, note that it's called __start on MIPS */
 asm(".section .text\n"
+    ".weak __start\n"
     ".set nomips16\n"
     ".global __start\n"
     ".set    noreorder\n"
diff --git a/tools/include/nolibc/arch-riscv.h b/tools/include/nolibc/arch-riscv.h
index 9d5ff78f606b..bc10b7b5706d 100644
--- a/tools/include/nolibc/arch-riscv.h
+++ b/tools/include/nolibc/arch-riscv.h
@@ -184,6 +184,7 @@ struct sys_stat_struct {
 
 /* startup code */
 asm(".section .text\n"
+    ".weak _start\n"
     ".global _start\n"
     "_start:\n"
     ".option push\n"
diff --git a/tools/include/nolibc/arch-x86_64.h b/tools/include/nolibc/arch-x86_64.h
index 83c4b458ada7..fe517c16cd4d 100644
--- a/tools/include/nolibc/arch-x86_64.h
+++ b/tools/include/nolibc/arch-x86_64.h
@@ -198,6 +198,7 @@ struct sys_stat_struct {
  *
  */
 asm(".section .text\n"
+    ".weak _start\n"
     ".global _start\n"
     "_start:\n"
     "pop %rdi\n"                // argc   (first arg, %rdi)
-- 
2.35.1



