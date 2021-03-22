Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4AAEB344346
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 13:51:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232101AbhCVMtY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 08:49:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:40980 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232577AbhCVMry (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Mar 2021 08:47:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D1C74619B2;
        Mon, 22 Mar 2021 12:43:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616417026;
        bh=xb6ghuOPd3lUfE0yZi8fZ0KJp+paEtbTLac7jBrUwts=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jKIIblSQzq0CFiSeYOcvi/elEGeaN4Gf3JUZ58AsIe7wy1VZBmRGrajYYQw0gFWoE
         3LOZYQ/zmRh8COUOECd0tvwGsUhRHByhX6iS+Hfv0DxFT9NvVWuG2xrHFUrSfRIO+x
         Evz7nt8J49x488XEchyUYyWFA2aMjqE7uDrNUwmw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH 5.4 57/60] efi: use 32-bit alignment for efi_guid_t literals
Date:   Mon, 22 Mar 2021 13:28:45 +0100
Message-Id: <20210322121924.261609295@linuxfoundation.org>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210322121922.372583154@linuxfoundation.org>
References: <20210322121922.372583154@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ard Biesheuvel <ardb@kernel.org>

commit fb98cc0b3af2ba4d87301dff2b381b12eee35d7d upstream.

Commit 494c704f9af0 ("efi: Use 32-bit alignment for efi_guid_t") updated
the type definition of efi_guid_t to ensure that it always appears
sufficiently aligned (the UEFI spec is ambiguous about this, but given
the fact that its EFI_GUID type is defined in terms of a struct carrying
a uint32_t, the natural alignment is definitely >= 32 bits).

However, we missed the EFI_GUID() macro which is used to instantiate
efi_guid_t literals: that macro is still based on the guid_t type,
which does not have a minimum alignment at all. This results in warnings
such as

  In file included from drivers/firmware/efi/mokvar-table.c:35:
  include/linux/efi.h:1093:34: warning: passing 1-byte aligned argument to
      4-byte aligned parameter 2 of 'get_var' may result in an unaligned pointer
      access [-Walign-mismatch]
          status = get_var(L"SecureBoot", &EFI_GLOBAL_VARIABLE_GUID, NULL, &size,
                                          ^
  include/linux/efi.h:1101:24: warning: passing 1-byte aligned argument to
      4-byte aligned parameter 2 of 'get_var' may result in an unaligned pointer
      access [-Walign-mismatch]
          get_var(L"SetupMode", &EFI_GLOBAL_VARIABLE_GUID, NULL, &size, &setupmode);

The distinction only matters on CPUs that do not support misaligned loads
fully, but 32-bit ARM's load-multiple instructions fall into that category,
and these are likely to be emitted by the compiler that built the firmware
for loading word-aligned 128-bit GUIDs from memory

So re-implement the initializer in terms of our own efi_guid_t type, so that
the alignment becomes a property of the literal's type.

Fixes: 494c704f9af0 ("efi: Use 32-bit alignment for efi_guid_t")
Reported-by: Nathan Chancellor <nathan@kernel.org>
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Reviewed-by: Nathan Chancellor <nathan@kernel.org>
Tested-by: Nathan Chancellor <nathan@kernel.org>
Link: https://github.com/ClangBuiltLinux/linux/issues/1327
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/efi.h |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -63,8 +63,10 @@ typedef void *efi_handle_t;
  */
 typedef guid_t efi_guid_t __aligned(__alignof__(u32));
 
-#define EFI_GUID(a,b,c,d0,d1,d2,d3,d4,d5,d6,d7) \
-	GUID_INIT(a, b, c, d0, d1, d2, d3, d4, d5, d6, d7)
+#define EFI_GUID(a, b, c, d...) (efi_guid_t){ {					\
+	(a) & 0xff, ((a) >> 8) & 0xff, ((a) >> 16) & 0xff, ((a) >> 24) & 0xff,	\
+	(b) & 0xff, ((b) >> 8) & 0xff,						\
+	(c) & 0xff, ((c) >> 8) & 0xff, d } }
 
 /*
  * Generic EFI table header


