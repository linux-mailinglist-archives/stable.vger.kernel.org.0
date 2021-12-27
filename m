Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC13C47FE70
	for <lists+stable@lfdr.de>; Mon, 27 Dec 2021 16:29:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237403AbhL0P3H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Dec 2021 10:29:07 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:59430 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237526AbhL0P2o (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Dec 2021 10:28:44 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8ABF9610A7;
        Mon, 27 Dec 2021 15:28:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71C94C36AE7;
        Mon, 27 Dec 2021 15:28:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640618923;
        bh=xb4tb8uy3L7bcElN1Su5MwnCoifGY8U9WwZMcQL9OpE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dsoA+7sZqVvggN273LqcSFU1I/KRDlQwQ2WuVDWRy8fBAbBZXCRgLehpBAkaP/Wl0
         zSl7R5an46vuz3NbTYewP9sZnEQE7TcJpu0jUPOFheH3CTWgSmsC1T0xz2JqFj6pMs
         iysr46IGu4u/JeFNAnxP3aZMqwiqZr/C2W8D2rZY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrew Cooper <andrew.cooper3@citrix.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Borislav Petkov <bp@suse.de>
Subject: [PATCH 4.9 12/19] x86/pkey: Fix undefined behaviour with PKRU_WD_BIT
Date:   Mon, 27 Dec 2021 16:27:14 +0100
Message-Id: <20211227151316.946081190@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211227151316.558965545@linuxfoundation.org>
References: <20211227151316.558965545@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrew Cooper <andrew.cooper3@citrix.com>

commit 57690554abe135fee81d6ac33cc94d75a7e224bb upstream.

Both __pkru_allows_write() and arch_set_user_pkey_access() shift
PKRU_WD_BIT (a signed constant) by up to 30 bits, hitting the
sign bit.

Use unsigned constants instead.

Clearly pkey 15 has not been used in combination with UBSAN yet.

Noticed by code inspection only.  I can't actually provoke the
compiler into generating incorrect logic as far as this shift is
concerned.

[
  dhansen: add stable@ tag, plus minor changelog massaging,

           For anyone doing backports, these #defines were in
	   arch/x86/include/asm/pgtable.h before 784a46618f6.
]

Fixes: 33a709b25a76 ("mm/gup, x86/mm/pkeys: Check VMAs and PTEs for protection keys")
Signed-off-by: Andrew Cooper <andrew.cooper3@citrix.com>
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Cc: stable@vger.kernel.org
Link: https://lkml.kernel.org/r/20211216000856.4480-1-andrew.cooper3@citrix.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/pgtable.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/x86/include/asm/pgtable.h
+++ b/arch/x86/include/asm/pgtable.h
@@ -1028,8 +1028,8 @@ static inline pte_t pte_swp_clear_soft_d
 }
 #endif
 
-#define PKRU_AD_BIT 0x1
-#define PKRU_WD_BIT 0x2
+#define PKRU_AD_BIT 0x1u
+#define PKRU_WD_BIT 0x2u
 #define PKRU_BITS_PER_PKEY 2
 
 static inline bool __pkru_allows_read(u32 pkru, u16 pkey)


