Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E8F324541D
	for <lists+stable@lfdr.de>; Sun, 16 Aug 2020 00:12:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730100AbgHOWMc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 15 Aug 2020 18:12:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:41774 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728986AbgHOWK2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 15 Aug 2020 18:10:28 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6D64A22D6E;
        Sat, 15 Aug 2020 00:31:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597451518;
        bh=fJVlPQ8S+Vb1lUADaMYvE/9l8Sv+WGSYYmGjTZWeVdg=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=RjA4wiORZGHOy3Wc5AbkI6/Q5fEtbY0vbjcFXp+QkyddTPtb2bVWU9gheOTiY7By8
         sog9uh/43UeVCPz8qs3rWzZI5UYhXFrM7CZ1v4IRKz8fOKFtflBlCBMWGKH/4n5+De
         gIvRlCq+2k9zzUMyWP5pXWMcdPnPOj90a2xVL9nc=
Date:   Fri, 14 Aug 2020 17:31:57 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, amodra@gmail.com, arnd@arndb.de,
        bin.meng@windriver.com, chenzhou10@huawei.com, dalias@libc.org,
        geert+renesas@glider.be, glaubitz@physik.fu-berlin.de,
        krzk@kernel.org, kuninori.morimoto.gx@renesas.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        romain.naour@gmail.com, sam@ravnborg.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, ysato@users.sourceforge.jp
Subject:  [patch 33/39] include/asm-generic/vmlinux.lds.h: align
 ro_after_init
Message-ID: <20200815003157.IkJmRN7N5%akpm@linux-foundation.org>
In-Reply-To: <20200814172939.55d6d80b6e21e4241f1ee1f3@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Romain Naour <romain.naour@gmail.com>
Subject: include/asm-generic/vmlinux.lds.h: align ro_after_init

Since the patch [1], building the kernel using a toolchain built with
binutils 2.33.1 prevents booting a sh4 system under Qemu.  Apply the patch
provided by Alan Modra [2] that fix alignment of rodata.

[1] https://sourceware.org/git/gitweb.cgi?p=binutils-gdb.git;h=ebd2263ba9a9124d93bbc0ece63d7e0fae89b40e
[2] https://www.sourceware.org/ml/binutils/2019-12/msg00112.html

Link: https://marc.info/?l=linux-sh&m=158429470221261
Signed-off-by: Romain Naour <romain.naour@gmail.com>
Cc: Alan Modra <amodra@gmail.com>
Cc: Bin Meng <bin.meng@windriver.com>
Cc: Chen Zhou <chenzhou10@huawei.com>
Cc: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Cc: Krzysztof Kozlowski <krzk@kernel.org>
Cc: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Cc: Rich Felker <dalias@libc.org>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/vmlinux.lds.h |    1 +
 1 file changed, 1 insertion(+)

--- a/include/asm-generic/vmlinux.lds.h~include-asm-generic-vmlinuxldsh-align-ro_after_init
+++ a/include/asm-generic/vmlinux.lds.h
@@ -394,6 +394,7 @@
  */
 #ifndef RO_AFTER_INIT_DATA
 #define RO_AFTER_INIT_DATA						\
+	. = ALIGN(8);							\
 	__start_ro_after_init = .;					\
 	*(.data..ro_after_init)						\
 	JUMP_TABLE_DATA							\
_
