Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B1C2378718
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 13:33:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235954AbhEJLNr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 07:13:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:40838 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235947AbhEJLHC (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 07:07:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D98A26190A;
        Mon, 10 May 2021 10:57:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620644228;
        bh=ahQev9HGYs11+GX2q1VKcRSLanEQ+OQUkZvga66ODYk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oERnNQF/iqxytmbsuTfePtD5uLpijk7cY52Mv8mLz2esXUchtyxzXxMIulUrKy2i+
         +KIvCu7PNHM5sjLMWwZR6LFN09jGYSrpaZo0DxEkSwkagSklrrv8BYUpdI44BTtBcm
         wtzwVTRCQJSjzB0SDb/FxHIL8qBGUktzS13QGDe0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Petr Mladek <pmladek@suse.com>
Subject: [PATCH 5.11 340/342] lib/vsprintf.c: remove leftover f and F cases from bstr_printf()
Date:   Mon, 10 May 2021 12:22:10 +0200
Message-Id: <20210510102021.343919869@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102010.096403571@linuxfoundation.org>
References: <20210510102010.096403571@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rasmus Villemoes <linux@rasmusvillemoes.dk>

commit 84696cfaf4d90945eb2a8302edc6cf627db56b84 upstream.

Commit 9af7706492f9 ("lib/vsprintf: Remove support for %pF and %pf in
favour of %pS and %ps") removed support for %pF and %pf, and correctly
removed the handling of those cases in vbin_printf(). However, the
corresponding cases in bstr_printf() were left behind.

In the same series, %pf was re-purposed for dealing with
fwnodes (3bd32d6a2ee6, "lib/vsprintf: Add %pfw conversion specifier
for printing fwnode names").

So should anyone use %pf with the binary printf routines,
vbin_printf() would (correctly, as it involves dereferencing the
pointer) do the string formatting to the u32 array, but bstr_printf()
would not copy the string from the u32 array, but instead interpret
the first sizeof(void*) bytes of the formatted string as a pointer -
which generally won't end well (also, all subsequent get_args would be
out of sync).

Fixes: 9af7706492f9 ("lib/vsprintf: Remove support for %pF and %pf in favour of %pS and %ps")
Cc: stable@vger.kernel.org
Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Reviewed-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Petr Mladek <pmladek@suse.com>
Link: https://lore.kernel.org/r/20210423094529.1862521-1-linux@rasmusvillemoes.dk
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 lib/vsprintf.c |    2 --
 1 file changed, 2 deletions(-)

--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -3103,8 +3103,6 @@ int bstr_printf(char *buf, size_t size,
 			switch (*fmt) {
 			case 'S':
 			case 's':
-			case 'F':
-			case 'f':
 			case 'x':
 			case 'K':
 			case 'e':


