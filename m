Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BEC5781C12
	for <lists+stable@lfdr.de>; Mon,  5 Aug 2019 15:21:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730045AbfHENT4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Aug 2019 09:19:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:56084 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730013AbfHENTz (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Aug 2019 09:19:55 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4962C20657;
        Mon,  5 Aug 2019 13:19:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565011194;
        bh=DfTlh4hBVU3O1J3/0AvaO8iFXFFIPu/0VhA469P66pM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tjnkC5C1pCLOk6v47PD+0q+r3G5WYQihEvs/Yw+lvAoT9VpRD0EPzJSB3ecojkrup
         jcl9rsYD0KRyhp04jIEB1nt9Fs5fTsEYskn1IZXJOv85l6qWdErZ0eDTvNCO36ztQ6
         R7KIKm1UHJ7R5Gw+oetdwPnDlR7ZJX0ZMPSKSNpQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sven Schnelle <svens@stackframe.org>,
        Helge Deller <deller@gmx.de>
Subject: [PATCH 4.19 56/74] parisc: Fix build of compressed kernel even with debug enabled
Date:   Mon,  5 Aug 2019 15:03:09 +0200
Message-Id: <20190805124940.401662872@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190805124935.819068648@linuxfoundation.org>
References: <20190805124935.819068648@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Helge Deller <deller@gmx.de>

commit 3fe6c873af2f2247544debdbe51ec29f690a2ccf upstream.

With debug info enabled (CONFIG_DEBUG_INFO=y) the resulting vmlinux may get
that huge that we need to increase the start addresss for the decompression
text section otherwise one will face a linker error.

Reported-by: Sven Schnelle <svens@stackframe.org>
Tested-by: Sven Schnelle <svens@stackframe.org>
Cc: stable@vger.kernel.org # v4.14+
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/parisc/boot/compressed/vmlinux.lds.S |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/parisc/boot/compressed/vmlinux.lds.S
+++ b/arch/parisc/boot/compressed/vmlinux.lds.S
@@ -42,8 +42,8 @@ SECTIONS
 #endif
 	_startcode_end = .;
 
-	/* bootloader code and data starts behind area of extracted kernel */
-	. = (SZ_end - SZparisc_kernel_start + KERNEL_BINARY_TEXT_START);
+	/* bootloader code and data starts at least behind area of extracted kernel */
+	. = MAX(ABSOLUTE(.), (SZ_end - SZparisc_kernel_start + KERNEL_BINARY_TEXT_START));
 
 	/* align on next page boundary */
 	. = ALIGN(4096);


