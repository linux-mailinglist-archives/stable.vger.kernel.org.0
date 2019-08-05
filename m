Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E22A81CB4
	for <lists+stable@lfdr.de>; Mon,  5 Aug 2019 15:26:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730715AbfHEN0I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Aug 2019 09:26:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:34632 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731372AbfHEN0F (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Aug 2019 09:26:05 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7029B20644;
        Mon,  5 Aug 2019 13:26:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565011564;
        bh=2iqeMQ6BayS9bS2utCwM9RRUDsXLJkPpLTa6/n5JQOk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VDxmqlkamfkYSvWpWvAycQgGBRwZAWqNJCMUEtgfUDt4E7R3GGDfHea/NlJt6TVwf
         NQJS/J4uhXBeSB05t2WPbPlIYgplq+UiFll7o1rFipN6PwsR0Wla9j8b8qEVL6F6oF
         3RFtraxGyZnisFW+PLLBYaC1DZCAbtq+yU1wTLyw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sven Schnelle <svens@stackframe.org>,
        Helge Deller <deller@gmx.de>
Subject: [PATCH 5.2 110/131] parisc: Fix build of compressed kernel even with debug enabled
Date:   Mon,  5 Aug 2019 15:03:17 +0200
Message-Id: <20190805124959.330035289@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190805124951.453337465@linuxfoundation.org>
References: <20190805124951.453337465@linuxfoundation.org>
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
@@ -48,8 +48,8 @@ SECTIONS
 		*(.rodata.compressed)
 	}
 
-	/* bootloader code and data starts behind area of extracted kernel */
-	. = (SZ_end - SZparisc_kernel_start + KERNEL_BINARY_TEXT_START);
+	/* bootloader code and data starts at least behind area of extracted kernel */
+	. = MAX(ABSOLUTE(.), (SZ_end - SZparisc_kernel_start + KERNEL_BINARY_TEXT_START));
 
 	/* align on next page boundary */
 	. = ALIGN(4096);


