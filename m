Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64B323AEDD4
	for <lists+stable@lfdr.de>; Mon, 21 Jun 2021 18:21:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231410AbhFUQXN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Jun 2021 12:23:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:41850 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231432AbhFUQV6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Jun 2021 12:21:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8BFF161360;
        Mon, 21 Jun 2021 16:19:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1624292374;
        bh=oD6nPcakbFF37NET7R7AagDjjKz46GpqfleNg2BbKS8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E/yfkSayzyG1E6Ro9iulg9eWhqxFuAx6jfqSkWx+bhkylA9wn8h+PVRnRpuNCU4Ci
         n3My4UUffSei7A3RjsCxqhivL9ro6tLgZ3Ob6rRHVLH0SW9vm2qxfh9jR+McsZTyf3
         4sm/QvOagfsEpXKLRAl5MLNQOEQP3Z2CHalCjr08=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@suse.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Rik van Riel <riel@surriel.com>
Subject: [PATCH 5.4 66/90] x86/process: Check PF_KTHREAD and not current->mm for kernel threads
Date:   Mon, 21 Jun 2021 18:15:41 +0200
Message-Id: <20210621154906.393789166@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210621154904.159672728@linuxfoundation.org>
References: <20210621154904.159672728@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

commit 12f7764ac61200e32c916f038bdc08f884b0b604 upstream.

switch_fpu_finish() checks current->mm as indicator for kernel threads.
That's wrong because kernel threads can temporarily use a mm of a user
process via kthread_use_mm().

Check the task flags for PF_KTHREAD instead.

Fixes: 0cecca9d03c9 ("x86/fpu: Eager switch PKRU state")
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Borislav Petkov <bp@suse.de>
Acked-by: Dave Hansen <dave.hansen@linux.intel.com>
Acked-by: Rik van Riel <riel@surriel.com>
Cc: stable@vger.kernel.org
Link: https://lkml.kernel.org/r/20210608144345.912645927@linutronix.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/fpu/internal.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/include/asm/fpu/internal.h
+++ b/arch/x86/include/asm/fpu/internal.h
@@ -607,7 +607,7 @@ static inline void switch_fpu_finish(str
 	 * PKRU state is switched eagerly because it needs to be valid before we
 	 * return to userland e.g. for a copy_to_user() operation.
 	 */
-	if (current->mm) {
+	if (!(current->flags & PF_KTHREAD)) {
 		pk = get_xsave_addr(&new_fpu->state.xsave, XFEATURE_PKRU);
 		if (pk)
 			pkru_val = pk->pkru;


