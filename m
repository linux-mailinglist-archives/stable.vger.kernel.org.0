Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 358182F174F
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 15:05:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730540AbhAKOEX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 09:04:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:50872 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727240AbhAKNEe (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Jan 2021 08:04:34 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3D61F225AC;
        Mon, 11 Jan 2021 13:04:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610370258;
        bh=wgeo/9ZxwN7eV7fX8EbVut2OEmo91pKsRnd8cwzn0nU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uEpjuaNwag6mtUel4trfCFoSnirfJAam+DQIrAbJ6BMVGHN5N/GT+2vbcGOjNPJpR
         N3trf9f4UBOV0L2/vT3iMKecuS9ZP0xh9Ph5GjnVQ51yhp5OaZY5JYc18clE2EGXUo
         S9h4oxHHt/3aIFhggNFE08mUvMvUDvdW7v5Rixyc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Leonard Crestez <leonard.crestez@nxp.com>,
        Jan Kiszka <jan.kiszka@siemens.com>,
        Jason Wessel <jason.wessel@windriver.com>,
        Kieran Bingham <kieran@ksquared.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 18/45] scripts/gdb: lx-dmesg: cast log_buf to void* for addr fetch
Date:   Mon, 11 Jan 2021 14:00:56 +0100
Message-Id: <20210111130034.536509884@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210111130033.676306636@linuxfoundation.org>
References: <20210111130033.676306636@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Leonard Crestez <leonard.crestez@nxp.com>

commit c454756f47277b651ad41a5a163499294529e35d upstream

In some cases it is possible for the str() conversion here to throw
encoding errors because log_buf might not point to valid ascii.  For
example:

  (gdb) python print str(gdb.parse_and_eval("log_buf"))
  Traceback (most recent call last):
    File "<string>", line 1, in <module>
  UnicodeEncodeError: 'ascii' codec can't encode character u'\u0303' in
  	position 24: ordinal not in range(128)

Avoid this by explicitly casting to (void *) inside the gdb expression.

Link: http://lkml.kernel.org/r/ba6f85dbb02ca980ebd0e2399b0649423399b565.1498481469.git.leonard.crestez@nxp.com
Signed-off-by: Leonard Crestez <leonard.crestez@nxp.com>
Reviewed-by: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Jason Wessel <jason.wessel@windriver.com>
Cc: Kieran Bingham <kieran@ksquared.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/gdb/linux/dmesg.py | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/gdb/linux/dmesg.py b/scripts/gdb/linux/dmesg.py
index 5afd1098e33a1..f5a030333dfd8 100644
--- a/scripts/gdb/linux/dmesg.py
+++ b/scripts/gdb/linux/dmesg.py
@@ -24,7 +24,7 @@ class LxDmesg(gdb.Command):
 
     def invoke(self, arg, from_tty):
         log_buf_addr = int(str(gdb.parse_and_eval(
-            "'printk.c'::log_buf")).split()[0], 16)
+            "(void *)'printk.c'::log_buf")).split()[0], 16)
         log_first_idx = int(gdb.parse_and_eval("'printk.c'::log_first_idx"))
         log_next_idx = int(gdb.parse_and_eval("'printk.c'::log_next_idx"))
         log_buf_len = int(gdb.parse_and_eval("'printk.c'::log_buf_len"))
-- 
2.27.0



