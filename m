Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8E333111F44
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 00:10:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729225AbfLCWqs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Dec 2019 17:46:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:36610 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728487AbfLCWqr (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Dec 2019 17:46:47 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 81B2E2080F;
        Tue,  3 Dec 2019 22:46:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575413206;
        bh=vAnPksW0U2gh/kfgefM3vVRIFgL1xdGj0P8wJE6kLOE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hzbf5L6SQFQvBil3+dd3tQ30Oq8aFquad2PnIOZWkbFWdwt6Rzm8OHhEuRjmadN6z
         g6BNUe2QbIX/YeyuuGiDuof2sfvc6Y672EiPcIVhsuo8GOC1X3uDy7bLr5pS/MQ6vu
         l1IoxBN3x7bYvf1D38q5MlqP64gg7Eo3M2+2yL+I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ilya Leoshkevich <iii@linux.ibm.com>,
        Jan Kiszka <jan.kiszka@siemens.com>,
        Kieran Bingham <kbingham@kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 038/321] scripts/gdb: fix debugging modules compiled with hot/cold partitioning
Date:   Tue,  3 Dec 2019 23:31:44 +0100
Message-Id: <20191203223429.093986368@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191203223427.103571230@linuxfoundation.org>
References: <20191203223427.103571230@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ilya Leoshkevich <iii@linux.ibm.com>

[ Upstream commit 8731acc5068eb3f422a45c760d32198175c756f8 ]

gcc's -freorder-blocks-and-partition option makes it group frequently
and infrequently used code in .text.hot and .text.unlikely sections
respectively.  At least when building modules on s390, this option is
used by default.

gdb assumes that all code is located in .text section, and that .text
section is located at module load address.  With such modules this is no
longer the case: there is code in .text.hot and .text.unlikely, and
either of them might precede .text.

Fix by explicitly telling gdb the addresses of code sections.

It might be tempting to do this for all sections, not only the ones in
the white list.  Unfortunately, gdb appears to have an issue, when
telling it about e.g. loadable .note.gnu.build-id section causes it to
think that non-loadable .note.Linux section is loaded at address 0,
which in turn causes NULL pointers to be resolved to bogus symbols.  So
keep using the white list approach for the time being.

Link: http://lkml.kernel.org/r/20191028152734.13065-1-iii@linux.ibm.com
Signed-off-by: Ilya Leoshkevich <iii@linux.ibm.com>
Reviewed-by: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Kieran Bingham <kbingham@kernel.org>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/gdb/linux/symbols.py | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/scripts/gdb/linux/symbols.py b/scripts/gdb/linux/symbols.py
index 004b0ac7fa72d..4644f1a83b578 100644
--- a/scripts/gdb/linux/symbols.py
+++ b/scripts/gdb/linux/symbols.py
@@ -99,7 +99,8 @@ lx-symbols command."""
             attrs[n]['name'].string(): attrs[n]['address']
             for n in range(int(sect_attrs['nsections']))}
         args = []
-        for section_name in [".data", ".data..read_mostly", ".rodata", ".bss"]:
+        for section_name in [".data", ".data..read_mostly", ".rodata", ".bss",
+                             ".text", ".text.hot", ".text.unlikely"]:
             address = section_name_to_address.get(section_name)
             if address:
                 args.append(" -s {name} {addr}".format(
-- 
2.20.1



