Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC0C02A5875
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 22:52:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731429AbgKCVv7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 16:51:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:38234 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729755AbgKCUrj (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 15:47:39 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7703320719;
        Tue,  3 Nov 2020 20:47:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604436458;
        bh=jI3Cd8S5TC6bdEQGTUGZ9Z/qBcFj1Xd8718enX3wlc4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UOP3BhmlGyDk5n8Qiani8CLmgU3yg1ikb+0uj2q/X8ccQjNo+zNx4zZiWgXVoyA88
         JgbGuGkWdoyzB6alklA6H2QXdjaEaxe/6JGQosEF/OSRYOoAVY06gsmaZ3bfyawCn/
         /VM9c0HyfO/keOPwT9A+Rz6hEURddQt5la1D1oUg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Borislav Petkov <bp@suse.de>
Subject: [PATCH 5.9 258/391] x86/mce: Allow for copy_mc_fragile symbol checksum to be generated
Date:   Tue,  3 Nov 2020 21:35:09 +0100
Message-Id: <20201103203404.432681667@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203348.153465465@linuxfoundation.org>
References: <20201103203348.153465465@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

commit b3149ffcdb31a8eb854cc442a389ae0b539bf28a upstream.

Add asm/mce.h to asm/asm-prototypes.h so that that asm symbol's checksum
can be generated in order to support CONFIG_MODVERSIONS with it and fix:

  WARNING: modpost: EXPORT symbol "copy_mc_fragile" [vmlinux] version \
	  generation failed, symbol will not be versioned.

For reference see:

  4efca4ed05cb ("kbuild: modversions for EXPORT_SYMBOL() for asm")
  334bb7738764 ("x86/kbuild: enable modversions for symbols exported from asm")

Fixes: ec6347bb4339 ("x86, powerpc: Rename memcpy_mcsafe() to copy_mc_to_{user, kernel}()")
Signed-off-by: Borislav Petkov <bp@suse.de>
Link: https://lkml.kernel.org/r/20201007111447.GA23257@zn.tnic
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/include/asm/asm-prototypes.h |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/x86/include/asm/asm-prototypes.h
+++ b/arch/x86/include/asm/asm-prototypes.h
@@ -5,6 +5,7 @@
 #include <asm/string.h>
 #include <asm/page.h>
 #include <asm/checksum.h>
+#include <asm/mce.h>
 
 #include <asm-generic/asm-prototypes.h>
 


