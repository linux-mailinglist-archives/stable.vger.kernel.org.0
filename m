Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C49EC328442
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 17:36:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232746AbhCAQc3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 11:32:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:60760 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234552AbhCAQ07 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 11:26:59 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5740C64EE0;
        Mon,  1 Mar 2021 16:22:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614615731;
        bh=8kEmu/Mmj+Y7YOScfDINF7kLygKePYMP8cWp3qqDDU4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CFlOdGDTvhJVar9GhdjnFFqeFDWvnjJ2F20YVAw1PdNdxZKhHHzh6n5WbwsubA613
         HL6VbL1c1PeWdXPh2WX1mb/yIE7Kc2vQpLCM6CDjYuw8Wu64SeD1BMShlbIfKCjScX
         wA2RNB8UQ8vm7q3acIPKJ6KUraCDXCnpQsE6oG/4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexander Lobakin <alobakin@pm.me>,
        Kees Cook <keescook@chromium.org>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Subject: [PATCH 4.9 010/134] MIPS: vmlinux.lds.S: add missing PAGE_ALIGNED_DATA() section
Date:   Mon,  1 Mar 2021 17:11:51 +0100
Message-Id: <20210301161014.086003722@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161013.585393984@linuxfoundation.org>
References: <20210301161013.585393984@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Lobakin <alobakin@pm.me>

commit 8ac7c87acdcac156670f9920c8acbd84308ff4b1 upstream.

MIPS uses its own declaration of rwdata, and thus it should be kept
in sync with the asm-generic one. Currently PAGE_ALIGNED_DATA() is
missing from the linker script, which emits the following ld
warnings:

mips-alpine-linux-musl-ld: warning: orphan section
`.data..page_aligned' from `arch/mips/kernel/vdso.o' being placed
in section `.data..page_aligned'
mips-alpine-linux-musl-ld: warning: orphan section
`.data..page_aligned' from `arch/mips/vdso/vdso-image.o' being placed
in section `.data..page_aligned'

Add the necessary declaration, so the mentioned structures will be
placed in vmlinux as intended:

ffffffff80630580 D __end_once
ffffffff80630580 D __start___dyndbg
ffffffff80630580 D __start_once
ffffffff80630580 D __stop___dyndbg
ffffffff80634000 d mips_vdso_data
ffffffff80638000 d vdso_data
ffffffff80638580 D _gp
ffffffff8063c000 T __init_begin
ffffffff8063c000 D _edata
ffffffff8063c000 T _sinittext

->

ffffffff805a4000 D __end_init_task
ffffffff805a4000 D __nosave_begin
ffffffff805a4000 D __nosave_end
ffffffff805a4000 d mips_vdso_data
ffffffff805a8000 d vdso_data
ffffffff805ac000 D mmlist_lock
ffffffff805ac080 D tasklist_lock

Fixes: ebb5e78cc634 ("MIPS: Initial implementation of a VDSO")
Signed-off-by: Alexander Lobakin <alobakin@pm.me>
Reviewed-by: Kees Cook <keescook@chromium.org>
Reviewed-by: Nathan Chancellor <natechancellor@gmail.com>
Cc: stable@vger.kernel.org # 4.4+
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/mips/kernel/vmlinux.lds.S |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/mips/kernel/vmlinux.lds.S
+++ b/arch/mips/kernel/vmlinux.lds.S
@@ -92,6 +92,7 @@ SECTIONS
 
 		INIT_TASK_DATA(THREAD_SIZE)
 		NOSAVE_DATA
+		PAGE_ALIGNED_DATA(PAGE_SIZE)
 		CACHELINE_ALIGNED_DATA(1 << CONFIG_MIPS_L1_CACHE_SHIFT)
 		READ_MOSTLY_DATA(1 << CONFIG_MIPS_L1_CACHE_SHIFT)
 		DATA_DATA


