Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC6342F132D
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 14:05:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730232AbhAKNFD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 08:05:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:52086 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728701AbhAKNFB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Jan 2021 08:05:01 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 66A0822A83;
        Mon, 11 Jan 2021 13:04:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610370260;
        bh=cdJv1VEG5OSGN+1O3vbLqBapHrw/GEAdzxMBqNrgURU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XnR7x6RUngfaQsZXpASAj7zUTXVC/zPlybhyrtK8Kf/JnCumLcNHFk9uYafgduveL
         8VlMbP0bJX8s11mzLPMonpaY7lVWSdYE7KtdyFGyg3UyfS6DytNqGfkjkfFoPn9D8m
         BxzpttshBlergHelNGWXJSAl2NWJCr5oq05hHV9M=
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
Subject: [PATCH 4.9 19/45] scripts/gdb: lx-dmesg: use explicit encoding=utf8 errors=replace
Date:   Mon, 11 Jan 2021 14:00:57 +0100
Message-Id: <20210111130034.576856426@linuxfoundation.org>
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

commit 46d10a094353c05144f3b0530516bdac3ce7c435 upstream

Use errors=replace because it is never desirable for lx-dmesg to fail on
string decoding errors, not even if the log buffer is corrupt and we
show incorrect info.

The kernel will sometimes print utf8, for example the copyright symbol
from jffs2.  In order to make this work specify 'utf8' everywhere
because python2 otherwise defaults to 'ascii'.

In theory the second errors='replace' is not be required because
everything that can be decoded as utf8 should also be encodable back to
utf8.  But it's better to be extra safe here.  It's worth noting that
this is definitely not true for encoding='ascii', unknown characters are
replaced with U+FFFD REPLACEMENT CHARACTER and they fail to encode back
to ascii.

Link: http://lkml.kernel.org/r/acee067f3345954ed41efb77b80eebdc038619c6.1498481469.git.leonard.crestez@nxp.com
Signed-off-by: Leonard Crestez <leonard.crestez@nxp.com>
Acked-by: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Jason Wessel <jason.wessel@windriver.com>
Cc: Kieran Bingham <kieran@ksquared.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/gdb/linux/dmesg.py | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/scripts/gdb/linux/dmesg.py b/scripts/gdb/linux/dmesg.py
index f5a030333dfd8..6d2e09a2ad2f9 100644
--- a/scripts/gdb/linux/dmesg.py
+++ b/scripts/gdb/linux/dmesg.py
@@ -12,6 +12,7 @@
 #
 
 import gdb
+import sys
 
 from linux import utils
 
@@ -52,13 +53,19 @@ class LxDmesg(gdb.Command):
                 continue
 
             text_len = utils.read_u16(log_buf[pos + 10:pos + 12])
-            text = log_buf[pos + 16:pos + 16 + text_len].decode()
+            text = log_buf[pos + 16:pos + 16 + text_len].decode(
+                encoding='utf8', errors='replace')
             time_stamp = utils.read_u64(log_buf[pos:pos + 8])
 
             for line in text.splitlines():
-                gdb.write("[{time:12.6f}] {line}\n".format(
+                msg = u"[{time:12.6f}] {line}\n".format(
                     time=time_stamp / 1000000000.0,
-                    line=line))
+                    line=line)
+                # With python2 gdb.write will attempt to convert unicode to
+                # ascii and might fail so pass an utf8-encoded str instead.
+                if sys.hexversion < 0x03000000:
+                    msg = msg.encode(encoding='utf8', errors='replace')
+                gdb.write(msg)
 
             pos += length
 
-- 
2.27.0



