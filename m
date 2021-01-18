Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDBAF2FA8C6
	for <lists+stable@lfdr.de>; Mon, 18 Jan 2021 19:28:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393674AbhARS1Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Jan 2021 13:27:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:36424 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390743AbhARLlk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Jan 2021 06:41:40 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7D55F229C6;
        Mon, 18 Jan 2021 11:41:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610970077;
        bh=Q1DVdWbFpqENDVGJYgXxxkgZGK4VYuGf2epD0eXuMLY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CCUHuLnePfFsDviV79wW+mC6KkGs5GuzGIe85XUqPu/US5uSqx0hnBFDJall+onja
         UrIGJDlTqNVVlD+eoeH0qhOEobyGsiAbeiX8j6cYMX5yQXe2o6yWSPumhG2XEKPbqh
         fcUXF4h0CYvYqJwvQZl9DlpzmEjfRHqvasSZ9asY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guo Ren <guoren@linux.alibaba.com>,
        Pekka Enberg <penberg@kernel.org>,
        Palmer Dabbelt <palmerdabbelt@google.com>
Subject: [PATCH 5.10 027/152] riscv: Fixup CONFIG_GENERIC_TIME_VSYSCALL
Date:   Mon, 18 Jan 2021 12:33:22 +0100
Message-Id: <20210118113354.082757811@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210118113352.764293297@linuxfoundation.org>
References: <20210118113352.764293297@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Guo Ren <guoren@linux.alibaba.com>

commit 0aa2ec8a475fb505fd98d93bbcf4e03beeeebcb6 upstream.

The patch fix commit: ad5d112 ("riscv: use vDSO common flow to
reduce the latency of the time-related functions").

The GENERIC_TIME_VSYSCALL should be CONFIG_GENERIC_TIME_VSYSCALL
or vgettimeofday won't work.

Signed-off-by: Guo Ren <guoren@linux.alibaba.com>
Reviewed-by: Pekka Enberg <penberg@kernel.org>
Fixes: ad5d1122b82f ("riscv: use vDSO common flow to reduce the latency of the time-related functions")
Cc: stable@vger.kernel.org
Signed-off-by: Palmer Dabbelt <palmerdabbelt@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/riscv/include/asm/vdso.h |    2 +-
 arch/riscv/kernel/vdso.c      |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/arch/riscv/include/asm/vdso.h
+++ b/arch/riscv/include/asm/vdso.h
@@ -10,7 +10,7 @@
 
 #include <linux/types.h>
 
-#ifndef GENERIC_TIME_VSYSCALL
+#ifndef CONFIG_GENERIC_TIME_VSYSCALL
 struct vdso_data {
 };
 #endif
--- a/arch/riscv/kernel/vdso.c
+++ b/arch/riscv/kernel/vdso.c
@@ -12,7 +12,7 @@
 #include <linux/binfmts.h>
 #include <linux/err.h>
 #include <asm/page.h>
-#ifdef GENERIC_TIME_VSYSCALL
+#ifdef CONFIG_GENERIC_TIME_VSYSCALL
 #include <vdso/datapage.h>
 #else
 #include <asm/vdso.h>


