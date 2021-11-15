Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16FF2451E7E
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 01:33:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347947AbhKPAgQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 19:36:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:45396 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344986AbhKOTZx (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:25:53 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6051A6324F;
        Mon, 15 Nov 2021 19:08:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637003292;
        bh=wPAEVYKNn6CWEc71PQMoSyzC81MqcZcdF0MqNnBsPfo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WoC9XXXo0fKshW5wc2Zbvku+Dbgwsd90Jp/DHXjxMU0ApdxOmwD70S4nhQBt4VMUG
         UfpRUBsr78E1bPyWRvpTTnxhJoBT15Sq/eh9ZK4cwhACapwFZh0+DJkxgU/8n+W+q7
         NPNjxtyvnL70GVlaoFu+BY4aj0faWlgCKagaAssQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Helge Deller <deller@gmx.de>,
        stable@kernel.org
Subject: [PATCH 5.15 849/917] parisc: Fix backtrace to always include init funtion names
Date:   Mon, 15 Nov 2021 18:05:44 +0100
Message-Id: <20211115165457.819807966@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Helge Deller <deller@gmx.de>

commit 279917e27edc293eb645a25428c6ab3f3bca3f86 upstream.

I noticed that sometimes at kernel startup the backtraces did not
included the function names of init functions. Their address were not
resolved to function names and instead only the address was printed.

Debugging shows that the culprit is is_ksym_addr() which is called
by the backtrace functions to check if an address belongs to a function in
the kernel. The problem occurs only for CONFIG_KALLSYMS_ALL=y.

When looking at is_ksym_addr() one can see that for CONFIG_KALLSYMS_ALL=y
the function only tries to resolve the address via is_kernel() function,
which checks like this:
	if (addr >= _stext && addr <= _end)
                return 1;
On parisc the init functions are located before _stext, so this check fails.
Other platforms seem to have all functions (including init functions)
behind _stext.

The following patch moves the _stext symbol at the beginning of the
kernel and thus includes the init section. This fixes the check and does
not seem to have any negative side effects on where the kernel mapping
happens in the map_pages() function in arch/parisc/mm/init.c.

Signed-off-by: Helge Deller <deller@gmx.de>
Cc: stable@kernel.org # 5.4+
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/parisc/kernel/vmlinux.lds.S |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/arch/parisc/kernel/vmlinux.lds.S
+++ b/arch/parisc/kernel/vmlinux.lds.S
@@ -57,6 +57,8 @@ SECTIONS
 {
 	. = KERNEL_BINARY_TEXT_START;
 
+	_stext = .;	/* start of kernel text, includes init code & data */
+
 	__init_begin = .;
 	HEAD_TEXT_SECTION
 	MLONGCALL_DISCARD(INIT_TEXT_SECTION(8))
@@ -80,7 +82,6 @@ SECTIONS
 	/* freed after init ends here */
 
 	_text = .;		/* Text and read-only data */
-	_stext = .;
 	MLONGCALL_KEEP(INIT_TEXT_SECTION(8))
 	.text ALIGN(PAGE_SIZE) : {
 		TEXT_TEXT


