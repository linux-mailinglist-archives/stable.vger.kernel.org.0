Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 558E62F132E
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 14:05:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730245AbhAKNFE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 08:05:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:52134 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730233AbhAKNFD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Jan 2021 08:05:03 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8DA6B227C3;
        Mon, 11 Jan 2021 13:04:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610370263;
        bh=MNzc3lxfUsVjdBpXvAUld9FBtVQL0kgZFFUki9bkwW0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E7EYRI3xImjMOthgjaARfQGXlMWujzdUMBDVBP3Kc2ka7RLRo5dJodscTtvBBrD19
         bh+NWf0rS11qq9Alf8NoLrQyPgLjIYGPV6FGrLqS7XVw+gGAdo0pgekIckEXl6xL//
         WyCxOqEei5h0pZAk3i0zlJOK9csrNZnl994k7ZS8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Du Changbin <changbin.du@gmail.com>,
        Kieran Bingham <kbingham@kernel.org>,
        Jan Kiszka <jan.kiszka@siemens.com>,
        Jason Wessel <jason.wessel@windriver.com>,
        Daniel Thompson <daniel.thompson@linaro.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 20/45] scripts/gdb: fix lx-version string output
Date:   Mon, 11 Jan 2021 14:00:58 +0100
Message-Id: <20210111130034.626067438@linuxfoundation.org>
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

From: Du Changbin <changbin.du@gmail.com>

commit b058809bfc8faeb7b7cae047666e23375a060059 upstream

A bug is present in GDB which causes early string termination when
parsing variables.  This has been reported [0], but we should ensure
that we can support at least basic printing of the core kernel strings.

For current gdb version (has been tested with 7.3 and 8.1), 'lx-version'
only prints one character.

  (gdb) lx-version
  L(gdb)

This can be fixed by casting 'linux_banner' as (char *).

  (gdb) lx-version
  Linux version 4.19.0-rc1+ (changbin@acer) (gcc version 7.3.0 (Ubuntu 7.3.0-16ubuntu3)) #21 SMP Sat Sep 1 21:43:30 CST 2018

[0] https://sourceware.org/bugzilla/show_bug.cgi?id=20077

[kbingham@kernel.org: add detail to commit message]
Link: http://lkml.kernel.org/r/20181111162035.8356-1-kieran.bingham@ideasonboard.com
Fixes: 2d061d999424 ("scripts/gdb: add version command")
Signed-off-by: Du Changbin <changbin.du@gmail.com>
Signed-off-by: Kieran Bingham <kbingham@kernel.org>
Acked-by: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Jason Wessel <jason.wessel@windriver.com>
Cc: Daniel Thompson <daniel.thompson@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/gdb/linux/proc.py | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/gdb/linux/proc.py b/scripts/gdb/linux/proc.py
index 38b1f09d1cd95..822e3767bc054 100644
--- a/scripts/gdb/linux/proc.py
+++ b/scripts/gdb/linux/proc.py
@@ -40,7 +40,7 @@ class LxVersion(gdb.Command):
 
     def invoke(self, arg, from_tty):
         # linux_banner should contain a newline
-        gdb.write(gdb.parse_and_eval("linux_banner").string())
+        gdb.write(gdb.parse_and_eval("(char *)linux_banner").string())
 
 LxVersion()
 
-- 
2.27.0



