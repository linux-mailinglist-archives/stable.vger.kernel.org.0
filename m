Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E511D3AEF24
	for <lists+stable@lfdr.de>; Mon, 21 Jun 2021 18:33:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232208AbhFUQfy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Jun 2021 12:35:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:56050 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232877AbhFUQev (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Jun 2021 12:34:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8D6BB613F6;
        Mon, 21 Jun 2021 16:27:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1624292835;
        bh=MRDSB7rhHlkBX0jrG6+LA/MMI6OOLjy29jH3CybOzAA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sVmTX1abpJiy66dAdcpHnE/MXDFe14MfjVgUoF3CfNe3ovslifSeLivIJyKhZGCKz
         VeUI+sP9KKr1LZAV6h+qQ0OFnGWuQOREyLLvf4v5t+XKjT/xz+5PKRsb+ObeIH51S5
         BmcKO3Ufn2D2VZNqEfNccQo9mvjtWuVOClZLWGI8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@suse.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Rik van Riel <riel@surriel.com>
Subject: [PATCH 5.10 119/146] x86/process: Check PF_KTHREAD and not current->mm for kernel threads
Date:   Mon, 21 Jun 2021 18:15:49 +0200
Message-Id: <20210621154918.937006863@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210621154911.244649123@linuxfoundation.org>
References: <20210621154911.244649123@linuxfoundation.org>
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
@@ -578,7 +578,7 @@ static inline void switch_fpu_finish(str
 	 * PKRU state is switched eagerly because it needs to be valid before we
 	 * return to userland e.g. for a copy_to_user() operation.
 	 */
-	if (current->mm) {
+	if (!(current->flags & PF_KTHREAD)) {
 		pk = get_xsave_addr(&new_fpu->state.xsave, XFEATURE_PKRU);
 		if (pk)
 			pkru_val = pk->pkru;


