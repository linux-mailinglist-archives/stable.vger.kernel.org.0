Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8BBBA507F6
	for <lists+stable@lfdr.de>; Mon, 24 Jun 2019 12:13:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730008AbfFXKFx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jun 2019 06:05:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:37970 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728846AbfFXKFx (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Jun 2019 06:05:53 -0400
Received: from localhost (f4.8f.5177.ip4.static.sl-reverse.com [119.81.143.244])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D11D32145D;
        Mon, 24 Jun 2019 10:05:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561370752;
        bh=J3lk6Rg+8MdhODyh01OhUMDKDNclpoK0P14pEu19wDc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ej6siDs5ms4gJ0R5tFjBZpR9fTcz7JP8V3LsqQTnjLcwcZ4uy7r5j1VGh6fsJ55Sr
         ikFEJbxep1L5hbyhbMrn0SGVAXKlScfBLAusi5t6uzdECFwUijZzpYE51/RiRK/7IX
         20OF1zoT+QPBQ2/4ZXLQDICT5jxobQG4HTE3pEIs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dave Martin <Dave.Martin@arm.com>,
        Anisse Astier <aastier@freebox.fr>,
        Will Deacon <will.deacon@arm.com>
Subject: [PATCH 4.19 77/90] arm64/sve: <uapi/asm/ptrace.h> should not depend on <uapi/linux/prctl.h>
Date:   Mon, 24 Jun 2019 17:57:07 +0800
Message-Id: <20190624092319.002811331@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190624092313.788773607@linuxfoundation.org>
References: <20190624092313.788773607@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Anisse Astier <aastier@freebox.fr>

commit 35341ca0614ab13e1ef34ad4f29a39e15ef31fa8 upstream.

Pulling linux/prctl.h into asm/ptrace.h in the arm64 UAPI headers causes
userspace build issues for any program (e.g. strace and qemu) that
includes both <sys/prctl.h> and <linux/ptrace.h> when using musl libc:

  | error: redefinition of 'struct prctl_mm_map'
  |  struct prctl_mm_map {

See https://github.com/foundriesio/meta-lmp/commit/6d4a106e191b5d79c41b9ac78fd321316d3013c0
for a public example of people working around this issue.

Although it's a bit grotty, fix this breakage by duplicating the prctl
constant definitions. Since these are part of the kernel ABI, they
cannot be changed in future and so it's not the end of the world to have
them open-coded.

Fixes: 43d4da2c45b2 ("arm64/sve: ptrace and ELF coredump support")
Cc: stable@vger.kernel.org
Acked-by: Dave Martin <Dave.Martin@arm.com>
Signed-off-by: Anisse Astier <aastier@freebox.fr>
Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm64/include/uapi/asm/ptrace.h |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

--- a/arch/arm64/include/uapi/asm/ptrace.h
+++ b/arch/arm64/include/uapi/asm/ptrace.h
@@ -64,8 +64,6 @@
 
 #ifndef __ASSEMBLY__
 
-#include <linux/prctl.h>
-
 /*
  * User structures for general purpose, floating point and debug registers.
  */
@@ -112,10 +110,10 @@ struct user_sve_header {
 
 /*
  * Common SVE_PT_* flags:
- * These must be kept in sync with prctl interface in <linux/ptrace.h>
+ * These must be kept in sync with prctl interface in <linux/prctl.h>
  */
-#define SVE_PT_VL_INHERIT		(PR_SVE_VL_INHERIT >> 16)
-#define SVE_PT_VL_ONEXEC		(PR_SVE_SET_VL_ONEXEC >> 16)
+#define SVE_PT_VL_INHERIT		((1 << 17) /* PR_SVE_VL_INHERIT */ >> 16)
+#define SVE_PT_VL_ONEXEC		((1 << 18) /* PR_SVE_SET_VL_ONEXEC */ >> 16)
 
 
 /*


