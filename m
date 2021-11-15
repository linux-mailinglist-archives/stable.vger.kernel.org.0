Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E0DF4512AD
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 20:41:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347205AbhKOTjD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 14:39:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:43994 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244953AbhKOTSQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:18:16 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7CE43634E9;
        Mon, 15 Nov 2021 18:26:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637000776;
        bh=wPAEVYKNn6CWEc71PQMoSyzC81MqcZcdF0MqNnBsPfo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XOeiyytd8kdWMQiOBnpY/0S/rfbV/wHWdE8sSmMN7Sf9XSdDmASB6PNQonUn+96zo
         YxDl3NfpIOSm/W3oNFmlJJm4+aaS5VEdftmUFLcUu6KwF/gvbMOa4s4fPdSSIBSEBE
         oWn+eFwTfwzl07XcI5kx4sVSSNGvk0fyKQurNmME=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Helge Deller <deller@gmx.de>,
        stable@kernel.org
Subject: [PATCH 5.14 788/849] parisc: Fix backtrace to always include init funtion names
Date:   Mon, 15 Nov 2021 18:04:31 +0100
Message-Id: <20211115165446.896298951@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
References: <20211115165419.961798833@linuxfoundation.org>
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


