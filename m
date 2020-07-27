Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D641D22EF6F
	for <lists+stable@lfdr.de>; Mon, 27 Jul 2020 16:16:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730868AbgG0OQ1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jul 2020 10:16:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:43378 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730860AbgG0OQ0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Jul 2020 10:16:26 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 862B92078E;
        Mon, 27 Jul 2020 14:16:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595859386;
        bh=XWAO2rDwOr0pL/+FcfDAObp3HO8jmPTq0soq/G32Nt0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1YBTVaGFin6dUU11U7rfUcOZ295zX1gLlUfhU2uZ8rpnGRkTn7/WjyP6Ml0aeZL+e
         WV+icGLIAFMn/tqm89W1LdSnpJO+J9dYUr8dQ8wdbNqIeLqhi59EvD052mS20pKPZg
         AwF4QVcUzlcryT72X0lbS3j1HlWVoiQ/luFNh2J8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stefano Garzarella <sgarzare@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jan Kiszka <jan.kiszka@siemens.com>,
        Kieran Bingham <kbingham@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 070/138] scripts/gdb: fix lx-symbols gdb.error while loading modules
Date:   Mon, 27 Jul 2020 16:04:25 +0200
Message-Id: <20200727134928.892489201@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200727134925.228313570@linuxfoundation.org>
References: <20200727134925.228313570@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stefano Garzarella <sgarzare@redhat.com>

[ Upstream commit 7359608a271ce81803de148befefd309baf88c76 ]

Commit ed66f991bb19 ("module: Refactor section attr into bin attribute")
removed the 'name' field from 'struct module_sect_attr' triggering the
following error when invoking lx-symbols:

  (gdb) lx-symbols
  loading vmlinux
  scanning for modules in linux/build
  loading @0xffffffffc014f000: linux/build/drivers/net/tun.ko
  Python Exception <class 'gdb.error'> There is no member named name.:
  Error occurred in Python: There is no member named name.

This patch fixes the issue taking the module name from the 'struct
attribute'.

Fixes: ed66f991bb19 ("module: Refactor section attr into bin attribute")
Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Jan Kiszka <jan.kiszka@siemens.com>
Reviewed-by: Kieran Bingham <kbingham@kernel.org>
Link: http://lkml.kernel.org/r/20200722102239.313231-1-sgarzare@redhat.com
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/gdb/linux/symbols.py | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/gdb/linux/symbols.py b/scripts/gdb/linux/symbols.py
index be984aa29b759..1be9763cf8bb2 100644
--- a/scripts/gdb/linux/symbols.py
+++ b/scripts/gdb/linux/symbols.py
@@ -96,7 +96,7 @@ lx-symbols command."""
             return ""
         attrs = sect_attrs['attrs']
         section_name_to_address = {
-            attrs[n]['name'].string(): attrs[n]['address']
+            attrs[n]['battr']['attr']['name'].string(): attrs[n]['address']
             for n in range(int(sect_attrs['nsections']))}
         args = []
         for section_name in [".data", ".data..read_mostly", ".rodata", ".bss",
-- 
2.25.1



