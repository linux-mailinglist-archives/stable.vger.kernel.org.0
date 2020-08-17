Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F29F6246ECF
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 19:37:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731218AbgHQRhT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 13:37:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:60674 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731126AbgHQQR0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 12:17:26 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 861F122D75;
        Mon, 17 Aug 2020 16:17:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597681046;
        bh=GaKZpibvl55yEfEPD8v9wKz43HpfjTVzXL42KAY9MRs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eY7uuTe3R7fbIHRlcG64JWKa+JcEn5LICFrdgC7X+GYeP96Op719lMzKrvRDrkdrM
         nBJ5MZvBj6HigyUW3qiRhI3mzI54cHYnbkSyIN8drhKjgXxL/Nb0ZiPjaIcO0yyay8
         +MyBbUrvFvDNsTJI3HPu7zs9zn28jjv31zeJrHpo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Romain Naour <romain.naour@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alan Modra <amodra@gmail.com>,
        Bin Meng <bin.meng@windriver.com>,
        Chen Zhou <chenzhou10@huawei.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Rich Felker <dalias@libc.org>, Sam Ravnborg <sam@ravnborg.org>,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        Arnd Bergmann <arnd@arndb.de>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 4.19 159/168] include/asm-generic/vmlinux.lds.h: align ro_after_init
Date:   Mon, 17 Aug 2020 17:18:10 +0200
Message-Id: <20200817143741.613213351@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143733.692105228@linuxfoundation.org>
References: <20200817143733.692105228@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Romain Naour <romain.naour@gmail.com>

commit 7f897acbe5d57995438c831670b7c400e9c0dc00 upstream.

Since the patch [1], building the kernel using a toolchain built with
binutils 2.33.1 prevents booting a sh4 system under Qemu.  Apply the patch
provided by Alan Modra [2] that fix alignment of rodata.

[1] https://sourceware.org/git/gitweb.cgi?p=binutils-gdb.git;h=ebd2263ba9a9124d93bbc0ece63d7e0fae89b40e
[2] https://www.sourceware.org/ml/binutils/2019-12/msg00112.html

Signed-off-by: Romain Naour <romain.naour@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
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
Link: https://marc.info/?l=linux-sh&m=158429470221261
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/asm-generic/vmlinux.lds.h |    1 +
 1 file changed, 1 insertion(+)

--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -307,6 +307,7 @@
  */
 #ifndef RO_AFTER_INIT_DATA
 #define RO_AFTER_INIT_DATA						\
+	. = ALIGN(8);							\
 	__start_ro_after_init = .;					\
 	*(.data..ro_after_init)						\
 	__end_ro_after_init = .;


